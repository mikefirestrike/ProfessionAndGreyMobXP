-- ProfessionAndGreyMobXP.lua
-- Gathering XP (herbs/ore via spell flag), Fishing XP, Crafting XP, Grey Mob Kill XP.
-- Classic Eluna (WotLK 3.3.5a)
-- lua_scripts/

local CFG = {
    GatheringEnabled    = true,
    GatherMultiplier    = 1.0,
    GatherTimeout       = 5,       -- seconds after gather spell before flag expires

    FishingEnabled      = true,
    FishingXP           = 10,
    FishingTimeout      = 15,      -- seconds after fishing cast before flag expires

    CraftingEnabled     = true,
    CraftingXP          = 25,

    GreyMobEnabled      = true,
    XPPerMobLevel       = 2,
    MinMobLevel         = 5,
    XPScaleCap          = 15,
    GreyMobCooldown     = 5,       -- seconds between grey mob XP awards per player
}

-- ============================================================
-- SPELL ID SETS
-- ============================================================

local HERB_SPELLS = {
    [2366]  = true,
    [2368]  = true,
    [3570]  = true,
    [11993] = true,
    [28695] = true,
    [50300] = true,
}

local MINING_SPELLS = {
    [2575]  = true,
    [2576]  = true,
    [3564]  = true,
    [10248] = true,
    [29354] = true,
    [50310] = true,
}

local FISHING_SPELLS = {
    [7620]  = true,
    [7731]  = true,
    [7732]  = true,
    [18248] = true,
    [33095] = true,
    [51294] = true,
}

-- ============================================================
-- EXCLUDED CREATURE TYPES
-- ============================================================

local EXCLUDED_CREATURE_TYPES = {
    [8]  = true,  -- Critter
    [11] = true,  -- Totem
    [12] = true,  -- Non-combat pet
}

-- ============================================================
-- CRAFTING SKILLS
-- ============================================================

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
    -- Fishing removed — handled separately via spell flag
}

-- ============================================================
-- GATHERING XP TABLE
-- Keyed by item entry. Wildvine, Eternium, Deadnettle,
-- and Bloodthistle removed — secondary drops or missing nodes.
-- ============================================================

local GATHERING_XP = {
    -- Vanilla Herbs
    [765]   = 30,   -- Silverleaf
    [2447]  = 30,   -- Peacebloom
    [785]   = 30,   -- Mageroyal
    [2449]  = 75,   -- Earthroot
    [2452]  = 100,  -- Swiftthistle
    [2450]  = 100,  -- Briarthorn
    [3820]  = 150,  -- Stranglekelp
    [2453]  = 150,  -- Bruiseweed
    [3369]  = 167,  -- Gravemoss
    [3355]  = 167,  -- Wild Steelbloom
    [3356]  = 195,  -- Kingsblood
    [3357]  = 215,  -- Liferoot
    [3818]  = 227,  -- Fadeleaf
    [3821]  = 265,  -- Goldthorn
    [3358]  = 285,  -- Khadgar's Whisker
    [3819]  = 315,  -- Wintersbite
    [4625]  = 358,  -- Firebloom
    [8831]  = 360,  -- Purple Lotus
    [8836]  = 365,  -- Arthas' Tears
    [8838]  = 365,  -- Sungrass
    [8845]  = 385,  -- Ghost Mushroom
    [8839]  = 378,  -- Blindweed
    [8846]  = 385,  -- Gromsblood
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
    -- WotLK Mining
    [36909] = 1300, -- Cobalt Ore
    [36912] = 1450, -- Saronite Ore
    [36910] = 1865, -- Titanium Ore
}

-- ============================================================
-- STATE TABLES
-- All keyed by player GUID (GetGUIDLow()).
-- ============================================================

-- Tracks pending gather spell: "herb", "mining", or nil
local gatherPending = {}

-- Tracks pending fishing cast: true or nil
local fishingPending = {}

-- Tracks last grey mob XP award time per player
local greyMobLastXP = {}

-- ============================================================
-- HELPERS
-- ============================================================

