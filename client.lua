local jobActive,
      wasInActiveVehicle = false
local activeVehicle,
      activeTrailer,
      vehicleBlip,
      dropoffBlip,
      dropoffInformation,
      dropoffCoords = nil
local drawDistance = 50.0

-- Handling NUI Callbacks
RegisterNUICallback("loadTrucks", function(data, cb)
    TriggerEvent('TruckJobs:LoadTrucks')
    cb("ok")
end)

RegisterNUICallback("closeTruckMenu", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("loadJobs", function(data, cb)
    TriggerEvent('TruckJobs:LoadJobs', data.truck)
    cb("ok")
end)

RegisterNUICallback("selectJob", function(data, cb)
    TriggerEvent('TruckJobs:StartJob', data.truck.modelName, data.job)
    SetNuiFocus(false, false)
    cb("ok")
end)

-- Handling NUI Events
RegisterNetEvent('TruckJobs:OpenMenu')
AddEventHandler('TruckJobs:OpenMenu', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "openTruckMenu"
    })
end)

RegisterNetEvent('TruckJobs:LoadTrucks')
AddEventHandler('TruckJobs:LoadTrucks', function()
    local truckModels = {}
    
    for modelName, jobs in pairs(TruckList) do
        local truckName = jobs[1].truckName
        table.insert(truckModels, { modelName = modelName, truckName = truckName })
    end
    
    SendNUIMessage({
        type = "trucksLoaded",
        trucks = truckModels
    })
end)

RegisterNetEvent('TruckJobs:LoadJobs')
AddEventHandler('TruckJobs:LoadJobs', function(truck)
    local jobs = TruckList[truck.modelName]
    
    SendNUIMessage({
        type = "jobsLoaded",
        jobs = jobs,
        currency = Config.currency
    })
end)


RegisterNetEvent('TruckJobs:StartJob')
AddEventHandler('TruckJobs:StartJob', function(truckModel, t_dropoffInformation)
    if jobActive then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            multiline = true,
            args = { "TruckJobs", "You already have an active job." }
        })
    else
        local playerPed = PlayerPedId()

        local currentVehicle = GetVehiclePedIsIn(playerPed, false)
        local currentVehicle_trailer = GetVehicleTrailerVehicle(currentVehicle)

        if currentVehicle_trailer then
            deleteVehicle(currentVehicle_trailer)
        end

        if currentVehicle then
            deleteVehicle(currentVehicle)
        end

        if truckModel then
            if t_dropoffInformation then
                dropoffInformation = t_dropoffInformation
                jobActive = true

                -- Spawn model and place player in vehicle

                local vehicleModel = GetHashKey(truckModel)

                RequestModel(vehicleModel)
                while not HasModelLoaded(vehicleModel) do
                    Wait(500)
                end

                local playerCoords = GetEntityCoords(playerPed)
                activeVehicle = CreateVehicle(vehicleModel, playerCoords.x, playerCoords.y, playerCoords.z, GetEntityHeading(playerPed), true, false)
                TaskWarpPedIntoVehicle(playerPed, activeVehicle, -1)

                -- Attach assigned trailer to activeVehicle

                if t_dropoffInformation.trailer and t_dropoffInformation.trailer ~= 'none' then
                    local trailerModel = GetHashKey(t_dropoffInformation.trailer)
                    RequestModel(trailerModel)

                    while not HasModelLoaded(trailerModel) do
                        Wait(500)
                    end

                    local trailerCoords = GetOffsetFromEntityInWorldCoords(activeVehicle, 0.0, -10.0, 0.0)
                    activeTrailer = CreateVehicle(trailerModel, trailerCoords.x, trailerCoords.y, trailerCoords.z, GetEntityHeading(activeVehicle), true, false)

                    while not DoesEntityExist(activeTrailer) do
                        Wait(500)
                    end

                    AttachVehicleToTrailer(activeVehicle, activeTrailer, 10.0)
                end

                -- Create blip for delivery route & set blip route

                dropoffBlip = AddBlipForCoord(t_dropoffInformation.x, t_dropoffInformation.y, t_dropoffInformation.z)
                SetBlipSprite(dropoffBlip, Config.dropoff_blipId)
                SetBlipColour(dropoffBlip, Config.dropoff_blipColor)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Dropoff Location - " .. t_dropoffInformation.cargo)
                SetBlipRoute(dropoffBlip,  true)
                --SetBlipRouteColour(dropoffBlip,  Config.dropoff_blipColor)
                EndTextCommandSetBlipName(dropoffBlip)

                -- Create a blip for the job vehicle

                vehicleBlip = AddBlipForEntity(activeVehicle)
                SetBlipSprite(vehicleBlip, Config.truck_blipId)
                SetBlipColour(vehicleBlip, Config.truck_blipColor)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Job Vehicle")
                EndTextCommandSetBlipName(vehicleBlip)

                dropoffCoords = vector3(t_dropoffInformation.x, t_dropoffInformation.y, t_dropoffInformation.z)

                TriggerEvent('chat:addMessage', {
                    color = { 0, 255, 0 },
                    multiline = true,
                    args = { "TruckJobs", "Job started! Deliver the goods to the marked location." }
                })
            else
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0 },
                    multiline = true,
                    args = { "TruckJobs", "No dropoff information provided for " .. truckModel .. " (contact server developer)." }
                })
            end
        else
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0 },
                multiline = true,
                args = { "TruckJobs", "No trucks available for jobs." }
            })
        end
    end
