QBCore = exports["qb-core"]:GetCoreObject()

playerRunCounter = {}

RegisterNetEvent('oxy:server:UpdateRunCounter', function(data)
    local player = QBCore.Functions.GetPlayer(source)
    local citizenId = player.PlayerData.citizenid
    local locationName = data.args.name

    if not playerRunCounter[citizenId] then
        playerRunCounter[citizenId] = {
            [locationName] = 0
        }
    end

    if playerRunCounter[citizenId][locationName] <= 0 then
        playerRunCounter[citizenId][locationName] = 1

        return
    end

    if playerRunCounter[citizenId][locationName] >=1 then
        playerRunCounter[citizenId][locationName] = (playerRunCounter[citizenId][locationName] +1)

        return
    end
end)