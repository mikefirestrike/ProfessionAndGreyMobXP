# Profession & Grey Mob XP (Eluna / AzerothCore)

## 💀 The Problem

At some point in Wrath of the Lich King, Azeroth turns into a museum of things that no longer matter.

- Grey mobs? Decorative.
- Gathering nodes? Chores.
- Crafting? A spreadsheet you occasionally visit.

You outlevel half the world and the game politely stops rewarding you for interacting with it.

This script fixes that.

---

## ⚔️ The Fix

This Eluna Lua script gives players **small, controlled XP rewards** for doing things the game normally ignores:

- Killing mobs that are “too low level to care about”
- Gathering herbs, ore, and other resources
- Actually crafting things instead of just power-leveling menus

It doesn’t break progression. It just makes the world stop feeling dead.

---

## ✨ Features

### 🪦 Grey Mob XP  
Kill something beneath you? Congratulations, it still counts.

- Grants scaled XP based on mob level  
- Hard caps to prevent farming abuse  
- Ignores junk targets (critters, totems, etc.)

---

### 🌿 Gathering XP  
Picking flowers now advances your life in a measurable way.

- XP tied to gathered items  
- Multiplier support for tuning  
- Works alongside normal profession leveling  

---

### 🔨 Crafting XP  
You made something with your hands. The game acknowledges this.

- Flat XP per skill-up  
- Applies to major crafting professions  
- No weird scaling, no nonsense  

---

## ⚙️ Configuration (The Boring But Important Part)

All settings live at the top of the Lua file:

```lua
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
