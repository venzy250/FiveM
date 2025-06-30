local isSpeaking = false

Citizen.CreateThread(function()
    while true do
        Wait(100)
        local speaking = NetworkIsPlayerTalking(PlayerId())
        if speaking ~= isSpeaking then
            isSpeaking = speaking
            SendNUIMessage({ type = "voice", active = isSpeaking })
        end
    end
end)
