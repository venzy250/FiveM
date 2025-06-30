Config = {}

Config.BatteryDuration = 5 * 60 * 60 * 1000 -- 5 hours in milliseconds
Config.LowBatteryThreshold = 60 * 1000      -- 1 minute
Config.RechargeCooldown = 10 * 1000         -- 10 seconds recharge cooldown

Config.ChestBone = 24818                    -- SKEL_Spine2
Config.ChestOffset = vector3(0.15, 0.05, 0.05)

Config.PermissionRoles = {
    ia = "iacam",
    bodycam = "leo.bodycam",
    setunit = "leo.setunit",
    setdistrict = "leo.setdistrict"
}

