# Profession, Gathering & Grey Mob XP
### Eluna / AzerothCore / WotLK 3.3.5a

---

## 💀 The Problem

At some point in Wrath of the Lich King, Azeroth turns into a museum of things that no longer matter.

- Grey mobs? Decorative at best.
- Gathering nodes? Who cares.
- Crafting? A spreadsheet.
- Fishing? Apparently just a hobby.

You outlevel more than half the world and the game politely stops rewarding you for interacting with it.

---

## ⚔️ The Fix

This Eluna Lua script gives players small, controlled XP rewards for doing things the game normally ignores:

- Killing mobs that are "too low level to care about"
- Gathering herbs and ore from nodes in the world
- Actually crafting things instead of just power-leveling menus
- Fishing, because committed fishermen deserve to exist

It doesn't break progression. It just makes the world feel a little less dead.

---

## ✨ Features

### 💀 Grey Mob XP
Kill something beneath you? Congratulations, it still counts.

- Scaled XP based on mob level
- Hard cap to prevent farming abuse
- Per-player cooldown to prevent AOE mob pulls from being worth anything
- Ignores junk targets (critters, totems, non-combat pets)

### 🌿 Gathering XP
Picking flowers now advances your life in a measurable way.

- Triggered by the gather spell cast, not the loot event — no false positives from chests or mob drops
- XP fires once per node regardless of how many items drop
- Multiplier support for server-side tuning
- Covers Vanilla, TBC, and WotLK herbs and ore
- Works alongside normal profession leveling

### 🎣 Fishing XP
Someone has to keep the lakes from getting overcrowded.

- Detected via fishing spell cast — not item-based, so vendor fish don't count
- Flat XP per catch, intentionally low
- Short timeout window keeps it honest

### 🔨 Crafting XP
You made something with your hands. The game acknowledges this.

- Flat XP per skill-up across all major crafting professions
- Applies to: Alchemy, Blacksmithing, Enchanting, Engineering, Jewelcrafting, Leatherworking, Tailoring, Inscription, Cooking, First Aid
- No weird scaling, no nonsense

---

## ⚙️ Configuration

All settings live at the top of the Lua file in the `CFG` table:

```lua
local CFG = {
    GatheringEnabled    = true,
    GatherMultiplier    = 1.0,
    GatherTimeout       = 5,

    FishingEnabled      = true,
    FishingXP           = 10,
    FishingTimeout      = 15,

    CraftingEnabled     = true,
    CraftingXP          = 25,

    GreyMobEnabled      = true,
    XPPerMobLevel       = 2,
    MinMobLevel         = 5,
    XPScaleCap          = 15,
    GreyMobCooldown     = 5,
}
```

**What you actually care about:**

- `GatherMultiplier` — Scale gathering XP up or down globally
- `GatherTimeout` — How long after a gather spell the flag stays active (in seconds). Covers lag and animation time
- `FishingXP` — How much each catch is worth. Keep it low
- `FishingTimeout` — How long after a fishing cast the flag stays active. Should comfortably cover bobber wait time
- `CraftingXP` — How much your artisanal suffering is worth per skill-up
- `XPPerMobLevel` — Controls grey mob relevance. Multiplied by mob level to get XP
- `XPScaleCap` — Stops players from discovering "infinite kobold tech"
- `MinMobLevel` — Prevents farming level 1 wildlife into enlightenment
- `GreyMobCooldown` — Seconds between grey mob XP awards per player. Prevents AOE farming

---

## 📦 Installation

1. Drop `ProfessionAndGreyMobXP.lua` into your Eluna scripts folder
2. Restart the server or run `.reload eluna`
3. Go outside and gain XP from picking a flower

---

## 🎯 Intended Use

AzerothCore (3.3.5a / Wrath of the Lich King). Servers running classic Eluna. People who think the whole world should matter, even the parts you've technically outgrown.

---

## ⚖️ Balance Notes

It won't replace questing. It won't trivialize progression. It fills in the situations where the game gives you nothing and makes the world feel inhabited rather than decorative.

If your players hit max level by farming ore in Elwynn Forest, honestly, good for them. They earned it the hard way.

Grey mob XP in particular is intentionally small and rate-limited. The cooldown means a player chain-pulling twenty grey wolves gets the same XP as killing one. The cap means a level 80 killing level 15 mobs isn't doing math on how to exploit it.

---

## 🤖 AI Usage Disclosure (Yes, Really)

This script was developed with AI assistance. The logic, structure, and tuning decisions were collaborative — the AI wrote code, caught bugs, and asked good questions. The design decisions, XP values, and "is this actually fun" calls were human.

---

## 🧠 Why This Exists

Because a world where doing content — even old content — gives zero reward feels broken. Killing something should always feel like it mattered at least a little. Picking a flower in Hillsbrad at level 70 shouldn't feel like a waste of time.

The whole world should be worth being in.

---

## 📜 License

Do whatever you want with it. Seriously. It's Lua.
