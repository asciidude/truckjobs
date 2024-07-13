TruckList = {
    -- https://docs.fivem.net/docs/game-references/vehicle-models/
    -- ^ Trailers can be found here as well.

    -- https://www.gtamap.xyz

    -- Note: Payout is purely for roleplay/UI purposes.
    -- Use enableESX in the Config to enable proper payouts.

    -- Add-on Trucks

    --[[
    model_name = {
        {
            name = "Model Name" -- only needs to be added to the first object of the array
            x = 1735.039, y = 3290.549,
            location = "Sandy Shores Airfield",
            name = "Aircraft Cargo",
            payout = 3500,
            trailer = "trailer_model_name" -- "none" for no trailer
        },
    },
    ]]
    
    -- In-Game Trucks

    mule3 = {
        {
            truckName = "Mule (#3)",
            x = 1735.039, y = 3290.549, z = 41.16,
            location = "Sandy Shores Airfield",
            cargo = "Aircraft Cargo",
            payout = 1250,
            trailer = "none"
        },
        {
            x = 2660.44, y = 3273.51, z = 55.24,
            location = "Farl's Mini-Mart",
            cargo = "Snacks",
            payout = 950,
            trailer = "none"
        },
        {
            x = 1963.32, y = 3755.58, z = 32.25,
            location = "24/7 Supermarket (Sandy)",
            cargo = "Electronics",
            payout = 1000,
            trailer = "none"
        },
        {
            x = 1963.32, y = 3755.58, z = 32.25,
            location = "24/7 Supermarket (Sandy)",
            cargo = "Food & Drink",
            payout = 900,
            trailer = "none"
        },
        {
            x = 1701.56, y = 3599.72, z = 35.34,
            location = "Sandy Shores FD",
            cargo = "Fire Fighting Supplies",
            payout = 3000,
            trailer = "none"
        },
    },

    pounder = {
        {
            truckName = "MTL Pounder",
            x = 1998.14, y = 3053.84, z = 47.05,
            location = "Yellowjack",
            cargo = "Alcoholic Beverages",
            payout = 1000,
            trailer = "none"
        },
        {
            x = 1371.59, y = 3618.64, z = 34.88,
            location = "ACE Liquor",
            cargo = "Alcoholic Beverages & Grocery",
            payout = 2500,
            trailer = "none"
        },
    },

    packer = {
        {
            truckName = "MTL Packer",
            x = 2713.863, y = 1380.488, z = 24.51,
            location = "Power Plant",
            cargo = "Chemicals",
            payout = 8000,
            trailer = "trailers3"
        },
        {
            x = 1862.72, y = 2705.22, z = 45.94,
            location = "Prison",
            cargo = "Food & Drinks",
            payout = 1000,
            trailer = "trailers2"
        },
        {
            x = 2704.1, y = 3453.31, z = 55.65,
            location = "YouTool",
            cargo = "Logs",
            payout = 1500,
            trailer = "trailerlogs"
        },
        {
            x = 2704.1, y = 3453.31, z = 50.34,
            location = "Union Grain Supply",
            cargo = "Bale",
            payout = 2500,
            trailer = "baletrailer"
        },
        {
            x = 2704.1, y = 3453.31, z = 34.25,
            location = "Ammunation",
            cargo = "Weapons & Ammunition",
            payout = 10000,
            trailer = "trailers4"
        },
        {
            x = 1871.02, y = 3690.05, z = 33.65,
            location = "Sandy Shores Medical Center",
            cargo = "Medical Supplies",
            payout = 1000,
            trailer = "trailers2"
        },
        {
            x = 1978.4, y = 3781.17, z = 32.18,
            location = "Sandy Shores Gas Station",
            cargo = "Gas",
            payout = 1500,
            trailer = "tanker"
        },
    }
}