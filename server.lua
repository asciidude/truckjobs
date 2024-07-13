if keepASCIIArt then
    print('                       _____________________________________________________')
    print('                      |                                                     |')
    print('             _______  |                                                     |')
    print('            / _____ | |                                                     |')
    print('           / /(__) || |                                                     |')
    print('  ________/ / |OO| || |                                                     |')
    print(' |         |-------|| |                                                     |')
    print('(|         |     -.|| |_______________________                              |')
    print(' |  ____   \\       ||_________||____________  |             ____      ____  |')
    print('/| / __ \\   |______||     / __ \\   / __ \\   | |            / __ \\    / __ \\ |\\')
    print('\\|| /  \\ |_______________| /  \\ |_| /  \\ |__| |___________| /  \\ |__| /  \\|_|/')
    print('   | () |                 | () |   | () |                  | () |    | () |')
    print('    \\__/                   \\__/     \\__/                    \\__/      \\__/')
    print(' ')
end

print('TruckJobs by asciidude has loaded')

RegisterCommand(Config.trucking_commandName, function(source, args, rawCommand)
    if Config.limitACE_Trucking then
        if IsAceAllowed(source, 'truckjobs.' .. truckingPermission) then
            TriggerClientEvent('TruckJobs:OpenMenu', source)
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = { 255, 0, 0 },
                multiline = true,
                args = { "TruckJobs", "Sorry, you don't have permission to use this command." }
            })
        end
    else
        TriggerClientEvent('TruckJobs:OpenMenu', source)
    end
end)

RegisterNetEvent('TruckJobs:TriggerPayout')
AddEventHandler('TruckJobs:TriggerPayout', function(source, amount)
    TriggerClientEvent('chat:addMessage', source, {
        color = { 51, 176, 255 },
        multiline = true,
        args = { "TruckJobs", "You have recieved a payout of " .. Config.currency .. formatNumber(amount) .. ". Thank you for your services! 🚚" }
    })
end)