
-- Add combat indicator
local targetCombatFrame = CreateFrame('Frame', nil , TargetFrame)
targetCombatFrame:SetPoint('LEFT', TargetFrame, 'RIGHT', -68, -15)
targetCombatFrame:SetSize(25,25)
targetCombatFrame.icon = targetCombatFrame:CreateTexture(nil, 'BORDER')
targetCombatFrame.icon:SetAllPoints()
targetCombatFrame.icon:SetTexture([[Interface\CharacterFrame\UI-StateIcon]])
targetCombatFrame.icon:SetTexCoord(0.5625, 0.9, 0.08, 0.4375)
targetCombatFrame:Hide()

local focusCombatFrame = CreateFrame('Frame', nil , FocusFrame)
focusCombatFrame:SetPoint('LEFT', FocusFrame, 'RIGHT', -68, -15)
focusCombatFrame:SetSize(25,25)
focusCombatFrame.icon = focusCombatFrame:CreateTexture(nil, 'BORDER')
focusCombatFrame.icon:SetAllPoints()
focusCombatFrame.icon:SetTexture([[Interface\CharacterFrame\UI-StateIcon]])
focusCombatFrame.icon:SetTexCoord(0.5625, 0.9, 0.08, 0.4375)
focusCombatFrame:Hide()

local combatFrame = CreateFrame('Frame', nil , UIParent)
combatFrame.timeSinceLastUpdate = 0
local combatInterval = 0.1
local function combatUpdate(self, elapsed)
    self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed

    if self.timeSinceLastUpdate > combatInterval then
        targetCombatFrame:SetShown(UnitAffectingCombat('target'))
        focusCombatFrame:SetShown(UnitAffectingCombat('focus'))
        self.timeSinceLastUpdate = 0
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
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("TOPLEFT",UIParent,"TOPLEFT",458,-420)
    PlayerFrame.SetPoint=function()end
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("TOPLEFT",UIParent,"TOPLEFT",684,-420)
    TargetFrame.SetPoint=function()end
    local r={"MultiBarBottomLeft", "MultiBarBottomRight", "Action", "MultiBarLeft", "MultiBarRight"} 
    for b=1,#r do 
        for i=1,12 do 
            _G[r[b].."Button"..i.."Name"]:SetAlpha(0) 
        end 
    end
    SetCVar("nameplateOccludedAlphaMult",1)
    function Movebuff() 
        BuffFrame:ClearAllPoints() 
        BuffFrame:SetScale(1.1) 
        BuffFrame:SetPoint("CENTER",PlayerFrame,"CENTER",1000,80) 
    end  
    hooksecurefunc("UIParent_UpdateTopFramePositions",Movebuff) 
    Movebuff()

    MinimapZoomIn:Hide()
    MinimapZoomOut:Hide()

    Minimap:EnableMouseWheel(true)
    Minimap:SetScript('OnMouseWheel', function(self, arg1)
        if arg1 > 0 then
            Minimap_ZoomIn()
        else
            Minimap_ZoomOut()
        end
    end)

    PlayerPVPIcon:SetAlpha(0)
	TargetFrameTextureFramePVPIcon:SetAlpha(0)
	FocusFrameTextureFramePVPIcon:SetAlpha(0)
	TargetFrameTextureFramePrestigeBadge:SetAlpha(0)
	TargetFrameTextureFramePrestigePortrait:SetAlpha(0)
	FocusFrameTextureFramePrestigeBadge:SetAlpha(0)
    FocusFrameTextureFramePrestigePortrait:SetAlpha(0)
    ChatFrameChannelButton:Hide()
    combatFrame:SetScript('OnUpdate', combatUpdate)
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