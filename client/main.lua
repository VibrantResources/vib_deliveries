QBCore = exports["qb-core"]:GetCoreObject()

local amountOfLocations = 0
local oxyBlip = nil
local missionStarted = false

CreateThread(function()
    for k, v in pairs(Locations.dropofflocations) do
        local pedInfo = v.startPed
        local propInfo = pedInfo.propInfo

        lib.requestModel(pedInfo.pedModel, 60000)
        local oxyPed = CreatePed(1, pedInfo.pedModel, pedInfo.location, pedInfo.location.w, false, true)

        SetEntityInvincible(oxyPed, true)
        SetBlockingOfNonTemporaryEvents(oxyPed, true)
        FreezeEntityPosition(oxyPed, true)

        lib.requestAnimDict(pedInfo.animInfo.dict)
        TaskPlayAnim(oxyPed, pedInfo.animInfo.dict, pedInfo.animInfo.clip, 1.0, 1.0, -1, 1, 1, false, false, false)
        RemoveAnimDict(pedInfo.animInfo.dict)

        local placement = propInfo.placement
        lib.RequestModel(propInfo.propModel)
        local propModel = CreateObject(propInfo.propModel, pedInfo.location.xyz, false, true, false)
        AttachEntityToEntity(propModel, oxyPed, GetPedBoneIndex(oxyPed, propInfo.bone), placement.x, placement.y, placement.z, placement.xRot, placement.yRot, placement.zRot, true, true, false, true, 1, true)
        SetModelAsNoLongerNeeded(propInfo.propModel)

        exports.ox_target:addLocalEntity(oxyPed, {
            {
                label = 'Speak to '..k,
                event = 'oxy:client:BeginOxyRun',
                args = {
                    name = k,
                    locations = v.locations,
                },
                icon = 'fa-solid fa-comment-dots',
                iconColor = 'yellow',
                distance = 2,
            },
        })
        SetModelAsNoLongerNeeded(pedInfo.pedModel)
    end
end)

