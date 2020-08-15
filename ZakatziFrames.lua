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
    MultiBarBottomLeftButton1:SetPoint("cENTER",-232,47)
    MultiBarBottomLeftButton1.SetPoint = function() end
    MainMenuBarArtFrameBackground:Hide()
    MainMenuBarArtFrame.LeftEndCap:Hide()
    MainMenuBarArtFrame.RightEndCap:Hide()
    MainMenuBarArtFrame.PageNumber:Hide()
    StanceButton1:ClearAllPoints()
    StanceButton1:SetPoint("cENTER",-6000,0)
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
        BuffFrame:SetPoint("CENTER",PlayerFrame,"CENTER",950,80) 
    end  
    hooksecurefunc("UIParent_UpdateTopFramePositions",Movebuff) 
    Movebuff()
    ObjectiveTrackerFrame:Hide()
    ObjectiveTrackerFrame:UnregisterAllEvents()
    ObjectiveTrackerFrame.Show = ObjectiveTrackerFrame.Hide
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