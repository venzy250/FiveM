RegisterServerEvent("bodycam:updateBattery")
AddEventHandler("bodycam:updateBattery", function(percent)
    local src = source
    local id = GetPlayerIdentifier(src, 0)
    exports.oxmysql:execute("UPDATE bodycam_units SET battery = ? WHERE identifier = ?", { percent, id })
end)

RegisterServerEvent("bodycam:getBattery")
AddEventHandler("bodycam:getBattery", function()
    local src = source
    local id = GetPlayerIdentifier(src, 0)
    exports.oxmysql:query("SELECT battery FROM bodycam_units WHERE identifier = ?", { id }, function(res)
        local battery = res[1] and res[1].battery or 100
        TriggerClientEvent("bodycam:setBattery", src, battery)
    end)
end)

RegisterCommand("setunit", function(source, args)
    local id = GetPlayerIdentifier(source, 0)
    local unit = table.concat(args, " ")
    exports.oxmysql:execute("INSERT INTO bodycam_units (identifier, unit_number) VALUES (?, ?) ON DUPLICATE KEY UPDATE unit_number = ?", { id, unit, unit })
    TriggerClientEvent("chat:addMessage", source, { args = { "^2Unit set to: " .. unit } })
end, false)

RegisterCommand("setdistrict", function(source, args)
    local id = GetPlayerIdentifier(source, 0)
    local district = table.concat(args, " ")
    exports.oxmysql:execute("INSERT INTO bodycam_units (identifier, district) VALUES (?, ?) ON DUPLICATE KEY UPDATE district = ?", { id, district, district })
    TriggerClientEvent("chat:addMessage", source, { args = { "^2District set to: " .. district } })
end, false)
