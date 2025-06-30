Config = {}

-- Coordinates where [E] interaction appears
Config.LockerLocation = vector3(450.1, -981.2, 30.7)
Config.LockerRadius = 2.0

-- Departments: ACE group -> { name, webhook }
Config.Departments = {
    ["group.lspd"] = {
        name = "LSPD",
        webhook = "https://discord.com/api/webhooks/xxxxx/lspd"
    },
    ["group.bcso"] = {
        name = "BCSO",
        webhook = "https://discord.com/api/webhooks/xxxxx/bcso"
    },
    ["group.sast"] = {
        name = "SAST",
        webhook = "https://discord.com/api/webhooks/xxxxx/sast"
    },
    ["group.sahp"] = {
        name = "SAHP",
        webhook = "https://discord.com/api/webhooks/xxxxx/sahp"
    },
    ["group.fib"] = {
        name = "FIB",
        webhook = "https://discord.com/api/webhooks/xxxxx/fib"
    }
}

-- Admin override ACE group
Config.AdminAce = "evidence.admin"
