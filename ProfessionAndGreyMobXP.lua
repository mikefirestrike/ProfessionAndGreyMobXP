-- ProfessionAndGreyMobXP.lua
-- Gathering XP (herbs/ore), Crafting XP (skill-ups), Grey Mob Kill XP.
-- Classic Eluna (WotLK 3.3.5a)
-- lua_scripts/

local CFG = {
    GatheringEnabled  = true,
    GatherMultiplier  = 1.0,

    CraftingEnabled   = true,
    CraftingXP        = 25,

    GreyMobEnabled    = true,
    XPPerMobLevel     = 2,
    MinMobLevel       = 5,
    XPScaleCap        = 15,
}

local EXCLUDED_CREATURE_TYPES = {
    [8]  = true,  -- Critter
    [11] = true,  -- Totem
    [12] = true,  -- Non-combat pet
}

local CRAFTING_SKILLS = {
    [171] = true,  -- Alchemy
    [164] = true,  -- Blacksmithing
    [333] = true,  -- Enchanting
    [202] = true,  -- Engineering
    [755] = true,  -- Jewelcrafting
    [165] = true,  -- Leatherworking
    [197] = true,  -- Tailoring
    [773] = true,  -- Inscription
    [185] = true,  -- Cooking
    [129] = true,  -- First Aid
}

local GATHERING_XP = {
    -- Vanilla Herbs
    [2447] = 30,    -- Peacebloom
    [765]  = 30,    -- Silverleaf
    [2270] = 30,    -- Bloodthistle
    [785]  = 30,    -- Mageroyal
    [2449] = 75,    -- Earthroot
    [2452] = 100,   -- Swiftthistle
    [2450] = 100,   -- Briarthorn
    [3820] = 150,   -- Stranglekelp
    [2453] = 150,   -- Bruiseweed
    [3369] = 67,    -- Gravemoss
    [3355] = 167,   -- Wild Steelbloom
    [3356] = 195,   -- Kingsblood
    [3357] = 215,   -- Liferoot
    [3818] = 227,   -- Fadeleaf
    [3821] = 265,   -- Goldthorn
    [3358] = 285,   -- Khadgar's Whisker
    [3819] = 315,   -- Wintersbite
    [8153] = 357,   -- Wildvine
    [4625] = 358,   -- Firebloom
    [8831] = 360,   -- Purple Lotus
    [8836] = 365,   -- Arthas' Tears
    [8838] = 365,   -- Sungrass
    [8845] = 385,   -- Ghost Mushroom
    [8839] = 378,   -- Blindweed
    [8846] = 385,   -- Gromsblood
    [13464] = 385,  -- Golden Sansam
    [13463] = 395,  -- Dreamfoil
    [13465] = 400,  -- Mountain Silversage
    [13466] = 405,  -- Plaguebloom
    [13467] = 405,  -- Icecap
    [13468] = 885,  -- Black Lotus
    -- TBC Herbs
    [22789] = 665,  -- Terocone
    [22786] = 885,  -- Dreaming Glory
    [22785] = 885,  -- Felweed
    [22787] = 925,  -- Ragveil
    [22788] = 885,  -- Flamecap
    [22790] = 885,  -- Ancient Lichen
    [22794] = 500,  -- Fel Lotus
    [22792] = 965,  -- Nightmare Vine
    [22791] = 965,  -- Netherbloom
    [22793] = 965,  -- Mana Thistle
    -- WotLK Herbs
    [37921] = 1250, -- Deadnettle
    [36907] = 1250, -- Talandra's Rose
    [36904] = 1250, -- Tiger Lily
    [36901] = 1250, -- Goldclover
    [36903] = 1425, -- Adder's Tongue
    [36908] = 1500, -- Frost Lotus
    [36906] = 1615, -- Icethorn
    [36905] = 1615, -- Lichbloom
    -- Vanilla Mining
    [2770]  = 35,   -- Copper Ore
    [2771]  = 82,   -- Tin Ore
    [2775]  = 85,   -- Silver Ore
    [2772]  = 135,  -- Iron Ore
    [2776]  = 165,  -- Gold Ore
    [7911]  = 275,  -- Truesilver Ore
    [3858]  = 385,  -- Mithril Ore
    [10620] = 415,  -- Thorium Ore
    -- TBC Mining
    [23424] = 693,  -- Fel Iron Ore
    [23425] = 900,  -- Adamantite Ore
    [23426] = 1100, -- Khorium Ore
    [23427] = 605,  -- Eternium Ore
    -- WotLK Mining
    [36909] = 1300, -- Cobalt Ore
    [36912] = 1450, -- Saronite Ore
    [36910] = 1865, -- Titanium Ore
}

-- ============================================================
-- HELPERS
-- ============================================================

local function giveXP(player, amount, victim)
    if amount > 0 and player:GetLevel() < 80 then
        player:GiveXP(amount, victim)
    end
end

local function getGreyLevel(playerLevel)
    if playerLevel <= 5  then return 0 end
    if playerLevel <= 39 then return playerLevel - 5 - math.floor(playerLevel / 10) end
    if playerLevel <= 59 then return playerLevel - 8 end
    if playerLevel <= 69 then return playerLevel - 9 end
    return playerLevel - 10
end

-- ============================================================
-- GATHERING XP
-- ============================================================

local function OnLootItem(event, player, item, count)
    if not CFG.GatheringEnabled then return end
    if not item then return end
    local baseXP = GATHERING_XP[item:GetEntry()]
    if not baseXP then return end
    giveXP(player, math.floor(baseXP * CFG.GatherMultiplier), nil)
end

-- ============================================================
-- CRAFTING XP
-- Fires on any profession skill-up. skillId is exact —
-- no false positives possible.
-- ============================================================

local function OnSkillChange(event, player, skillId, skillValue)
    if not CFG.CraftingEnabled then return end
    if not CRAFTING_SKILLS[skillId] then return end
    giveXP(player, CFG.CraftingXP, nil)
end

-- ============================================================
-- GREY MOB XP
-- ============================================================

local function OnCreatureKill(event, player, creature)
    if not CFG.GreyMobEnabled then return end
    if EXCLUDED_CREATURE_TYPES[creature:GetCreatureType()] then return end

    local playerLevel   = player:GetLevel()
    local creatureLevel = creature:GetLevel()

    if creatureLevel > getGreyLevel(playerLevel) then return end
    if creatureLevel < CFG.MinMobLevel then return end

    local xp = math.min(creatureLevel, CFG.XPScaleCap) * CFG.XPPerMobLevel
    giveXP(player, xp, creature)
end

-- ============================================================
-- REGISTRATION
-- ============================================================

RegisterPlayerEvent(32, OnLootItem)      -- PLAYER_EVENT_ON_LOOT_ITEM
RegisterPlayerEvent(45, OnSkillChange)   -- PLAYER_EVENT_ON_SKILL_CHANGE
RegisterPlayerEvent(7,  OnCreatureKill)  -- PLAYER_EVENT_ON_KILL_CREATURE