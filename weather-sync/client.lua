local currentWeather = nil

RegisterNetEvent("weather-sync:updateWeather")
AddEventHandler("weather-sync:updateWeather", function(newWeather)
    if newWeather ~= currentWeather then
        currentWeather = newWeather

        -- smoothly transition to the new weather
        SetWeatherTypeOverTime(newWeather, 15.0)
        Citizen.Wait(15000)
        SetWeatherTypePersist(newWeather)
        SetWeatherTypeNow(newWeather)
        ClearOverrideWeather()
    end
end)
