Config = Config or {}

Config.CoreInfo = {
    Debug = false,
    MaxAmountOfRunsPerLocation = 3,
    CooldownBetweenRunsInMinutes = 0.2,
    UseAIPolice = true,
}

Config.Items = {
    -- This is the item given to the player when starting a run and how many the player hands to the dropoff NPC
    -- The player is given the same amount of these as they are given amount of drop off locations, so it's up to them
    -- to keep hold of enough of them to finish their run
    oxyRunStarterItem = {
        itemName = "money",
        dropOffAmount = 1,
    },
    -- This is the item given to players when making their deliveries, provided the NPC does NOT call the cops
    -- If the NPC calls the cops, they take the item, call the cops and run off
    itemGivenToPlayer = {
        itemName = "oxy",
        amount = 1,
    },
}

Config.PedModels = {
    -- This is a list of possible ped models that the drop off NPC can be
    sandyShores = {
        'g_m_y_lost_02',
        'g_f_y_lost_01',
        'g_m_y_lost_03',
        'mp_m_bogdangoon',
        'mp_m_exarmy_01',
        's_m_y_dealer_01',
    },
    southSide = {
        'g_m_y_ballaeast_01',
        'g_m_y_mexgoon_03',
        'g_m_y_ballasout_01',
        'g_m_y_famca_01',
        'g_m_y_famdnf_01',
        'g_m_y_famfor_01',
        'g_m_y_ballaorig_01',
        'g_m_y_mexgoon_01',
        'g_m_y_mexgoon_02',
        'g_m_y_salvagoon_01',
        'g_f_importexport_01',
        'g_f_y_ballas_01',
        'g_f_y_families_01',
    },
    paletoBay = {
        'g_m_m_chicold_01',
        'g_m_m_chigoon_01',
        'g_m_m_chigoon_02',
        'g_m_y_strpunk_01',
        'mp_m_counterfeit_01',
        's_f_y_hooker_01',
        's_m_m_postal_02',
        's_m_y_mime',
        'ig_ramp_hic',
        'ig_rashcosvki',
    },
}