function ChooseRandomLocation(locationList, previousLocation)
    if previousLocation ~= nil then
        repeat
            local randomKey = math.random(1, #locationList) -- This chooses which random location from the Config list to use
            newChosenLocation = locationList[randomKey] -- This grabs the data from the above chosen location (In this case, it simply sets [newChosenLocation] as the coordinates

        until newChosenLocation ~= previousLocation

        return newChosenLocation
    end

    local randomKey = math.random(1, #locationList)
    local chosenLocation = locationList[randomKey] 

    return chosenLocation
end

RegisterNetEvent('oxy:client:BeginOxyRun', function(data)
    local remainingCooldown = lib.callback.await('oxy:server:GetCooldown', false, data.args)
    local runCounter = lib.callback.await('oxy:server:GetRunCounter', false)
    local currentLocation = data.args.name

    if runCounter ~= nil then
        if runCounter[currentLocation] >= 1 then
            lib.notify({
                title = 'Enough',
                description = "You do anymore jobs and you'll start attracting the cops",
                type = 'error'
            })
            return
        end
    end

    if remainingCooldown > 0 then 
        lib.notify({
            title = 'Unable',
            description = "You need to wait before starting a new run",
            type = 'error'
        })
        return
    end
    
    if missionStarted then
        lib.notify({
            title = 'Unable',
            description = "You've already got a job to do",
            type = 'error'
        })
        return
    end

    local player = cache.ped
    local locationList = data.args.locations
    amountOfLocations = 1 -- This chooses how many locations we want the player to have to go to before the whole run ends
    local chosenLocation = ChooseRandomLocation(locationList)
    local locationName = data.args.name

    local recievedItems = lib.callback.await('oxy:server:GiveItems', false, Config.Items.oxyRunStarterItem.itemName, amountOfLocations)

    if not recievedItems then
        lib.notify({
            title = 'Unable',
            description = "You don't have room for the items",
            type = 'error'
        })

        amountOfLocations = nil
        return
    end

    PlaySynchronizedEntityAnim(data.entity, syncedScene, animation, propName, p4, p5, p6, p7)

    if Config.CoreInfo.UseAIPolice then
        CallAIPolice() -- This is the function that spawns and task the Police AI with attempting to arrest the player
    end

    lib.notify({
        title = 'New Marker',
        description = 'Follow your GPS and make your drop off!',
        type = 'inform'
    })
    createBlip(chosenLocation) -- This creates the blip and waypoint for the [chosenLocation]
    createPed(data, chosenLocation, locationName, locationList) -- This creates the ped at the [chosenLocation] with the attached location data
    missionStarted = true

    TriggerServerEvent('oxy:server:TriggerCooldown')
    TriggerServerEvent('oxy:server:UpdateRunCounter', data)
end)

function createBlip(chosenLocation)
    oxyBlip = AddBlipForCoord(chosenLocation.x, chosenLocation.y, chosenLocation.z)

    SetBlipSprite(oxyBlip, 226)
    SetBlipDisplay(oxyBlip, 4)
    SetBlipScale(oxyBlip, 0.7)
    SetBlipColour(oxyBlip, 2)
    SetBlipAsShortRange(oxyBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Drop Off')
    EndTextCommandSetBlipName(oxyBlip)

    SetNewWaypoint(chosenLocation.x, chosenLocation.y)
end

function createPed(data, chosenLocation, locationName, locationList)
    local randomKey = math.random(1, #Config.PedModels[locationName])
    local chosenModel = Config.PedModels[locationName][randomKey]
    local pedModel = lib.requestModel(chosenModel, 60000)

    local dropOffPed = CreatePed(1, pedModel, chosenLocation.x, chosenLocation.y, chosenLocation.z, chosenLocation.w, true, true)

    SetEntityInvincible(dropOffPed, true)
    SetBlockingOfNonTemporaryEvents(dropOffPed, true)

    exports.ox_target:addLocalEntity(dropOffPed, {
        {
            label = 'Hand over Oxy',
            onSelect = function()
                DeliverOxy(data, chosenLocation, locationName, locationList, dropOffPed)
            end,
            icon = 'fa-solid fa-handshake',
            iconColor = 'yellow',
            distance = 2,
        },
    })
    SetModelAsNoLongerNeeded(pedModel)
end

function DeliverOxy(data, chosenLocation, locationName, locationList, dropOffPed)
    local player = cache.ped
    local wasDeliveryMade = lib.callback.await('oxy:server:AttemptDelivery', false)
    local previousLocation = chosenLocation

    if not wasDeliveryMade then
        lib.notify({
            title = 'Failed',
            description = "You suck at this",
            type = 'error'
        })

        missionStarted = false

        return
    end

    TaskTurnPedToFaceEntity(dropOffPed, player, -1)
    Wait(1000)

    --


    -- This space can be used to run an animation between the player adn the NPC
    -- Before it moves on to the next drop off location OR finishes the job



    local recievedItems = lib.callback.await('oxy:server:GiveItems', false, Config.Items.itemGivenToPlayer.itemName, Config.Items.itemGivenToPlayer.amount)

    if not recievedItems then
        lib.notify({
            title = 'Unable',
            description = "You don't have room for the items ... guess I'll keep it",
            type = 'error'
        })
    end


    --
    
    SetEntityInvincible(dropOffPed, false)
    SetPedAsNoLongerNeeded(dropOffPed)
    exports.ox_target:removeLocalEntity(dropOffPed)
    RemoveBlip(oxyBlip)

    amountOfLocations = (amountOfLocations - 1)
    Wait(1000)

    if amountOfLocations <= 0 then
        lib.notify({
            title = 'Finished',
            description = "You've finished! Come back later when I have some more deliveries for you!",
            type = 'inform'
        })

        missionStarted = false
        return
    end

    local chosenLocation = ChooseRandomLocation(locationList, previousLocation)
    
    createBlip(chosenLocation)
    createPed(data, chosenLocation, locationName, locationList)

    lib.notify({
        title = 'Delivered',
        description = "You delivered the goods",
        type = 'success'
    })
end