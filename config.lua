config_json = {}

function readConfig()
    local configStr = nil
    if file.open("config.json", "r") then
      configStr = file.readline()
      file.close()
    end
    
    if configStr ~= nil then
        config_json = sjson.decode(configStr)
    end
end


function setConfig(name,val)

    if file.open("config.json", "w+") then
      config_json[name] = val
      file.writeline(sjson.encode(config_json))
      file.close()
    end 
end

function getConfig(name)
    return config_json[name]
end

readConfig()
