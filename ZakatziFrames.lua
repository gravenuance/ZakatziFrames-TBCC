
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

local dampeningFrame = CreateFrame('Frame', nil , UIParent)
dampeningFrame:SetSize(200, 12)
dampeningFrame:SetPoint('TOP', UIWidgetTopCenterContainerFrame, 'BOTTOM', 0, -2)
dampeningFrame.text = dampeningFrame:CreateFontString(nil, 'BACKGROUND')
dampeningFrame.text:SetFontObject(GameFontNormalSmall)
dampeningFrame.text:SetAllPoints()
dampeningFrame.timeSinceLastUpdate = 0
local updateInterval = 5
local dampeningText = GetSpellInfo(110310)
dampeningFrame:SetScript('OnUpdate', function(self, elapsed)
    self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed

    if self.timeSinceLastUpdate > updateInterval then
        self.text:SetText(dampeningText..': '..C_Commentator.GetDampeningPercent()..'%')
        self.timeSinceLastUpdate = 0
    end
end)

local function zf_entering_world()
    local instanceType = select(2,IsInInstance())
    dampeningFrame:SetShown(instanceType == 'arena')
end


local function zf_on_load(self)
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("TOPLEFT",UIParent,"TOPLEFT",458,-420)
    PlayerFrame.SetPoint=function()end
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("TOPLEFT",UIParent,"TOPLEFT",684,-420)
    TargetFrame.SetPoint=function()end
    ActionButton1:ClearAllPoints()
    ActionButton1:SetPoint("CENTER",-233,-2)
    ActionButton1.SetPoint = function() end
    ActionBarUpButton:Hide()
    ActionBarDownButton:Hide()
    MultiBarBottomRightButton7:ClearAllPoints()
    MultiBarBottomRightButton7:SetPoint("CENTER",-650,41)
    MultiBarBottomRightButton7.SetPoint = function() end
    MultiBarBottomRightButton1:ClearAllPoints()
    MultiBarBottomRightButton1:SetPoint("CENTER",-398,41)
    MultiBarBottomRightButton1.SetPoint = function() end
    MultiBarBottomLeftButton1:ClearAllPoints()
    MultiBarBottomLeftButton1:SetPoint("CENTER",-232,47)
    MultiBarBottomLeftButton1.SetPoint = function() end
    MainMenuBarArtFrameBackground:Hide()
    MainMenuBarArtFrame.LeftEndCap:Hide()
    MainMenuBarArtFrame.RightEndCap:Hide()
    MainMenuBarArtFrame.PageNumber:Hide()
    StanceButton1:ClearAllPoints()
    StanceButton1:SetPoint("CENTER",-6000,0)
    StanceButton1.SetPoint = function() end
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
    ObjectiveTrackerFrame:Hide()
    ObjectiveTrackerFrame:UnregisterAllEvents()
    ObjectiveTrackerFrame.Show = ObjectiveTrackerFrame.Hide
    StatusTrackingBarManager: SetAlpha(0)

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
    LossOfControlFrame.blackBg:SetAlpha(0)
    LossOfControlFrame.RedLineTop:SetAlpha(0)
    LossOfControlFrame.RedLineBottom:SetAlpha(0)

    PlayerPVPIcon:SetAlpha(0)
	TargetFrameTextureFramePVPIcon:SetAlpha(0)
	FocusFrameTextureFramePVPIcon:SetAlpha(0)
	PlayerPrestigeBadge:SetAlpha(0)
	PlayerPrestigePortrait:SetAlpha(0)
	TargetFrameTextureFramePrestigeBadge:SetAlpha(0)
	TargetFrameTextureFramePrestigePortrait:SetAlpha(0)
	FocusFrameTextureFramePrestigeBadge:SetAlpha(0)
    FocusFrameTextureFramePrestigePortrait:SetAlpha(0)
    
    ChatFrameChannelButton:Hide()
    MicroButtonAndBagsBar:Hide()
    combatFrame:SetScript('OnUpdate', combatUpdate)
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

local event_handler = {
    ["PLAYER_LOGIN"] = function(self) zf_on_load(self) end,
    ["PLAYER_ENTERING_WORLD"] = function() zf_entering_world() end,
}

local function zf_on_event(self,event,...)
	event_handler[event](self,...)
end


if not zf_frame then
    CreateFrame("Frame","zf_frame",UIParent)
end
zf_frame:SetScript("OnEvent",zf_on_event)
zf_frame:RegisterEvent("PLAYER_LOGIN")