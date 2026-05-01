# Profession & Grey Mob XP (Eluna / AzerothCore)

## 💀 The Problem

At some point in Wrath of the Lich King, Azeroth turns into a museum of things that no longer matter.

- Grey mobs? Decorative at best.
- Gathering nodes? Who cares.
- Crafting? A spreadsheet.

You outlevel more than half the world and the game politely stops rewarding you for interacting with it.

---

## ⚔️ The Fix

This Eluna Lua script gives players **small, controlled XP rewards** for doing things the game normally ignores:

- Killing mobs that are “too low level to care about”
- Gathering herbs, ore, and other resources
- Actually crafting things instead of just power-leveling menus

It doesn’t break progression. It just makes the world feel a little less dead.

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

## ⚙️ Configuration

All settings live at the top of the Lua file:

local CFG = {
    GatheringEnabled  = true,
    GatherMultiplier  = 1.0,
etc.

### What You Actually Care About

- **GatherMultiplier** — Turn gathering into a lifestyle or keep it modest  
- **CraftingXP** — How much your artisanal suffering is worth  
- **XPPerMobLevel** — Controls grey mob relevance  
- **XPScaleCap** — Stops players from discovering “infinite kobold tech”  
- **MinMobLevel** — Prevents farming level 1 wildlife into enlightenment  

---

## 📦 Installation

1. Drop the file into your Eluna scripts folder:
2. Restart the server or .reload eluna
3. Go outside and gain XP from picking a flower.

## 🎯 Intended Use
AzerothCore (3.3.5a / Wrath of the Lich King).
Servers running Eluna.
People who think the whole world should matter.

## ⚖️ Balance Notes

It won’t replace questing.
It won’t trivialize progression.
It just fills in the situations where the game gives you nothing.

If your players suddenly hit max level by gardening and working the mines, good for them.

## 🤖 AI Usage Disclosure (Yes, Really)

This script was vibe coded with AI assistance.

That means:

The code was generated and refined with AI help

## 🧠 Why This Exists

Because:

A world where doing content, even old content, that gives zero reward feels broken
Killing something should always feel like it mattered at least a little


## 📜 License

Do whatever you want with it.

Seriously. It’s Lua.
    
