local batteryLevel = 100
local isRecharging = false

RegisterCommand("rechargecam", function()
    if isRecharging then return end
    isRecharging = true
    batteryLevel = 100
    TriggerEvent("chat:addMessage", { args = { "^2Bodycam fully recharged." } })
    TriggerEvent("bodycam:hideOverlay")
    TriggerServerEvent("bodycam:updateBattery", batteryLevel)

    Wait(Config.RechargeCooldown)
    isRecharging = false
end)

RegisterNetEvent("bodycam:setBattery", function(level)
    batteryLevel = level
end)

function UseBattery(duration)
    batteryLevel = batteryLevel - (duration / Config.BatteryDuration * 100)

    if batteryLevel <= Config.LowBatteryThreshold then
        SendNUIMessage({ type = "playSound", file = "lowbattery.wav" })
    end

    if batteryLevel <= 0 then
        batteryLevel = 0
        TriggerEvent("bodycam:hideOverlay")
        TriggerEvent("chat:addMessage", { args = { "^1Battery dead. Please recharge." } })
    end
end

function GetBattery()
    return batteryLevel
end

