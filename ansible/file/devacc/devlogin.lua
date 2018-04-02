local cjson = require ("cjson")
local redis_cluster = require("resty.redis_cluster")

local device_session_out_expire=6000
local dev_conn_addr ="50.226.99.162:6102,50.226.99.163:6102,50.226.99.164:6102,50.226.99.165:6102,50.226.99.166:6102,50.226.99.167:6102,50.233.84.11:6102,50.233.84.13:6102,50.233.84.14:6102,50.233.84.15:6102"
local heartbeat_interval=90
local dev_access_addr="https://11-devaccess.myzmodo.com,https://12-devaccess.myzmodo.com,https://13-devaccess.myzmodo.com,https://14-devaccess.myzmodo.com,https://21-devaccess.myzmodo.com,https://22-devaccess.myzmodo.com"
local alerts_addr = "https://11-alertsmng.myzmodo.com,https://12-alertsmng.myzmodo.com,https://13-alertsmng.myzmodo.com,https://14-alertsmng.myzmodo.com,https://15-alertsmng.myzmodo.com,https://16-alertsmng.myzmodo.com,https://17-alertsmng.myzmodo.com,https://18-alertsmng.myzmodo.com,https://21-alertsmng.myzmodo.com,https://22-alertsmng.myzmodo.com"
local file_server_addr = "https://11-alertsfile.myzmodo.com,https://12-alertsfile.myzmodo.com,https://13-alertsfile.myzmodo.com,https://14-alertsfile.myzmodo.com,https://15-alertsfile.myzmodo.com"
local dev_mng_addr = "https://1z3-Devmng2.myzmodo.com,https://1z4-Devmng2.myzmodo.com,https://1z5-Devmng2.myzmodo.com,https://1z6-Devmng2.myzmodo.com"

local redis_cluster_config = {
	name = "name",
	server = {
		{"10.80.6.152", 6402},
		{"10.80.6.153", 6402},
		{"10.80.6.154", 6402},
		{"10.80.6.155", 6402},
		{"10.80.6.156", 6402},
		{"10.80.6.157", 6402},
		{"10.80.6.152", 6403},
		{"10.80.6.153", 6403},
		{"10.80.6.154", 6403},
		{"10.80.6.155", 6403},
		{"10.80.6.156", 6403},
		{"10.80.6.157", 6403}
					},
	password        = "abc",
	idle_timeout    = 60000,
	pool_size       = 200,
}

local function random(n,m)
    math.randomseed(os.clock()*math.random(1000000,90000000)+math.random(1000000,9000000))
    return math.random(n,m)
end
local function shuffle(t)
    if type(t)~="table" then
        return
    end
    local l=#t
    local tab={}
    local index=1
    while #t~=0 do
        local n=math.random(0,#t)
        if t[n]~=nil then
            tab[index]=t[n]
            table.remove(t,n)
            index=index+1
        end
    end
    return tab
end
local function getRandomStoken(len)
   local table_chars={"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
    local rt = ""
	local newtable = shuffle(table_chars)
    for i=1,len,1 do
    rt = rt..newtable[random(1,62)]
    end
    return rt
end
local function GetAesKeyid()
	local resty_uuid=require("resty.uuid")
	local id=resty_uuid.generate_random()
	return string.upper(ngx.md5(id))
end

local function GetAesKey(id)
    local mc_ecb    = require("resty.ecb_mcrypt")
    local ecb       = mc_ecb:new();
    local enc_data  = ecb:encrypt("6A6116FF5F1D4FDA9787890B1C510EAD",id);
    --ngx.print(enc_data)
    return string.upper(ngx.md5(enc_data))
end

local function renderAjaxError(res)
    local data={}
    if res == "100300601" then	       
	    data.error="physical_id is not set value"
	elseif res == "100100096" then
	    data.error="redis connect fail"
	else 
	    data.error="other error"
	end
	data.result=res	
	local ret=cjson.encode(data)
	ngx.log(ngx.INFO,"error devlogin: ",ret)
	return ret
end



local function Devlogin()
	local tokenid
	local request_method = ngx.var.request_method
	local args = nil
	local physical_id = nil
    local device_token="device_token_"
	if "GET" == request_method then
		args = ngx.req.get_uri_args()
	elseif "POST" == request_method then
		ngx.req.read_body()
		args = ngx.req.get_post_args()
	end
	physical_id= args["physical_id"]
	if physical_id and #physical_id > 0 then
	   --logger:info(physical_id.."devlogin")
	   ngx.log(ngx.INFO,"physical_id:",physical_id)
	else	  
	   ngx.say(renderAjaxError("100300601"))	  
	   return 
	end
	
	local rc, err = redis_cluster:new(redis_cluster_config)
	if not rc then		
		ngx.say(renderAjaxError("100100096"))
		return 
	end

	local res, err = rc:get(device_token..physical_id)
	if res == ngx.null then
	   tokenid=getRandomStoken(30)
	else
	   tokenid=res
	   local res1, err = rc:get(tokenid)
	   if res1 == ngx.null then
		  tokenid=getRandomStoken(30)
	   end  
	end

	rc:setex(tokenid,device_session_out_expire,cjson.encode(physical_id))

	rc:set(device_token..physical_id,tokenid)	

	local aes_key_id = GetAesKeyid()
	local aes_key =  GetAesKey(aes_key_id)

	local data={
	result="ok",
	session=device_session_out_expire,
	dev_conn_addr=dev_conn_addr,
	heartbeat_interval=heartbeat_interval,
	dev_access_addr=dev_access_addr,
	alerts_addr=alerts_addr,
	file_server_addr=file_server_addr,
	dev_mng_addr=dev_mng_addr,
	timestamp=os.time(),
	encrypt_key_id=aes_key_id,
	encrypt_key=aes_key,
	addition=tokenid
	};

	local jsonStr = cjson.encode(data);
	ngx.header['Content-Type'] = 'application/json; charset=utf-8'
	ngx.say(jsonStr);
	ngx.log(ngx.INFO,"physical_id:"..physical_id.." ",jsonStr)
	--logger:info("devlogin "..physical_id..jsonStr);	
end

Devlogin()


