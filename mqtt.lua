require "OLED1306"
function init()
    print("init mqtt")
    mqtt_inited = 1
    m = mqtt.Client(getConfig("deviceId"), 30, getConfig("user"),getConfig("password"))
    print("now deviceId:" ..getConfig("deviceId"))
    print("now userId:" ..getConfig("user"))
    print("now userKey:" ..getConfig("password"))
    
    m:lwt("/lwt", "offline", 0, 0)
    m:connect("183.230.40.39", 6002, 0)
    m:on("connect", 
        function(con)
            print ("connected!") 
            stopReconnect()
            m:subscribe(getConfig("deviceId"),2, 
            function(conn) 
                print("subscribe success") 
                end)
        end)
    m:on("offline", 
        function(con) 
        print ("offline") 
        reconnect()
        end)
    
    m:on("message", 
        function(conn, topic, data) 
        print("receive mag:"..data) 
     -- u8g2_String(data)
    local ok, json = pcall(sjson.decode, data) 
    init_display(json.price)

    -- reply
    local ok, rjson = pcall(sjson.encode, {reply=json.id})
    m:publish("device/"..getConfig("deviceId"),rjson,0,0, 
        function(conn) print("reply sent") end)
    end)
end

if mqtt_inited == 0 then
    init()
else
    reconnect()
end


function reconnect()
    if mqtt_connecting == 0 then
        tmr.alarm(3, 5000, 1, 
        function()
            print("start reconnect!")
            m:close()
            m:connect("183.230.40.39", 6002, 0)
        end)
        mqtt_connecting = 1
    end
end

function stopReconnect()
    -- clear connecting state and clear connect timer!
    mqtt_connecting = 0
    tmr.stop(3)
end
