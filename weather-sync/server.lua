local function fetchAndBroadcastWeather()
    local url = string.format(
        "http://api.openweathermap.org/data/2.5/weather?lat=%s&lon=%s&appid=%s",
        Config.Latitude, Config.Longitude, Config.OpenWeatherAPIKey
    )

    PerformHttpRequest(url, function(status, response, headers)
        if status == 200 then
            local data = json.decode(response)
            if data and data.weather and data.weather[1] and data.weather[1].main then
                local main = data.weather[1].main

                -- map OpenWeatherMap to GTA weather types
                local mapping = {
                    Clear       = "EXTRASUNNY",
                    Clouds      = "CLOUDS",
                    Drizzle     = "RAIN",
                    Rain        = "RAIN",
                    Thunderstorm= "THUNDER",
                    Snow        = "SNOW",
                    Mist        = "FOGGY",
                    Smoke       = "SMOG",
                    Haze        = "SMOG",
                    Dust        = "SMOG",
                    Fog         = "FOGGY",
                    Sand        = "SMOG",
                    Ash         = "SMOG",
                    Squall      = "CLEARING",
                    Tornado     = "THUNDER"
                }

                local gtaWeather = mapping[main] or "OVERCAST"
                TriggerClientEvent("weather-sync:updateWeather", -1, gtaWeather)
            end
        else
            print(("[weather-sync] HTTP error %d fetching weather."):format(status))
        end
    end, "GET", "", { ["Content-Type"] = "application/json" })

    -- schedule next update
    SetTimeout(Config.UpdateInterval, fetchAndBroadcastWeather)
end

-- kick off the first fetch once the server resource is up
AddEventHandler("onResourceStart", function(resName)
    if GetCurrentResourceName() == resName then
        fetchAndBroadcastWeather()
    end
end)
