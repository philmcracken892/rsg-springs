local RSGCore = exports['rsg-core']:GetCoreObject()
local isBusy = false
local isInPool = false
local lastHealth = 0
local notifyCooldown = 0
local lastPool = nil


Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local currentHealth = GetEntityHealth(ped)
        isInPool = false
        local currentPool = nil
        
        
        for i, pool in ipairs(Config.Pools) do
            if #(coords - pool.coords) < pool.radius then
                isInPool = true
                currentPool = i
                break
            end
        end
        
        
        if isInPool and not isBusy then
            local PlayerData = RSGCore.Functions.GetPlayerData()
            if not PlayerData.metadata['isdead'] and not PlayerData.metadata['ishandcuffed'] then
                if lastPool ~= currentPool then
                    TriggerServerEvent('cotara:checkCooldown')
                    lastPool = currentPool
                end
            else
                lib.notify({
                    title = Config.Notify.ErrorBusy.title,
                    description = Config.Notify.ErrorBusy.description,
                    type = 'error'
                })
            end
        elseif not isInPool then
            lastPool = nil
        end
        
        
        if currentHealth < lastHealth and not isInPool and GetGameTimer() > notifyCooldown then
            lib.notify({
                title = Config.Notify.WarningHealthLoss.title,
                description = Config.Notify.WarningHealthLoss.description,
                type = 'warning'
            })
            notifyCooldown = GetGameTimer() + Config.NotifyCooldown
            if Config.Debug then
                print(string.format("Health loss detected: %d -> %d, InPool: %s, Coords: %s",
                    lastHealth, currentHealth, isInPool, tostring(coords)))
            end
        end
        
        
        if Config.Debug then
            print(string.format("InPool: %s, CurrentPool: %s, Health: %d, PlayerCoords: %s",
                isInPool, currentPool or "none", currentHealth, tostring(coords)))
        end
        
        lastHealth = currentHealth
        Citizen.Wait(1000) 
    end
end)


RegisterNetEvent('cotara:applyBuffs')
AddEventHandler('cotara:applyBuffs', function()
    isBusy = true
    LocalPlayer.state:set('inv_busy', true, true)
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey('weapon_unarmed'))
    
    lib.progressBar({
        duration = Config.BuffTime,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disableControl = true,
        disable = {
            move = true,
            mouse = true,
        },
        label = 'Bathing in the springs...'
    })
    
    TriggerServerEvent('cotara:applyHealthBuff')
    lib.notify({
        title = Config.Notify.Success.title,
        description = Config.Notify.Success.description,
        type = 'success'
    })
    LocalPlayer.state:set('inv_busy', false, true)
    isBusy = false
end)


RegisterNetEvent('cotara:setNewHealth')
AddEventHandler('cotara:setNewHealth', function(healthIncrease)
    local ped = PlayerPedId()
    local currentHealth = GetEntityHealth(ped)
    local newHealth = math.min(currentHealth + healthIncrease, GetEntityMaxHealth(ped))
    
    SetEntityHealth(ped, newHealth)
    
    if Config.Debug then
        print(string.format("Health increased from %d to %d", currentHealth, newHealth))
    end
end)