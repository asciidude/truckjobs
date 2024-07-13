function setTextStyle()
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.4)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextWrap(0.5, 1.0)
end

function displayJobInformation(location, cargo, payout, trailer)
    if not cargo or not payout or not trailer or not Config.currency then
        return
    end

    local x = 0.02
    local y = 0.45
    local lineSpacing = 0.023  -- Adjust the spacing between lines

    setTextStyle()
    SetTextEntry("STRING")
    AddTextComponentString("~h~~b~Delivery Information")
    DrawText(x, y)

    y = y + lineSpacing + 0.01
    setTextStyle()
    SetTextEntry("STRING")
    AddTextComponentString("~b~Location: ~s~" .. location)
    DrawText(x, y)

    y = y + lineSpacing
    setTextStyle()
    SetTextEntry("STRING")
    AddTextComponentString("~b~Cargo: ~s~" .. cargo)
    DrawText(x, y)

    y = y + lineSpacing
    setTextStyle()
    SetTextEntry("STRING")
    AddTextComponentString("~b~Payout: ~s~" .. Config.currency .. formatNumber(payout))
    DrawText(x, y)

    y = y + lineSpacing
    setTextStyle()
    SetTextEntry("STRING")
    AddTextComponentString("~b~Trailer: ~s~" .. trailer)
    DrawText(x, y)
end
