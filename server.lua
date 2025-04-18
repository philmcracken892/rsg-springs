local RSGCore = exports['rsg-core']:GetCoreObject()
local playerCooldowns = {}


RegisterServerEvent('cotara:checkCooldown')
AddEventHandler('cotara:checkCooldown', function()
    local src = source
    local player = RSGCore.Functions.GetPlayer(src)
    if not player then return end
    
    local identifier = player.PlayerData.citizenid
    local currentTime = GetGameTimer()
    
    
    if playerCooldowns[identifier] and currentTime < playerCooldowns[identifier] then
        TriggerClientEvent('ox_lib:notify', src, {
            title = Config.Notify.ErrorCooldown.title,
            description = Config.Notify.ErrorCooldown.description,
            type = 'error'
        })
        return
    end
    
   
    playerCooldowns[identifier] = currentTime + Config.CooldownDuration
    TriggerClientEvent('cotara:applyBuffs', src)
    
    if Config.Debug then
        
    end
end)


RegisterServerEvent('cotara:applyHealthBuff')
AddEventHandler('cotara:applyHealthBuff', function()
    local src = source
    local player = RSGCore.Functions.GetPlayer(src)
    if not player then return end
    
    
    TriggerClientEvent('cotara:setNewHealth', src, Config.HealthIncrease)
    
    if Config.Debug then
        
    end
end)


AddEventHandler('playerDropped', function()
    local src = source
    local player = RSGCore.Functions.GetPlayer(src)
    if player then
        playerCooldowns[player.PlayerData.citizenid] = nil
    end
end)