local function giveXP(player, amount, victim)
    if amount > 0 and player:GetLevel() < 80 then
        player:GiveXP(math.floor(amount), victim)
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
-- SPELL CAST — sets gather/fishing flags
-- ============================================================

local function OnSpellCast(event, player, spell, skipCheck)
    local guid = player:GetGUIDLow()
    local spellId = spell:GetEntry()

    if HERB_SPELLS[spellId] then
        gatherPending[guid] = "herb"
        gatherPending[guid .. "_time"] = os.time()

    elseif MINING_SPELLS[spellId] then
        gatherPending[guid] = "mining"
        gatherPending[guid .. "_time"] = os.time()

    elseif FISHING_SPELLS[spellId] then
        fishingPending[guid] = true
        fishingPending[guid .. "_time"] = os.time()
    end
end

-- ============================================================
-- LOOT ITEM — awards XP if flag is set and valid
-- ============================================================

local function OnLootItem(event, player, item, count)
    if not item then return end
    local guid     = player:GetGUIDLow()
    local itemEntry = item:GetEntry()
    local now      = os.time()

    -- ---- Gathering ----
    if CFG.GatheringEnabled and gatherPending[guid] then
        local elapsed = now - (gatherPending[guid .. "_time"] or 0)
        if elapsed <= CFG.GatherTimeout then
            local baseXP = GATHERING_XP[itemEntry]
            if baseXP then
                giveXP(player, math.floor(baseXP * CFG.GatherMultiplier), nil)
                -- Clear flag so subsequent items from same node don't re-award
                gatherPending[guid] = nil
                gatherPending[guid .. "_time"] = nil
                return
            end
        else
            -- Timeout expired, clear stale flag
            gatherPending[guid] = nil
            gatherPending[guid .. "_time"] = nil
        end
    end

    -- ---- Fishing ----
    if CFG.FishingEnabled and fishingPending[guid] then
        local elapsed = now - (fishingPending[guid .. "_time"] or 0)
        if elapsed <= CFG.FishingTimeout then
            giveXP(player, CFG.FishingXP, nil)
            fishingPending[guid] = nil
            fishingPending[guid .. "_time"] = nil
        else
            fishingPending[guid] = nil
            fishingPending[guid .. "_time"] = nil
        end
    end
end

-- ============================================================
-- SKILL CHANGE — crafting XP on skill-up
-- ============================================================

local function OnSkillChange(event, player, skillId, skillValue)
    if not CFG.CraftingEnabled then return end
    if not CRAFTING_SKILLS[skillId] then return end
    giveXP(player, CFG.CraftingXP, nil)
end

-- ============================================================
-- CREATURE KILL — grey mob XP with per-player cooldown
-- ============================================================

local function OnCreatureKill(event, player, creature)
    if not CFG.GreyMobEnabled then return end
    if EXCLUDED_CREATURE_TYPES[creature:GetCreatureType()] then return end

    local playerLevel   = player:GetLevel()
    local creatureLevel = creature:GetLevel()

    if creatureLevel > getGreyLevel(playerLevel) then return end
    if creatureLevel < CFG.MinMobLevel then return end

    -- Per-player cooldown — prevents AOE farming of grey mobs
    local guid = player:GetGUIDLow()
    local now  = os.time()
    if greyMobLastXP[guid] and (now - greyMobLastXP[guid]) < CFG.GreyMobCooldown then
        return
    end
    greyMobLastXP[guid] = now

    local xp = math.min(creatureLevel, CFG.XPScaleCap) * CFG.XPPerMobLevel
    giveXP(player, xp, creature)
end

-- ============================================================
-- REGISTRATION
-- ============================================================

RegisterPlayerEvent(5,  OnSpellCast)     -- PLAYER_EVENT_ON_SPELL_CAST
RegisterPlayerEvent(32, OnLootItem)      -- PLAYER_EVENT_ON_LOOT_ITEM
RegisterPlayerEvent(45, OnSkillChange)   -- PLAYER_EVENT_ON_SKILL_CHANGE
RegisterPlayerEvent(7,  OnCreatureKill)  -- PLAYER_EVENT_ON_KILL_CREATURE
