local overlayActive = false

RegisterNetEvent("bodycam:showOverlay", function(data)
    overlayActive = true
    SendNUIMessage({
        type = "updateOverlay",
        visible = true,
        unit = data.unit,
        district = data.district,
        time = data.time,
        evidence = data.evidence,
        shift = data.shift,
        battery = data.battery
    })
end)

RegisterNetEvent("bodycam:hideOverlay", function()
    overlayActive = false
    SendNUIMessage({ type = "updateOverlay", visible = false })
end)
