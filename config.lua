Config = {}


Config.Debug = false


Config.CooldownDuration = 6000 
Config.NotifyCooldown = 30000   
Config.BuffTime = 10000         


Config.HealthIncrease = 600


Config.Pools = {
    {
        coords = vector3(182.99, 1807.63, 199.70),
        radius = 4.0
    },
    {
        coords = vector3(145.84, 1870.45, 199.91),
        radius = 4.0
    }
}


Config.Notify = {
    Success = {
        title = "Hot Springs",
        description = "You feel refreshed and healthier!"
    },
    ErrorCooldown = {
        title = "Hot Springs",
        description = "You need to wait before using the hot springs again."
    },
    ErrorBusy = {
        title = "Hot Springs",
        description = "You can't use the hot springs right now."
    },
    WarningHealthLoss = {
        title = "Hot Springs",
        description = "You've lost health since leaving the springs."
    }
}