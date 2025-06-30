RegisterServerEvent("evidence:prepare")
AddEventHandler("evidence:prepare", function()
    local src = source
    local group = GetPlayerACEGroup(src)
    local isAdmin = IsPlayerAceAllowed(src, Config.AdminAce)

    if not group and not isAdmin then return end

    local query = isAdmin
        and "SELECT * FROM evidence_storage ORDER BY timestamp DESC"
        or "SELECT * FROM evidence_storage WHERE department = ? ORDER BY timestamp DESC"

    local params = isAdmin and {} or { group }

    exports.oxmysql:query(query, params, function(result)
        local allDepartments = {}

        for ace, info in pairs(Config.Departments) do
            if IsPlayerAceAllowed(src, ace) then
                table.insert(allDepartments, {
                    name = info.name,
                    id = ace,
                    evidence = nil -- not sent initially
                })
            end
        end

        TriggerClientEvent("evidence:loadData", src, result, Config.Departments[group or ""] and Config.Departments[group].name or "Admin", allDepartments)
    end)
end)

RegisterNUICallback("submitEvidence", function(data, cb)
    local src = source
    local group = GetPlayerACEGroup(src)
    if not group then return end

    local insert = {
        data.officer, data.callsign, data.suspect, data.dob,
        data.item, data.amount, data.evidence_id,
        os.date("%Y-%m-%d %H:%M:%S"), group
    }

    exports.oxmysql:execute(
        "INSERT INTO evidence_storage (officer, callsign, suspect, dob, item, amount, evidence_id, timestamp, department) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
        insert,
        function()
            TriggerClientEvent("evidence:refreshUI", src)

            LogToDiscord(group, {
                title = "Evidence Submitted",
                description = string.format("**Officer:** %s [%s]\n**Suspect:** %s (DOB: %s)\n**Item:** %s x%d\n**ID:** %s",
                    data.officer, data.callsign, data.suspect, data.dob, data.item, data.amount, data.evidence_id),
                color = 5814783
            })
        end
    )

    cb(true)
end)

RegisterNUICallback("removeEvidence", function(data, cb)
    local src = source
    local id = tonumber(data.id)
    if not id then return cb(false) end

    local group = GetPlayerACEGroup(src)
    local isAdmin = IsPlayerAceAllowed(src, Config.AdminAce)

    exports.oxmysql:query("SELECT * FROM evidence_storage WHERE id = ?", { id }, function(result)
        if not result[1] then return cb(false) end

        local row = result[1]
        if not isAdmin and row.department ~= group then return cb(false) end

        exports.oxmysql:execute("UPDATE evidence_storage SET removed_by = ?, removed_at = NOW() WHERE id = ?", {
            GetPlayerName(src), id
        }, function()
            TriggerClientEvent("evidence:refreshUI", src)

            LogToDiscord(row.department, {
                title = "Evidence Removed",
                description = string.format("**Officer:** %s\n**Removed Evidence ID:** %s\n**Original Entry:** %s x%d for %s [%s]",
                    GetPlayerName(src), row.evidence_id, row.item, row.amount, row.officer, row.callsign),
                color = 16733440
            })

            cb(true)
        end)
    end)
end)

RegisterCommand("evidencelog", function(source, args)
    local src = source
    local page = tonumber(args[1]) or 1
    local group = GetPlayerACEGroup(src)
    local isAdmin = IsPlayerAceAllowed(src, Config.AdminAce)
    local offset = (page - 1) * 10

    local query = isAdmin
        and "SELECT * FROM evidence_storage ORDER BY timestamp DESC LIMIT 10 OFFSET ?"
        or "SELECT * FROM evidence_storage WHERE department = ? ORDER BY timestamp DESC LIMIT 10 OFFSET ?"

    local params = isAdmin and { offset } or { group, offset }

    exports.oxmysql:query(query, params, function(rows)
        if not rows or #rows == 0 then
            TriggerClientEvent("chat:addMessage", src, { args = { "^3No entries found." } })
            return
        end

        TriggerClientEvent("chat:addMessage", src, { args = { "^5Evidence Log Page " .. page .. ":" } })
        for _, row in ipairs(rows) do
            local tag = row.removed_by and (" (REMOVED by " .. row.removed_by .. ")") or ""
            TriggerClientEvent("chat:addMessage", src, {
                args = {
                    string.format("[%s] #%d %s x%d (ID: %s)%s",
                        row.timestamp, row.id, row.item, row.amount, row.evidence_id, tag)
                }
            })
        end
    end)
end, false)

RegisterCommand("removeevidence", function(source, args)
    local src = source
    local id = tonumber(args[1])
    if not id then
        TriggerClientEvent("chat:addMessage", src, { args = { "^1Usage: /removeevidence [id]" } })
        return
    end

    local group = GetPlayerACEGroup(src)
    local isAdmin = IsPlayerAceAllowed(src, Config.AdminAce)

    exports.oxmysql:query("SELECT * FROM evidence_storage WHERE id = ?", { id }, function(result)
        if not result[1] then
            TriggerClientEvent("chat:addMessage", src, { args = { "^1Evidence not found." } })
            return
        end

        local row = result[1]
        if not isAdmin and row.department ~= group then
            TriggerClientEvent("chat:addMessage", src, { args = { "^1You cannot remove this evidence." } })
            return
        end

        exports.oxmysql:execute("UPDATE evidence_storage SET removed_by = ?, removed_at = NOW() WHERE id = ?", {
            GetPlayerName(src), id
        }, function()
            TriggerClientEvent("chat:addMessage", src, { args = { "^2Evidence removed successfully." } })

            LogToDiscord(row.department, {
                title = "Evidence Removed (CLI)",
                description = string.format("**Officer:** %s\n**Removed ID:** %s\n**Item:** %s x%d\n**Original:** %s [%s]",
                    GetPlayerName(src), row.evidence_id, row.item, row.amount, row.officer, row.callsign),
                color = 16733440
            })
        end)
    end)
end, false)
