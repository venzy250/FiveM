local activeCams = {}
local currentIndex = 1

RegisterCommand("iacam", function()
    SendNUIMessage({ type = "playSound", file = "enteria.wav" })
    TriggerServerEvent("bodycam:getActiveCams")
end)

RegisterCommand("stopcam", function()
    SendNUIMessage({ type = "playSound", file = "exitia.wav" })
    StopChestCamera()
    TriggerEvent("bodycam:hideOverlay")
    NetworkSetInSpectatorMode(false, cache.ped)
end)

RegisterNetEvent("bodycam:setCamTargets", function(list)
    activeCams = list
    currentIndex = 1
    SpectateCurrentIA()
end)

function SpectateCurrentIA()
    local target = activeCams[currentIndex]
    if target then
        local ped = GetPlayerPed(GetPlayerFromServerId(target.id))
        NetworkSetInSpectatorMode(true, ped)
        AttachChestCameraTo(ped)
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, 175) then
            currentIndex = (currentIndex % #activeCams) + 1
            SpectateCurrentIA()
        elseif IsControlJustPressed(0, 174) then
            currentIndex = (currentIndex - 2 + #activeCams) % #activeCams + 1
            SpectateCurrentIA()
        end
    end
end)
