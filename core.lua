-- AdiBags_Shadowlands_Crafting
-- Created by N6REJ character is Bearesquishy - dalaran please credit whenever.
-- Source on GitHub: https://github.com/N6REJ/AdiBags_Shadowlands_Crafting


local ADDON_NAME, ADDON_TABLE, addon = ...

-- Get reference to AdiBags addon
local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")

local database = ADDON_TABLE.database
local MatchIDs
local Tooltip
local Result = { }
-- local GroupName = "Fish"


-- Create World Variable for database
ShadowLands_Fishing = database

-- Addon info
local version = GetAddOnMetadata(ADDON_NAME, "Version");
local addoninfo = 'Shadowlands Fishing - ' .. database["FilterTitle"];

-- Register this addon with AdiBags
local setFilter = AdiBags:RegisterFilter(ADDON_NAME, 100, "ABEvent-1.0")
setFilter.uiName = addoninfo
setFilter.uiDesc = "Puts base " .. database["FilterTitle"] .. " crafting mats from drops or farming in their own group" .. "     Version: " .. version


-- ??
local function AddToSet(Set, List)
    for _, v in ipairs(List) do
        Set[v] = true
    end
end

local function MatchIDs_Init(self, GroupName)
    wipe(Result)

    -- Get the list of all items in database
    AddToSet(Result, database[GroupName])

    return Result
end

local function Tooltip_Init()
    local tip, leftside = CreateFrame("GameTooltip"), { }
    for i = 1, 6 do
        local Left, Right = tip:CreateFontString(), tip:CreateFontString()
        Left:SetFontObject(GameFontNormal)
        Right:SetFontObject(GameFontNormal)
        tip:AddFontStrings(Left, Right)
        leftside[i] = Left
    end
    tip.leftside = leftside
    return tip
end

function setFilter:OnInitialize()
    self.db = AdiBags.db:RegisterNamespace(ADDON_NAME)
end

function setFilter:Update()
    MatchIDs = nil
    self:SendMessage("AdiBags_FiltersChanged")
end

function setFilter:OnEnable()
    AdiBags:UpdateFilters()
end

function setFilter:OnDisable()
    AdiBags:UpdateFilters()
end

function setFilter:Filter(slotData)

    -- sort Categories
    for key, value in ipairs(database["Categories"]) do

        -- Sort Items
        MatchIDs = MatchIDs or MatchIDs_Init(self, value)
        if MatchIDs[slotData.itemId] then
            
            -- This sets the name of the group of items
            return value

        end

        -- Continue ?
        Tooltip = Tooltip or Tooltip_Init()
        Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
        Tooltip:ClearLines()

        if slotData.bag == BANK_CONTAINER then
            Tooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(slotData.slot, nil))
        else
            Tooltip:SetBagItem(slotData.bag, slotData.slot)
        end

        Tooltip:Hide()
    end
end