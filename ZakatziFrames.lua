local playerX = 420

local targetX = playerX + 225

local playerY = -350

local targetY = playerY

LoadAddOn("Blizzard_CompactRaidFrames") 
CRFSort_Group=function(t1, t2) 
    if UnitIsUnit(t1,"player") then 
        return false 
    elseif UnitIsUnit(t2,"player") then 
        return true 
    else 
        return t1 < t2 
    end 
end 
CompactRaidFrameContainer.flowSortFunc=CRFSort_Group

-- Add combat indicator
local targetCombatFrame = CreateFrame('Frame', nil , TargetFrame)
targetCombatFrame:SetPoint('LEFT', TargetFrame, 'RIGHT', -68, -15)
targetCombatFrame:SetSize(24,24)
targetCombatFrame.icon = targetCombatFrame:CreateTexture(nil, 'BORDER')
targetCombatFrame.icon:SetAllPoints()
targetCombatFrame.icon:SetTexture([[Interface\CharacterFrame\UI-StateIcon]])
targetCombatFrame.icon:SetTexCoord(0.55, 0.85, 0.1, 0.35)
targetCombatFrame:Hide()

local focusCombatFrame = CreateFrame('Frame', nil , FocusFrame)
focusCombatFrame:SetPoint('LEFT', FocusFrame, 'RIGHT', -68, -15)
focusCombatFrame:SetSize(24,24)
focusCombatFrame.icon = focusCombatFrame:CreateTexture(nil, 'BORDER')
focusCombatFrame.icon:SetAllPoints()
focusCombatFrame.icon:SetTexture([[Interface\CharacterFrame\UI-StateIcon]])
focusCombatFrame.icon:SetTexCoord(0.55, 0.85, 0.1, 0.35)
focusCombatFrame:Hide()

local timeSinceLastUpdate = 0
local combatInterval = 0.1
local function combatUpdate(self, elapsed)
    timeSinceLastUpdate = timeSinceLastUpdate + elapsed

    if timeSinceLastUpdate >= combatInterval then
        targetCombatFrame:SetShown(UnitAffectingCombat('target'))
        focusCombatFrame:SetShown(UnitAffectingCombat('focus'))
        timeSinceLastUpdate = 0
    end
end

-- Hide text in player frame.
local feedbackText = PlayerFrame:CreateFontString(nil, "OVERLAY", "NumberFontNormalHuge")
PlayerFrame.feedbackText = feedbackText
PlayerFrame.feedbackStartTime = 0
PetFrame.feedbackText = feedbackText
PetFrame.feedbackStartTime = 0
PlayerHitIndicator:Hide()
PetHitIndicator:Hide()


local function zf_on_load(self)
    -- start combat indicator
    --zf_frame:SetScript('OnUpdate', combatUpdate)

    -- Fix player and target frames
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("TOPLEFT",UIParent,"TOPLEFT",playerX,playerY)
    PlayerFrame.SetPoint=function()end
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("TOPLEFT",UIParent,"TOPLEFT",targetX,targetY)
    TargetFrame.SetPoint=function()end
    -- enemy nameplates never fade
    SetCVar("nameplateOccludedAlphaMult",1)
    SetCVar("nameplateMaxDistance",41)
    -- move buffs
    function Movebuff() 
        BuffFrame:ClearAllPoints() 
        BuffFrame:SetScale(1.1) 
        BuffFrame:SetPoint("CENTER",PlayerFrame,"CENTER",1040,100) 
    end  
    hooksecurefunc("UIParent_UpdateTopFramePositions",Movebuff) 
    Movebuff()
end

local event_handler = {
    ["PLAYER_LOGIN"] = function(self) zf_on_load(self) end,
}

local function zf_on_event(self,event,...)
	event_handler[event](self,...)
end


if not zf_frame then
    CreateFrame("Frame","zf_frame",UIParent)
end
zf_frame:SetScript("OnEvent",zf_on_event)
zf_frame:RegisterEvent("PLAYER_LOGIN")