function httpServer()
    srv=net.createServer(net.TCP)  
    srv:listen(80,function(conn)  
        conn:on("receive",function(conn,req)
            local _, _, method, path, vars = string.find(req, "([A-Z]+) (.+)?(.+) HTTP") 
            if(method == nil)then
                _, _, method, path = string.find(req, "([A-Z]+) (.+) HTTP")
            end
            local _GET = {}
            if(vars ~= nil)then
                for k, v in string.gmatch(vars, "([^&]+)=([^&]*)&*") do
                    _GET[k] = v
                end
            end
            --devices
            local deviceId = getConfig("deviceId")
            local user = getConfig("user")
            local password = getConfig("password")
            --wifi
            local ssid = getConfig("ssid")
            local pwd = getConfig("pwd")
    ---------------------------------------------------------------------------
            if deviceId == nil then
                deviceId = ""
            end
            if ssid == nil then
                ssid = ""
            end
            if pwd == nil then
                pwd = ""
            end
            if password==nil then
                pwd=""
            end
            if user ==nil then
                user=""
            end
    -----------------------------------------------------------------------
            if _GET.deviceId ~= nil and _GET.deviceId ~= ""  then
                deviceId = _GET.deviceId
                setConfig("deviceId",_GET.deviceId)
            end
            if _GET.ssid ~= nil and _GET.ssid ~= ""  then
                print(_GET.ssid)
                ssid = _GET.ssid
                setConfig("ssid",_GET.ssid)
                node.restart()
            end
            if _GET.pwd ~= nil and _GET.pwd ~= ""  then
                pwd = _GET.pwd
                print(_GET.pwd)
                setConfig("pwd",_GET.pwd)
            end
            if _GET.user ~= nil and _GET.user ~= ""  then
                user = _GET.user
                print(_GET.user)
                setConfig("user",_GET.user)
            end
            if _GET.password ~= nil and _GET.password ~= ""  then
                password = _GET.password
                print(_GET.password)
                setConfig("password",_GET.password)
            end
    ------------------------------------------------------------------------
            local buf = '<html>'
            buf = buf..'<head>'
            buf = buf..'<title>config</title>'
            buf = buf..'</head>'
            buf = buf..'<body>'
            buf = buf..'<form>'
            buf = buf..'Devices ID:<input type="text" value="'..deviceId..'" name="deviceId">'
            buf = buf.."<br>"
            buf = buf.."<br>"
            buf = buf..'UserID:<input type="text" name="user" value="'..user..'">'
            buf = buf..'<br>'
            buf = buf.."<br>"
            buf = buf..'Devices:<input type="text" name="password" value="'..password..'">'
            buf = buf..'<br>'
            buf = buf..'WiFi Name:<input type="text" name="ssid" value="'..ssid..'">'
            buf = buf.."<br>"
            buf = buf..'WiFi Key:<input type="text" name="pwd" value="'..pwd..'">'
            buf = buf..'<br>'
            buf = buf..'<input type="submit" value="submit">'
            buf = buf..'</form>'
            buf = buf..'</body>'
            buf = buf..'</html>'
            local html = string.format('HTTP/1.0 200 OK\r\n'
            ..'Content-Type: text/html\r\n'
            ..'Connection: Close\r\n\r\n'
            ..buf)
            conn:send(html)
        end)
        conn:on("sent",function(conn) conn:close() end)
    end)
end
httpServer()
