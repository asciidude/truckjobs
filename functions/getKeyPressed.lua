local keyList = nil

-- Load keylist from JSON file
Citizen.CreateThread(function()
    keyList = json.decode(LoadResourceFile(GetCurrentResourceName(), "keylist.json"))
    if not keyList then
        print("Failed to load keylist from keylist.json")
    end
end)

-- Function to check if a key is pressed
function getKeyPressed(key)
    if keyList and keyList[key] then
        return IsControlJustReleased(0, keyList[key])
    else
        print("Key not found in keylist: " .. key)
        return false
    end
end