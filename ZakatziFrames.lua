local function zf_on_load(self)
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("TOPLEFT",UIParent,"TOPLEFT",458,-420)
    PlayerFrame.SetPoint=function()end
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("TOPLEFT",UIParent,"TOPLEFT",684,-420)
    TargetFrame.SetPoint=function()end
    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()  
    local r={"MultiBarBottomLeft", "MultiBarBottomRight", "Action", "MultiBarLeft", "MultiBarRight"} 
    for b=1,#r do 
        for i=1,12 do 
            _G[r[b].."Button"..i.."Name"]:SetAlpha(0) 
        end 
    end
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