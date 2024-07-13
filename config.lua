-- This plugin is licensed under MIT. More information in LICENSE.
-- Made with 💗 by asciidude.

-- Welcome to TruckJobs!
-- This is the configuration file, please configure it according to your liking.

-- Look at trucklist.lua to manage possible truck jobs, dropoff locations, and add-on trucks.

Config = {}

Config.keepASCIIArt = true -- Toggle ASCII art shown in console on plugin load.

Config.currency = '$' -- The currency symbol shown in payout messages, on delivery information, and on the dashboard.

Config.limitACE_Trucking = false -- Limit truck job dashboard to ACE permission.
Config.truckingPermission = "job" -- prefix: truckjobs

Config.trucking_commandName = "truckjobs"
Config.endjob_commandName = "endjob"

Config.completionKey = "E" -- keylist.json

Config.endJobOnExit = false -- Toggle to enable/disable ending a job on exit of the truck.
Config.endJobOnDetach = true -- End job on trailer detachment (big rigs).

-- Blips: https://docs.fivem.net/docs/game-references/blips/
-- Colors: https://docs.fivem.net/docs/game-references/hud-colors/

Config.dropoff_blipId = 568 -- The blip of the dropoff location
Config.dropoff_blipColor = 13

Config.truck_blipId = 477 -- The blip of the truck
Config.truck_blipColor = 13