end)

if Config.endJobOnExit then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(100)
            
            if jobActive then
                -- Exit vehicle / Vehicle swap
                if IsPedInAnyVehicle(PlayerPedId(), true) == 1 then
                    if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) ~= PlayerPedId() then
                        TriggerEvent('TruckJobs:EndJob', true)
                    end
                else
                    TriggerEvent('TruckJobs:EndJob', true)
                end

                -- Check if player is in active vehicle
                local isInActiveVehicle = IsPedInVehicle(PlayerPedId(), activeVehicle, true)
        
                if isInActiveVehicle and not wasInActiveVehicle then
                    SetBlipRoute(dropoffBlip, true)
                    wasInActiveVehicle = true
                elseif not isInActiveVehicle and wasInActiveVehicle then
                    SetBlipRoute(dropoffBlip, false)
                    wasInActiveVehicle = false
                end
            end
        end
    end)
else
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(100)
            
            if jobActive then
                -- Active vehicle deletion
                if not DoesEntityExist(activeVehicle) then
                    TriggerEvent('TruckJobs:EndJob', true)
                end

                -- Check if player is in active vehicle
                local isInActiveVehicle = IsPedInVehicle(PlayerPedId(), activeVehicle, true)
        
                if isInActiveVehicle == 1 and not wasInActiveVehicle then
                    SetBlipRoute(dropoffBlip, true)
                    wasInActiveVehicle = true
                elseif not isInActiveVehicle and wasInActiveVehicle then
                    SetBlipRoute(dropoffBlip, false)
                    wasInActiveVehicle = false
                end
            end
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local isInActiveVehicle = IsPedInVehicle(PlayerPedId(), activeVehicle, true)

        if jobActive and isInActiveVehicle == 1 then
            displayJobInformation(dropoffInformation.location, dropoffInformation.cargo, dropoffInformation.payout, dropoffInformation.trailer)
        end

        -- Check if trailer detached
        if activeTrailer and Config.endJobOnDetach then
            if isInActiveVehicle == 1 and not GetVehicleTrailerVehicle(activeVehicle, activeTrailer) then
                TriggerEvent('TruckJobs:EndJob', true)
            end
        end

        -- Ground marker for delivery location
        if dropoffCoords then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, dropoffCoords.x, dropoffCoords.y, dropoffCoords.z)

            if distance < drawDistance then
                if DoesBlipExist(dropoffBlip) then
                    DrawMarker(1, dropoffCoords.x, dropoffCoords.y, dropoffCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 1.0, 0, 255, 0, 100, false, true, 2, false, nil, nil, false)

                    if distance < 5.0 and isInActiveVehicle == 1 then
                        displayCompletionText()

                        if getKeyPressed(Config.completionKey) then
                            TriggerEvent('TruckJobs:EndJob', false)
                        end
                    end
                end
            end
        end
    end
end)


RegisterCommand(Config.endjob_commandName, function()
    TriggerEvent('TruckJobs:EndJob', true)
end)

RegisterNetEvent('TruckJobs:EndJob')
AddEventHandler('TruckJobs:EndJob', function(early)
    if jobActive then
        jobActive = false
        dropoffCoords = nil
        wasInActiveVehicle = false

        if DoesBlipExist(vehicleBlip) then
            RemoveBlip(vehicleBlip)
            vehicleBlip = nil
        end

        if DoesBlipExist(dropoffBlip) then
            RemoveBlip(dropoffBlip)
            dropoffBlip = nil
        end

        if DoesEntityExist(activeVehicle) then
            if activeTrailer then
                if DoesEntityExist(activeTrailer) then
                    deleteVehicle(activeTrailer)
                end

                activeTrailer = nil
            end

            if DoesEntityExist(activeVehicle) then
                deleteVehicle(activeVehicle)
            end
            
            activeVehicle = nil
        end
        
        if early then
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0 },
                multiline = true,
                args = { "TruckJobs", "You have ended your job early, you will not recieve payout." }
            })
        else
            TriggerServerEvent('TruckJobs:TriggerPayout', GetPlayerServerId(PlayerId()), dropoffInformation.payout)
        end
        
        dropoffInformation = nil
    else
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            multiline = true,
            args = { "TruckJobs", "You do not have an active job." }
        })
    end
end)