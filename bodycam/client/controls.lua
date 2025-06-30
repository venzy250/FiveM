RegisterCommand("bodycam", function()
    TriggerEvent("bodycam:toggle")
end)

RegisterNetEvent("bodycam:toggle", function()
    if GetBattery() <= 0 then
        TriggerEvent("chat:addMessage", { args = { "^1Battery is dead. Recharge required." } })
        return
    end

    local isOn = true -- Toggle state tracking, replace with actual logic if needed

    local data = {
        unit = "Unit-00",
        district = "Unknown",
        time = os.date("!%H:%M:%S"),
        evidence = "BCM-" .. math.random(1000,9999),
        shift = "00:00:00",
        battery = GetBattery()
    }

    TriggerEvent("bodycam:showOverlay", data)
    SendNUIMessage({ type = "playSound", file = isOn and "on.wav" or "off.wav" })
end)
