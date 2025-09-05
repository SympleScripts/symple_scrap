Config = {}
Config.Framework = 'QBCore'  
Config.CoreObject = 'qbx_core' 
Config.target = "ox" 
Config.inventory = "ox" 

-- Boss NPC settings
Config.BossSettings = {
    model = "csb_jackhowitzer",
    cooldownTime = 30 * 60 * 1000, -- 30 minutes in milliseconds
    locations = {
        {
            coords = vector3(-464.02, -1686.36, 17.95),
            heading = 180.0,
            scrapyardIndex = 1 -- Davis Scrapyard
        },
        {
            coords = vector3(2370.3, 3157.0, 47.21),
            heading = 90.0,
            scrapyardIndex = 2 -- La Mesa Scrapyard
        }
    }
}

Config.Translation = {
    Search = "Search for Materials",
    progress = "Searching through wreckage...",
    skillcheck = "Complete the skill check to search effectively!",
    skillcheck_failed = "You failed the skill check and found nothing",
    found = "Found materials:",
    nothing = "Found nothing useful",
    inventory_full = "Inventory full - couldn't receive some items",
    entered_scrapyard = "Entered %s - Search through wreckage for materials",
    left_scrapyard = "Left scrapyard area",
    
    -- Boss NPC translations
    talk_to_boss = "Talk to Boss",
    need_permission = "You need permission from the boss first! He's somewhere around here...",
    boss_greeting = "Looking to search through my scrapyard? I'll give you permission for 30 minutes. Make it count!",
    permission_granted = "Permission granted! You can now search for materials in this scrapyard.",
    permission_active = "You already have permission to search. Get to work!",
    cooldown_active = "Come back later, I already gave you a chance today. Wait %s more.",
    permission_expired = "Your search permission has expired. Talk to the boss again.",
    time_up = "Time's up! Your 30-minute search session has ended. Come back in 30 minutes.",
    time_up_cooldown = "Your time is up! You can come back in 30 minutes.",
    search_disabled = "You can't search right now. Come back in %s minutes."
}

-- Scrapyard locations with detection zones
Config.ScrapyardLocations = {
    {
        name = "Sandy Scrapyard",
        coords = vector3(2406.3, 3118.04, 48.19),
        radius = 250.0, -- Expanded from 150
        blip = {
            sprite = 365,
            color = 17,
            scale = 0.8,
            label = "Scrapyard"
        }
    },
    {
        name = "Davis Scrapyard", 
        coords = vector3(-452.16, -1705.35, 18.84),
        radius = 200.0, -- Expanded from 120
        blip = {
            sprite = 365,
            color = 17,
            scale = 0.8,
            label = "Scrapyard"
        }
    }
   
}

