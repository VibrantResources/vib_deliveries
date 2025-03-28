local torchObject = nil

function CallAIPolice()
    local player = cache.ped
    local playerCoords = GetEntityCoords(player)
    local policeModel = lib.RequestModel('s_m_y_cop_01', 60000)
    local randomSpawnLocation = getRandomPointInArea(playerCoords, 25.0)
    local spawnedPolice = CreatePed(1, 's_m_y_cop_01', randomSpawnLocation.x, randomSpawnLocation.y, randomSpawnLocation.z, 0.0, false, true)

    PlayPedAmbientSpeechNative(spawnedPolice, 'GENERIC_CURSE_HIGH', 'Speech_Params_Force')
    GiveWeaponToPed(spawnedPolice, 'weapon_pistol', 1000, false, true)
    TaskGoStraightToCoord(spawnedPolice, playerCoords.x, playerCoords.y, playerCoords.z, 0.6, -1, 0.0, 0.5)

    local torchModel = lib.RequestModel('prop_cs_police_torch_02', 60000)
    torchObject = CreateObject(torchModel, GetEntityCoords(spawnedPolice), true, true, true)
	AttachEntityToEntity(torchObject, spawnedPolice, GetPedBoneIndex(spawnedPolice, 18905), 0.2, 0.0, 0.0, 0.0, 0.0, 80.0, true, true, false, true, 1, true)

    local searchDict = lib.RequestAnimDict('amb@world_human_security_shine_torch@male@idle_b')
    TaskPlayAnim(spawnedPolice, searchDict, 'idle_e', 1.0, 1.0, -1, 49, 0, 0, 0, 0)
    RemoveAnimDict(searchDict)

    SetModelAsNoLongerNeeded(policeModel)
    SetModelAsNoLongerNeeded(torchModel)
    CreatePoliceTracker(spawnedPolice)
end

function CreatePoliceTracker(spawnedPolice)
    local player = cache.ped
    local isPoliceDead = IsEntityDead(spawnedPolice)
    local tick = 15

    CreateThread(function()
        while not isPoliceDead do
            Wait(1000)
            tick = (tick - 1)
            if IsEntityDead(spawnedPolice) then
                CreateTargetForDeadOfficer(spawnedPolice)
                DeleteObject(torchObject)

                return
            end

            if tick <= 0 then
                DeleteEntity(spawnedPolice)
                DeleteObject(torchObject)
                return
            end
        end
    end)
end

function CreateTargetForDeadOfficer(spawnedPolice)
    local player = cache.ped

    exports.ox_target:addLocalEntity(spawnedPolice, {
        {
            label = 'Inspect Corpse',
            event = 'oxy:client:InspectAIPoliceMenu',
            icon = 'fa-solid fa-comment-dots',
            iconColor = 'yellow',
            distance = 2,
        },
    })
end