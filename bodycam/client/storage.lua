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
        TriggerClientEvent("bodycam:setBattery", src, res[1] and res[1].battery or 100)
    end)
end)
