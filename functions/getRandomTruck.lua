function getRandomTruck()
    local truckModels = {}
    for modelName, _ in pairs(TruckList) do
        table.insert(truckModels, modelName)
    end
    
    if #truckModels > 0 then
        local randomIndex = math.random(1, #truckModels)
        return truckModels[randomIndex]
    else
        return nil
    end
end