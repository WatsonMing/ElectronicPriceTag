---------------------------------------------------------------------------------------
l = file.list()
print("file List ↓")
for name, size in pairs(l) do 
    print("name: " ..name..", size: "..size)
end
---------------------------------------------------------------------------------------------
require "OLED1306"
init_i2c_display()
-----------------------------------------------------------
dofile "config.lua" 

if getConfig("ssid")==nil then
    wifi.setmode(wifi.STATIONAP)
    wifi.ap.config({ ssid ="MyNodeMcu", auth = AUTH_OPEN })
    dofile("httpServer.lua")
    print("Insert Configure")
else 
    cfg={}
    wifi.setmode(wifi.STATION)
    cfg.ssid=getConfig("ssid")
    cfg.pwd=getConfig("pwd")
    print("ssid:"..cfg.ssid)
    print("pwd:"..cfg.pwd)
    wifi.sta.config(cfg)
    wifi.sta.autoconnect(1)
end
print("set up wifi mode"..wifi.getmode())
--------------------------------------------------------------------
flag=false
tmr.alarm(0,5000, 1, function()
    if wifi.sta.getip()== nil then
        print("Not InterNet...")
        flag=false
    else
        tmr.stop(1)
        print("Config done, IP is "..wifi.sta.getip())
        if flag==false then
            m = nil
            mqtt_inited = 0
            mqtt_connecting = 0
            dofile("mqtt.lua")
        flag=true
        end
    end
end)