-- Search settings
Config.SearchSettings = {
    duration = 4000, -- 4 seconds search time
    interactionDistance = 2.5, -- meters
    animDict = "amb@prop_human_bum_bin@base",
    animName = "base",
    
    -- Skill check settings
    skillCheck = {
        difficulty = {'easy', 'easy'}, -- Two easy skill checks
        keys = {'w', 's'} -- Keys to use for skill check
    }
}
-- Searchable props in scrapyards
Config.SearchableProps = {
    -- Car Parts Props
    "prop_car_bonnet_01",
    "prop_car_bonnet_02", 
    "prop_car_door_01",
    "prop_car_door_02",
    "prop_car_door_03",
    "prop_car_door_04",
    "prop_car_engine_01",
    
    -- Rubbish/Scrap Car Models
    "prop_rub_carpart_02",
    "prop_rub_carpart_03",
    "prop_rub_carpart_04",
    "prop_rub_carpart_05",
    "prop_rub_carpart_06",
    "prop_rub_carpart_07",
    "prop_rub_chassis_01",
    "prop_rub_chassis_02", 
    "prop_rub_chassis_03",
    
    -- Vehicle Wreckage Props
    "prop_rub_trukwreck_1",
    "prop_rub_trukwreck_2",
    "prop_rub_wreckage_3",
    "prop_rub_wreckage_4",
    "prop_rub_wreckage_5",
    "prop_rub_wreckage_6",
    "prop_rub_wreckage_7",
    "prop_rub_wreckage_8",
    "prop_rub_wreckage_9",
    
    -- Car Wreckage Props (the ones you actually have!)
    "prop_rub_carwreck_1",
    "prop_rub_carwreck_2",
    "prop_rub_carwreck_3",
    "prop_rub_carwreck_4",
    "prop_rub_carwreck_5",
    "prop_rub_carwreck_6",
    "prop_rub_carwreck_7",
    "prop_rub_carwreck_8",
    "prop_rub_carwreck_9",
    "prop_rub_carwreck_10",
    "prop_rub_carwreck_11",
    "prop_rub_carwreck_12",
    "prop_rub_carwreck_13",
    "prop_rub_carwreck_14",
    "prop_rub_carwreck_15",
    "prop_rub_carwreck_16",
    "prop_rub_carwreck_17",
    "prop_rub_carwreck_18",
    "prop_rub_carwreck_19",
    "prop_rub_carwreck_20",
    
    -- Additional Scrap Props
    "prop_rub_scrap_02",
    "prop_rub_scrap_03",
    "prop_rub_scrap_04",
    "prop_rub_scrap_05",
    "prop_rub_scrap_06",
    "prop_rub_scrap_07",
    "prop_rub_wheel_01",
    "prop_rub_wheel_02",
    "prop_rub_tyre_01",
    "prop_rub_tyre_02",
    "prop_rub_tyre_03",
    
    -- Additional common scrap props
    "prop_rub_binbag_01",
    "prop_rub_binbag_03",
    "prop_rub_binbag_04",
    "prop_rub_binbag_06",
    "prop_rub_buswreck_01",
    "prop_rub_buswreck_02",
    "prop_rub_buswreck_03",
    "prop_rub_buswreck_04",
    "prop_rub_buswreck_05",
    "prop_rub_buswreck_06",
    "prop_rub_buswreck_07",
    "prop_rub_buswreck_08",
    "prop_rub_railwreck_1",
    "prop_rub_railwreck_2",
    "prop_rub_railwreck_3",
    
    -- Metal containers and barrels
    "prop_barrel_02a",
    "prop_barrel_03a",
    "prop_dumpster_01a",
    "prop_dumpster_02a",
    "prop_dumpster_02b",
    "prop_dumpster_3a",
    "prop_dumpster_4a",
    "prop_dumpster_4b",
    
    -- Container props
    "prop_container_01a",
    "prop_container_01b",
    "prop_container_01c",
    "prop_container_01d",
    "prop_container_01e",
    "prop_container_01f",
    "prop_container_01g",
    "prop_container_01h",
    "prop_container_02a",
    "prop_container_03a",
    "prop_container_03b",
    "prop_container_03_ld",
    "prop_container_04a",
    "prop_container_05a",
    "prop_container_05b",
    "prop_container_ld",
    "prop_container_ld2",
    
    -- Additional container variants
    "prop_rub_cont_01a",
    "prop_rub_cont_01b",
    "prop_rub_cont_01c",
    
    -- Oil tubs and barrels
    "prop_oiltub_01",
    "prop_oiltub_02",
    "prop_oiltub_03",
    "prop_oiltub_04",
    "prop_oiltub_05",
    "prop_barrel_01a",
    "prop_barrel_01b",
    "prop_barrel_float_1",
    "prop_barrel_float_2",
    
    -- Wooden boxes and crates
    "prop_box_wood01a",
    "prop_box_wood02a",
    "prop_box_wood03a",
    "prop_box_wood04a",
    "prop_box_wood05a",
    "prop_box_wood06a",
    "prop_cratepile_01a",
    "prop_cratepile_02a",
    "prop_cratepile_07a",
    
    -- Planks and wood scraps
    "prop_rub_planks_01",
    "prop_rub_planks_02",
    "prop_rub_planks_03",
    "prop_rub_planks_04",
    "prop_wood_pallet_01a",
    "prop_wood_pallet_04a",
    
    -- Additional scrapyard props
    "prop_skip_01a",
    "prop_skip_02a",
    "prop_skip_03",
    "prop_skip_04",
    "prop_skip_05a",
    "prop_skip_06a",
    "prop_skip_07a",
    "prop_skip_08a",
    "prop_rub_monitor",
    "prop_rub_tv01",
    "prop_rub_tv02",
    "prop_byard_pipe_01",
    "prop_byard_pipe_02",
    "prop_byard_pipe_03",
    "prop_byard_pipe_04",
    
    -- Box piles and additional scrap
    "prop_rub_boxpile_01",
    "prop_rub_boxpile_02",
    "prop_rub_boxpile_03",
    "prop_rub_boxpile_04",
    "prop_rub_boxpile_05",
    "prop_rub_boxpile_06",
    
    -- High-count props from Davis scrapyard
    "prop_pallet_02a", -- 9 instances
    "prop_container_old1", -- 8 instances  
    "prop_cablespool_01a", -- 5 instances
    "prop_rub_cage01a", -- 5 instances
    "prop_woodpile_03a", -- 3 instances
    "prop_rub_cardpile_01", -- 2 instances
    "prop_rub_cardpile_03", -- 2 instances
    "prop_rub_trolley02a", -- 2 instances
    "prop_pallet_pile_01", -- 2 instances
    "prop_pallet_01a", -- 2 instances
    "prop_pallet_03b", -- 2 instances
    "prop_pallet_pile_03", -- 1 instance
    "prop_watercrate_01", -- 1 instance
    
    -- Common damaged vehicle props (these might be what you're seeing)
    "prop_car_seat",
    "prop_car_seat_02",
    "prop_bumper_01",
    "prop_bumper_02",
    "prop_bumper_03",
    "prop_bumper_car_01",
    "prop_bumper_car_02",
    "prop_car_exhaust_01",
    "prop_car_exhaust_02",
    "prop_car_battery_01",
    "prop_car_battery_02",
    
    -- Alternative naming patterns that might exist
    "veh_prop_car_bonnet_01",
    "veh_prop_car_door_01",
    "cs_prop_car_door_01",
    "cs_prop_car_bonnet_01"
}

-- Loot tables by prop category
Config.LootTables = {
    -- Engine/Chassis props - Higher chance for metal and gun parts
    engine_chassis = {
        common = {
            {item = "metalscrap", min = 1, max = 3, chance = 55},
            {item = "steel", min = 2, max = 4, chance = 70},
            {item = "iron", min = 2, max = 4, chance = 65}
        },
        uncommon = {
            {item = "aluminum", min = 1, max = 3, chance = 35},
            {item = "copper", min = 1, max = 3, chance = 30}
        },
        rare = {
            {item = "auto_gunparts", min = 1, max = 1, chance = 2},
            {item = "pistol_gunparts", min = 1, max = 1, chance = 2}
        }
    },
    
    -- Door/Bonnet props - Higher chance for glass and plastic
    door_bonnet = {
        common = {
            {item = "plastic", min = 3, max = 5, chance = 75},
            {item = "glass", min = 3, max = 5, chance = 70},
            {item = "rubber", min = 2, max = 3, chance = 60}
        },
        uncommon = {
            {item = "metalscrap", min = 1, max = 2, chance = 25},
            {item = "iron", min = 1, max = 3, chance = 35}
        },
        rare = {
            {item = "pistol_gunparts", min = 1, max = 1, chance = 2},
            {item = "auto_gunparts", min = 1, max = 1, chance = 2}
        }
    },
    
    -- Wheel/Tire props - Higher chance for rubber and common materials
    wheel_tire = {
        common = {
            {item = "rubber", min = 4, max = 7, chance = 85},
            {item = "metalscrap", min = 1, max = 2, chance = 45},
            {item = "plastic", min = 2, max = 3, chance = 55}
        },
        uncommon = {
            {item = "steel", min = 1, max = 3, chance = 35},
            {item = "iron", min = 1, max = 3, chance = 30}
        },
        rare = {
            {item = "shotgun_gunparts", min = 1, max = 1, chance = 21},
            {item = "pistol_gunparts", min = 1, max = 1, chance = 2}
        }
    },
    
    -- Wreckage props - Balanced loot table with slightly higher rare item chance
    wreckage = {
        common = {
            {item = "metalscrap", min = 1, max = 3, chance = 50},
            {item = "steel", min = 2, max = 4, chance = 65},
            {item = "iron", min = 2, max = 4, chance = 60},
            {item = "plastic", min = 2, max = 4, chance = 55}
        },
        uncommon = {
            {item = "aluminum", min = 1, max = 3, chance = 38},
            {item = "glass", min = 2, max = 4, chance = 35},
            {item = "copper", min = 1, max = 3, chance = 32}
        },
        rare = {
            {item = "auto_gunparts", min = 1, max = 1, chance = 2},
            {item = "shotgun_gunparts", min = 1, max = 1, chance = 2},
            {item = "pistol_gunparts", min = 1, max = 1, chance = 5}
        }
    },
    
    -- Industrial storage props - Good for basic materials and some gun parts
    industrial_storage = {
        common = {
            {item = "metalscrap", min = 1, max = 2, chance = 40},
            {item = "plastic", min = 3, max = 5, chance = 75},
            {item = "steel", min = 2, max = 3, chance = 55},
            {item = "iron", min = 2, max = 3, chance = 60}
        },
        uncommon = {
            {item = "aluminum", min = 1, max = 3, chance = 40},
            {item = "copper", min = 1, max = 3, chance = 35},
            {item = "glass", min = 2, max = 3, chance = 30}
        },
        rare = {
            {item = "pistol_gunparts", min = 1, max = 1, chance = 5},
            {item = "auto_gunparts", min = 1, max = 1, chance = 2},
            {item = "shotgun_gunparts", min = 1, max = 1, chance = 2}
        }
    }
}

-- Prop category mapping
Config.PropCategories = {
    -- Engine/Chassis
    ["prop_car_engine_01"] = "engine_chassis",
    ["prop_rub_chassis_01"] = "engine_chassis",
    ["prop_rub_chassis_02"] = "engine_chassis",
    ["prop_rub_chassis_03"] = "engine_chassis",
    
    -- Door/Bonnet
    ["prop_car_bonnet_01"] = "door_bonnet",
    ["prop_car_bonnet_02"] = "door_bonnet",
    ["prop_car_door_01"] = "door_bonnet",
    ["prop_car_door_02"] = "door_bonnet",
    ["prop_car_door_03"] = "door_bonnet",
    ["prop_car_door_04"] = "door_bonnet",
    
    -- Wheel/Tire
    ["prop_rub_wheel_01"] = "wheel_tire",
    ["prop_rub_wheel_02"] = "wheel_tire",
    ["prop_rub_tyre_01"] = "wheel_tire",
    ["prop_rub_tyre_02"] = "wheel_tire",
    ["prop_rub_tyre_03"] = "wheel_tire",
    
    -- Everything else is wreckage
    ["prop_rub_carpart_02"] = "wreckage",
    ["prop_rub_carpart_03"] = "wreckage",
    ["prop_rub_carpart_04"] = "wreckage",
    ["prop_rub_carpart_05"] = "wreckage",
    ["prop_rub_carpart_06"] = "wreckage",
    ["prop_rub_carpart_07"] = "wreckage",
    ["prop_rub_trukwreck_1"] = "wreckage",
    ["prop_rub_trukwreck_2"] = "wreckage",
    ["prop_rub_wreckage_3"] = "wreckage",
    ["prop_rub_wreckage_4"] = "wreckage",
    ["prop_rub_wreckage_5"] = "wreckage",
    ["prop_rub_wreckage_6"] = "wreckage",
    ["prop_rub_wreckage_7"] = "wreckage",
    ["prop_rub_wreckage_8"] = "wreckage",
    ["prop_rub_wreckage_9"] = "wreckage",
    ["prop_rub_scrap_02"] = "wreckage",
    ["prop_rub_scrap_03"] = "wreckage",
    ["prop_rub_scrap_04"] = "wreckage",
    ["prop_rub_scrap_05"] = "wreckage",
    ["prop_rub_scrap_06"] = "wreckage",
    ["prop_rub_scrap_07"] = "wreckage",
    
    -- Car wreckage props
    ["prop_rub_carwreck_1"] = "wreckage",
    ["prop_rub_carwreck_2"] = "wreckage",
    ["prop_rub_carwreck_3"] = "wreckage",
    ["prop_rub_carwreck_4"] = "wreckage",
    ["prop_rub_carwreck_5"] = "wreckage",
    ["prop_rub_carwreck_6"] = "wreckage",
    ["prop_rub_carwreck_7"] = "wreckage",
    ["prop_rub_carwreck_8"] = "wreckage",
    ["prop_rub_carwreck_9"] = "wreckage",
    ["prop_rub_carwreck_10"] = "wreckage",
    ["prop_rub_carwreck_11"] = "wreckage",
    ["prop_rub_carwreck_12"] = "wreckage",
    ["prop_rub_carwreck_13"] = "wreckage",
    ["prop_rub_carwreck_14"] = "wreckage",
    ["prop_rub_carwreck_15"] = "wreckage",
    ["prop_rub_carwreck_16"] = "wreckage",
    ["prop_rub_carwreck_17"] = "wreckage",
    ["prop_rub_carwreck_18"] = "wreckage",
    ["prop_rub_carwreck_19"] = "wreckage",
    ["prop_rub_carwreck_20"] = "wreckage",
    
    -- Container props - treat as wreckage
    ["prop_container_01a"] = "wreckage",
    ["prop_container_01b"] = "wreckage",
    ["prop_container_01c"] = "wreckage",
    ["prop_container_01d"] = "wreckage",
    ["prop_container_01e"] = "wreckage",
    ["prop_container_01f"] = "wreckage",
    ["prop_container_01g"] = "wreckage",
    ["prop_container_01h"] = "wreckage",
    ["prop_container_02a"] = "wreckage",
    ["prop_container_03a"] = "wreckage",
    ["prop_container_03b"] = "wreckage",
    ["prop_container_03_ld"] = "wreckage",
    ["prop_container_04a"] = "wreckage",
    ["prop_container_05a"] = "wreckage",
    ["prop_container_05b"] = "wreckage",
    ["prop_container_ld"] = "wreckage",
    ["prop_container_ld2"] = "wreckage",
    
    -- Bus wreck props
    ["prop_rub_buswreck_01"] = "wreckage",
    ["prop_rub_buswreck_02"] = "wreckage",
    ["prop_rub_buswreck_03"] = "wreckage",
    ["prop_rub_buswreck_04"] = "wreckage",
    ["prop_rub_buswreck_05"] = "wreckage",
    ["prop_rub_buswreck_06"] = "wreckage",
    ["prop_rub_buswreck_07"] = "wreckage",
    ["prop_rub_buswreck_08"] = "wreckage",
    
    -- Additional container variants
    ["prop_rub_cont_01a"] = "wreckage",
    ["prop_rub_cont_01b"] = "wreckage",
    ["prop_rub_cont_01c"] = "wreckage",
    
    -- Oil tubs and barrels - treat as industrial storage
    ["prop_oiltub_01"] = "industrial_storage",
    ["prop_oiltub_02"] = "industrial_storage",
    ["prop_oiltub_03"] = "industrial_storage",
    ["prop_oiltub_04"] = "industrial_storage",
    ["prop_oiltub_05"] = "industrial_storage",
    ["prop_barrel_01a"] = "industrial_storage",
    ["prop_barrel_01b"] = "industrial_storage",
    ["prop_barrel_float_1"] = "industrial_storage",
    ["prop_barrel_float_2"] = "industrial_storage",
    
    -- Wooden boxes and crates
    ["prop_box_wood01a"] = "industrial_storage",
    ["prop_box_wood02a"] = "industrial_storage",
    ["prop_box_wood03a"] = "industrial_storage",
    ["prop_box_wood04a"] = "industrial_storage",
    ["prop_box_wood05a"] = "industrial_storage",
    ["prop_box_wood06a"] = "industrial_storage",
    ["prop_cratepile_01a"] = "industrial_storage",
    ["prop_cratepile_02a"] = "industrial_storage",
    ["prop_cratepile_07a"] = "industrial_storage",
    
    -- Planks and wood scraps
    ["prop_rub_planks_01"] = "industrial_storage",
    ["prop_rub_planks_02"] = "industrial_storage",
    ["prop_rub_planks_03"] = "industrial_storage",
    ["prop_rub_planks_04"] = "industrial_storage",
    ["prop_wood_pallet_01a"] = "industrial_storage",
    ["prop_wood_pallet_04a"] = "industrial_storage",
    
    -- Skip containers (dumpsters)
    ["prop_skip_01a"] = "industrial_storage",
    ["prop_skip_02a"] = "industrial_storage",
    ["prop_skip_03"] = "industrial_storage",
    ["prop_skip_04"] = "industrial_storage",
    ["prop_skip_05a"] = "industrial_storage",
    ["prop_skip_06a"] = "industrial_storage",
    ["prop_skip_07a"] = "industrial_storage",
    ["prop_skip_08a"] = "industrial_storage",
    
    -- Electronic scrap items
    ["prop_rub_monitor"] = "door_bonnet", -- Electronics category
    ["prop_rub_tv01"] = "door_bonnet",
    ["prop_rub_tv02"] = "door_bonnet",
    
    -- Metal pipes
    ["prop_byard_pipe_01"] = "engine_chassis", -- Metal category
    ["prop_byard_pipe_02"] = "engine_chassis",
    ["prop_byard_pipe_03"] = "engine_chassis",
    ["prop_byard_pipe_04"] = "engine_chassis",
    
    -- Box piles
    ["prop_rub_boxpile_01"] = "industrial_storage",
    ["prop_rub_boxpile_02"] = "industrial_storage",
    ["prop_rub_boxpile_03"] = "industrial_storage",
    ["prop_rub_boxpile_04"] = "industrial_storage",
    ["prop_rub_boxpile_05"] = "industrial_storage",
    ["prop_rub_boxpile_06"] = "industrial_storage",
    
    -- High-count Davis scrapyard props
    ["prop_pallet_02a"] = "industrial_storage", -- Wood pallets
    ["prop_container_old1"] = "industrial_storage", -- Old containers
    ["prop_cablespool_01a"] = "door_bonnet", -- Cable spools (electronics)
    ["prop_rub_cage01a"] = "engine_chassis", -- Metal cages
    ["prop_woodpile_03a"] = "industrial_storage", -- Wood piles
    ["prop_rub_cardpile_01"] = "industrial_storage", -- Cardboard piles
    ["prop_rub_cardpile_03"] = "industrial_storage", -- Cardboard piles
    ["prop_rub_trolley02a"] = "engine_chassis", -- Metal trolleys
    ["prop_pallet_pile_01"] = "industrial_storage", -- Pallet piles
    ["prop_pallet_01a"] = "industrial_storage", -- Individual pallets
    ["prop_pallet_03b"] = "industrial_storage", -- Pallet variants
    ["prop_pallet_pile_03"] = "industrial_storage", -- More pallet piles
    ["prop_watercrate_01"] = "industrial_storage" -- Water crates
}