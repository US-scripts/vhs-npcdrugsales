Config = Config or {}

Framework = 'esx' -- esx, qbcore 
Notifications = 'ox_lib'  -- qbcore, esx, ox_lib
Progress = 'ox_lib_circle' 

refuseSale = 25 -- % chance a NPC refuses to buy  
policeAlert = 89 -- % a NPC will call the police after refusing a sale
policejob = 'police'

blacklistedJobs = { 'police' }



Sell = {
    weed = { 
        blips = { useBlip = true, sprite = 24, scale = 0.8, color = 3, useRadius = true, label = 'Weed - Sales' }, 
        peds = { loc = vec3(59.4164, -1898.7006, 21.6598), radius = 250.0 }, 
        prices = {
            weed_1g = { price = 250 },
            weed_35g = { price = 850 },
        },
    }, 
    coke = { 
        blips = { useBlip = true, sprite = 24, scale = 0.8, color = 3, useRadius = true, label = 'Coke - Sales' },
        peds = { loc = vec3(-1242.9312, -1548.2281, 4.3107), radius = 250.0 }, 
        prices = {
            coke_1g = { price = 450 },
            coke_35g = { price = 1250 },
        },
    }, 
}



ignorePedsList = {
    'a_c_boar', 
    'a_c_cat_01', 
    'a_c_chickenhawk', 
    'a_c_chimp', 
    'a_c_chop', 
    'a_c_cormorant', 
    'a_c_cow', 
    'a_c_coyote', 
    'a_c_crow', 
    'a_c_deer', 
    'a_c_dolphin', 
    'a_c_fish', 
    'a_c_hen', 
    'a_c_humpback', 
    'a_c_husky', 
    'a_c_killerwhale', 
    'a_c_mtlion', 
    'a_c_pig', 
    'a_c_pigeon', 
    'a_c_poodle', 
    'a_c_pug', 
    'a_c_rabbit_01', 
    'a_c_rat', 
    'a_c_retriever', 
    'a_c_rhesus', 
    'a_c_rottweiler', 
    'a_c_seagull', 
    'a_c_sharkhammer', 
    'a_c_sharktiger', 
    'a_c_shepherd', 
    'a_c_stingray', 
    'a_c_westy', 
}

