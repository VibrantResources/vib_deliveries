RegisterNetEvent('oxy:client:InspectAIPoliceMenu', function()
    local player = cache.ped
    local headerMenu = {}

    headerMenu[#headerMenu + 1] = {
        title = "Check Notebook",
        description = "Check this Officers notebook for any descroiption of the shooter",
        event = 'oxy:client:DisplayShooterInfo',
        icon = 'fa-solid fa-clipboard',
        iconColor = 'white',
    }

    lib.registerContext({
        id = 'inspect_police_menu',
        title = "Officer Inspection",
        options = headerMenu
    })

    lib.showContext('inspect_police_menu')
end)