-- EasyCD.lua

local FONT_PATH = "Fonts\\FRIZQT__.TTF"
local BASE_FONT_SIZE = 14 
local buttons = {}

-- upper und buttom
local function CreateOverlay(button)
    if button.cdOverlay then return end

    local overlay = CreateFrame("Frame", nil, button)
    overlay:SetAllPoints(button)
    overlay:SetFrameStrata("TOOLTIP")

    local text = overlay:CreateFontString(nil, "OVERLAY")
    text:SetFont(FONT_PATH, BASE_FONT_SIZE, "OUTLINE")
    text:SetPoint("CENTER", overlay, "CENTER", 0, 0)
    text:SetJustifyH("CENTER")
    text:Hide()

    button.cdOverlay = overlay
    button.cdText = text
    button.lastSize = BASE_FONT_SIZE
end


local function UpdateButton(button)
    if not button.cdText or not button:IsShown() then return end
    
    local start, duration, enable = GetActionCooldown(button:GetID())
    
    if start and start > 0 and duration and duration > 0 then
        local remaining = start + duration - GetTime()
        if remaining > 0 then
            local textStr = string.format("%.2f", remaining)
            button.cdText:SetText(textStr)
            button.cdText:Show()

            
            local currentSize = BASE_FONT_SIZE
            local textLength = string.len(textStr)

            if textLength > 4 then 
                currentSize = 11 
            end
            if textLength > 5 then 
                currentSize = 9  
            end
            if textLength > 6 then 
                currentSize = 7  
            end

            if button.lastSize ~= currentSize then
                button.cdText:SetFont(FONT_PATH, currentSize, "OUTLINE")
                button.lastSize = currentSize
            end

            return
        end
    end
    
    if button.cdText:IsShown() then
        button.cdText:Hide()
        button.lastSize = BASE_FONT_SIZE
    end
end

-- ini
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    local found = 0
    for i = 1, 12 do
        local btn = getglobal("ActionButton" .. i)
        if btn then
            CreateOverlay(btn)
            table.insert(buttons, btn)
            found = found + 1
        end
    end
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00EasyCD:|r Загружено. Кнопок: " .. found)
end)

-- frame update
local updater = CreateFrame("Frame")
local updaterTimer = 0

updater:SetScript("OnUpdate", function()
    updaterTimer = updaterTimer + arg1 
    
    if updaterTimer < 0.1 then return end
    updaterTimer = 0

    for _, btn in ipairs(buttons) do
        UpdateButton(btn)
    end
end)