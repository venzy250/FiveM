RegisterCommand("evidenceui", function()
    SetNuiFocus(true, true)
    SendNUIMessage({ type = "openUI" })
end)

RegisterNUICallback("closeUI", function(_, cb)
    SetNuiFocus(false, false)
    cb(true)
end)

RegisterNetEvent("evidence:loadData", function(evidence, department, departments)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "openUI",
        evidence = evidence,
        department = department,
        departments = departments
    })
end)

RegisterNetEvent("evidence:refreshUI")
AddEventHandler("evidence:refreshUI", function()
    TriggerServerEvent("evidence:prepare")
end)

Citizen.CreateThread(function()
    while true do
        Wait(500)
        local coords = GetEntityCoords(PlayerPedId())
        if #(coords - Config.LockerLocation) < Config.LockerRadius then
            TriggerEvent("evidence:showPrompt")
        end
    end
end)

RegisterNetEvent("evidence:showPrompt", function()
    DrawText3D(Config.LockerLocation, "[E] Open Evidence Locker")
    if IsControlJustReleased(0, 38) then
        TriggerServerEvent("evidence:prepare")
    end
end)

function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
