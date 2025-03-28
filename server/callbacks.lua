lib.callback.register('oxy:server:AttemptDelivery', function(source)
    local player = QBCore.Functions.GetPlayer(source)
    local itemToHandover = Config.Items.oxyRunStarterItem
    local itemAmount = exports.ox_inventory:Search(source, 'count', itemToHandover.itemName)

    if itemAmount >= 1 then
        if exports.ox_inventory:RemoveItem(source, itemToHandover.itemName, itemToHandover.dropOffAmount) then
            return true
        end
    end

    return false
end)

lib.callback.register('oxy:server:GiveItems', function(source, item, amount)
    local player = QBCore.Functions.GetPlayer(source)

    if exports.ox_inventory:CanCarryItem(source, item, amount) then
        exports.ox_inventory:AddItem(source, item, amount)

        return true
    end

    return false
end)

lib.callback.register('oxy:server:GetRunCounter', function(source)
    local player = QBCore.Functions.GetPlayer(source)
    local citizenId = player.PlayerData.citizenid

    return playerRunCounter[citizenId]
end)