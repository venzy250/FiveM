function GetPlayerACEGroup(src)
    for group, _ in pairs(Config.Departments) do
        if IsPlayerAceAllowed(src, group) then
            return group
        end
    end
    return nil
end

function LogToDiscord(group, embed)
    local webhook = Config.Departments[group] and Config.Departments[group].webhook
    if webhook then
        PerformHttpRequest(webhook, function() end, "POST", json.encode({
            username = "Evidence Locker",
            embeds = { embed }
        }), { ["Content-Type"] = "application/json" })
    else
        print("[Evidence Locker] Missing webhook for group: " .. tostring(group))
    end
end
