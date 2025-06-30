function HasPermission(src, role)
    local id = GetPlayerIdentifier(src, 0)
    local perm = Config.PermissionRoles[role]
    local result = exports.oxmysql:scalarSync("SELECT 1 FROM bodycam_permissions WHERE identifier = ? AND role = ?", { id, perm })
    return result ~= nil
end

RegisterServerEvent("bodycam:getActiveCams")
AddEventHandler("bodycam:getActiveCams", function()
    local src = source
    if not HasPermission(src, "ia") then
        TriggerClientEvent("chat:addMessage", src, { args = { "^1You do not have permission to use IA mode." } })
        return
    end

    local players = GetPlayers()
    local camTargets = {}

    for _, player in pairs(players) do
        local ped = GetPlayerPed(player)
        if ped and DoesEntityExist(ped) then
            table.insert(camTargets, { id = tonumber(player) })
        end
    end

    TriggerClientEvent("bodycam:setCamTargets", src, camTargets)
end)
