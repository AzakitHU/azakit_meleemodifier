-- Load the configuration
if Config == nil then
    Config = {}
    local configFile = LoadResourceFile(GetCurrentResourceName(), "config.lua")
    if configFile then
        local loadConfig = load(configFile)
        if loadConfig then
            loadConfig()
        else
            print("Error loading config.lua")
        end
    else
        print("config.lua not found")
    end
end

-- Register a server event to send the weapon damage modifiers to the client
RegisterNetEvent('azakit_meleemodifier:updateWeaponDamageModifiers')
AddEventHandler('azakit_meleemodifier:updateWeaponDamageModifiers', function()
    local _source = source
    TriggerClientEvent('azakit_meleemodifier:applyWeaponDamageModifiers', _source, Config.WeaponDamageModifiers)
end)

-- Apply the modifiers when a player spawns
AddEventHandler('playerSpawned', function()
    local _source = source
    TriggerClientEvent('azakit_meleemodifier:applyWeaponDamageModifiers', _source, Config.WeaponDamageModifiers)
end)
