function getRandomDropoffInformation(truckModel)
    local truckData = TruckList[truckModel]
    if truckData and #truckData > 0 then
        local randomIndex = math.random(1, #truckData)
        return truckData[randomIndex]
    else
        return nil
    end
end