local meleeDamageModifiers = {}
local weaponDamageModifiers = {}
local modifiersApplied = false  -- New variable to track the status of modifiers

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

-- Register the weapon damage modifiers event
RegisterNetEvent('azakit_meleemodifier:applyWeaponDamageModifiers')
AddEventHandler('azakit_meleemodifier:applyWeaponDamageModifiers', function(damageModifiers)
    for weapon, modifier in pairs(damageModifiers) do
        local weaponHash = GetHashKey(weapon)
        if IsWeaponValid(weaponHash) then
            SetWeaponDamageModifier(weaponHash, modifier)
            print("Applied damage modifier for " .. weapon .. ": " .. modifier)
        else
            print("Invalid weapon: " .. weapon)
        end
    end
    modifiersApplied = true  -- Indicates that the modifiers have been applied
end)

-- Request the damage modifiers when the client resource starts
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if not modifiersApplied then  -- It only asks for the modifiers if they haven't already been received
            TriggerServerEvent('azakit_meleemodifier:updateWeaponDamageModifiers')
        end
    end
end)

-- Apply melee damage modifier
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)  -- It checks every second
        if NetworkIsPlayerActive(PlayerId()) and not modifiersApplied then
            TriggerServerEvent('azakit_meleemodifier:updateWeaponDamageModifiers')
        end
    end
end)
