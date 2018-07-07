-- Made by Yuré Vandebruggen (Scarllét-kilrogg EU)

local _, BetterThanBis = ...

_G["BetterThanBis"] = BetterThanBis;

-- Ace Framework stuffies
BetterThanBis = LibStub("AceAddon-3.0"):NewAddon("BetterThanBis", "AceConsole-3.0", "AceEvent-3.0");
local AceGUI = LibStub("AceGUI-3.0");
local icon = LibStub("LibDBIcon-1.0");
local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("BetterThanBis", {
	type = "data source",
	text = "Btter Than Bis",
	icon = "Interface\\Icons\\INV_Drink_05",
    OnClick = function(button,buttonPressed)
        if buttonPressed == "RightButton" then
			if BetterThanBis.db.minimap.lock then
				icon:Unlock("BetterThanBis")
			else
				icon:Lock("BetterThanBis")
			end
        else
            BetterThanBis:ToggleVisible();
        end
	end,
	OnTooltipShow = function(tooltip)
		if not tooltip or not tooltip.AddLine then return end
        tooltip:AddLine("Better Than Bis");
		tooltip:AddLine("|cffcc8859Click |cff1eff36to toggle the addon window");
		tooltip:AddLine("|cffcc8859Right-Click |cff1eff36to lock the minimap icon");
	end,
})

------------------------------------------------------------------------------------------------
--
-- Data used in the addon
--
------------------------------------------------------------------------------------------------

local sizeX = 800;
local sizeY = 500;

local selectedGearset;

--Think about the table
local Defaults = {
    global = {
        minimap = {
            hide = false,
        },
        optionspanel = {
            hide = true,
        },
        playermodel = {
            hide = true,
        },
    },
    char = {
        gearsets = {},
        stats = {},
    },
}

------------------------------------------------------------------------------------------------
--
-- UI of the addon
--
------------------------------------------------------------------------------------------------

function InitFrames()

    local AddonWindow = CreateFrame("frame", "BetterThanBisFrame", UIParent);
    AddonWindow:SetFrameStrata("HIGH");
    AddonWindow:SetFrameLevel(1);
    AddonWindow.background = AddonWindow:CreateTexture(nil, "BACKGROUND");
    AddonWindow.background:SetAllPoints();
    AddonWindow.background:SetDrawLayer("ARTWORK", 1);
    AddonWindow.background:SetColorTexture(0, 0, 0, 1);
    AddonWindow.background:SetAlpha(0.6);
    AddonWindow:SetSize(sizeX,sizeY);
    BetterThanBis.AddonWindow = AddonWindow;
    AddonWindow:Hide();

    tinsert(UISpecialFrames,"BetterThanBisFrame")
	-- Set frame position
    AddonWindow:ClearAllPoints();
    AddonWindow:SetPoint("CENTER", UIParent,"CENTER", 0, 0)
    
    BetterThanBis:TopPanel(AddonWindow);
    BetterThanBis:OptionsPanel(AddonWindow);
    BetterThanBis:PlayerModel(AddonWindow);
    BetterThanBis:MainFrame(AddonWindow);
    BetterThanBis:AddGearsetPopup(AddonWindow);
end

function BetterThanBis:TopPanel(frame)

    -- Create the Top Panel
    frame.TopPanel = CreateFrame("Frame", "TopPanel", frame);
    frame.TopPanel:SetWidth(sizeX);
    frame.TopPanel:SetHeight(25);
    frame.TopPanel:EnableMouse(true);
    frame.TopPanel:ClearAllPoints();
    frame.TopPanel:SetPoint("TOP", frame, "TOP", 0, 0);
    frame.TopPanel:RegisterForDrag("LeftButton")
    frame.TopPanel:SetScript("OnDragStart", function()
        frame:SetMovable(true)
        frame:StartMoving();
    end)
    frame.TopPanel:SetScript("OnDragStop", function()
        frame:StopMovingOrSizing();
        frame:SetMovable(false)
    end)

    -- Title of the addon
    frame.TopPanel.Title = CreateFrame("Frame", "Title", frame.TopPanel);
    frame.TopPanel.Title:ClearAllPoints();
    frame.TopPanel.Title:SetPoint("TOP", frame.TopPanel, "TOP", 0, 0);
    frame.TopPanel.Title:SetSize(sizeX, frame.TopPanel:GetHeight());
    frame.TopPanel.Title.text = frame.TopPanel:CreateFontString();
    frame.TopPanel.Title.text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE");
    frame.TopPanel.Title.text:SetText("Better Than Bis");
    frame.TopPanel.Title.text:ClearAllPoints();
    frame.TopPanel.Title.text:SetPoint("CENTER", frame.TopPanel.Title, "CENTER", 0, 0);

    -- Close Button
    frame.TopPanel.closeButton = CreateFrame("Button", "CloseButton", frame.TopPanel, "UIPanelCloseButton");
	frame.TopPanel.closeButton:ClearAllPoints();
	frame.TopPanel.closeButton:SetPoint("TOPRIGHT", frame.TopPanel, "TOPRIGHT", 5, 5);
    frame.TopPanel.closeButton:SetScript("OnClick", function() BetterThanBis.ToggleVisible(); end);

    -- OPtions panel Check Box
    frame.TopPanel.ShowOptionsPanel = CreateFrame("CheckButton", "OPtionsPanelCheckBox", frame.TopPanel, "ChatConfigCheckButtonTemplate");
    frame.TopPanel.ShowOptionsPanel:ClearAllPoints();
    frame.TopPanel.ShowOptionsPanel:SetPoint("TOPRIGHT", frame.TopPanel, "TOPRIGHT", -20,1);
    frame.TopPanel.ShowOptionsPanel.tooltip = "Show options";
    frame.TopPanel.ShowOptionsPanel:SetChecked(not BetterThanBis.db.optionspanel.hide);
    frame.TopPanel.ShowOptionsPanel:SetScript("OnClick", function()
        if BetterThanBis.db.optionspanel.hide then
            frame.SidePanel:Show();
            BetterThanBis.db.optionspanel.hide = false;
        else
            frame.SidePanel:Hide();
            BetterThanBis.db.optionspanel.hide = true;
        end
    end);

    frame.TopPanel.InfoButton = CreateFrame("Button", "InfoButton", frame.TopPanel, "UIPanelInfoButton");
    frame.TopPanel.InfoButton:ClearAllPoints();
    frame.TopPanel.InfoButton:SetPoint("LEFT", frame.TopPanel, "LEFT", 5, 0);
end

function BetterThanBis:OptionsPanel(frame)

    -- Options panel frame
    frame.SidePanel = CreateFrame("Frame", "SidePanel", frame);
    frame.SidePanel:ClearAllPoints();
    frame.SidePanel:SetPoint("LEFT", frame, "RIGHT", 0, 0);
    frame.SidePanel:SetWidth(200);
    frame.SidePanel:SetHeight(sizeY);
    frame.SidePanel.background = frame.SidePanel:CreateTexture(nil, "BACKGROUND");
	frame.SidePanel.background:SetAllPoints();
	frame.SidePanel.background:SetDrawLayer("ARTWORK", 1);
	frame.SidePanel.background:SetColorTexture(0.2, 0.2, 0.2, 1);

    -- Options panel Title
    frame.SidePanel.Heading = CreateFrame("Frame", "OptionsPanelHeading", frame.SidePanel);
    frame.SidePanel.Heading:SetSize(frame.SidePanel:GetWidth(), 25)
    frame.SidePanel.Heading:ClearAllPoints();
    frame.SidePanel.Heading:SetPoint("TOP", frame.SidePanel, "TOP", 0, 0)
    frame.SidePanel.Heading.text = frame.SidePanel.Heading:CreateFontString();
    frame.SidePanel.Heading.text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE");
    frame.SidePanel.Heading.text:SetText("Options");
    frame.SidePanel.Heading.text:ClearAllPoints();
    frame.SidePanel.Heading.text:SetPoint("CENTER", frame.SidePanel.Heading, "CENTER", 0, 0);

    -- The actual addon options
    frame.SidePanel.Options = CreateFrame("Frame", "OptionsPanel", frame.SidePanel);
    frame.SidePanel.Options:SetSize(frame.SidePanel:GetWidth(), sizeY-frame.SidePanel.Heading:GetHeight())
    frame.SidePanel.Options:ClearAllPoints();
    frame.SidePanel.Options:SetPoint("TOPRIGHT", frame.SidePanel, "TOPRIGHT", 0, -25);

    frame.SidePanel.Options.ShowMinimapIcon = CreateFrame("CheckButton", "ShowMinimapCheckButton", frame.SidePanel.Options, "ChatConfigCheckButtonTemplate");
    frame.SidePanel.Options.ShowMinimapIcon:ClearAllPoints();
    frame.SidePanel.Options.ShowMinimapIcon:SetPoint("TOPLEFT", frame.SidePanel.Options, "TOPLEFT", 6, -3);
    frame.SidePanel.Options.ShowMinimapIcon:SetText("Show minimap icon");
    frame.SidePanel.Options.ShowMinimapIcon:SetChecked(not BetterThanBis.db.minimap.hide);
    frame.SidePanel.Options.ShowMinimapIcon.text = frame.SidePanel.Options.ShowMinimapIcon:CreateFontString();
    frame.SidePanel.Options.ShowMinimapIcon.text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
    frame.SidePanel.Options.ShowMinimapIcon.text:SetText("Show minimap");
    frame.SidePanel.Options.ShowMinimapIcon.text:ClearAllPoints();
    frame.SidePanel.Options.ShowMinimapIcon.text:SetPoint("LEFT", frame.SidePanel.Options.ShowMinimapIcon, "RIGHT", 0, 0);
    frame.SidePanel.Options.ShowMinimapIcon:SetScript("OnClick", function()
        if BetterThanBis.db.minimap.hide then
            icon:Show("BetterThanBis")
            BetterThanBis.db.minimap.hide = false;
        else
            icon:Hide("BetterThanBis")
            BetterThanBis.db.minimap.hide = true;
        end
    end)
    frame.SidePanel.Options.ShowMinimapIcon:Show();

    frame.SidePanel.Options.ShowPlayerModel = CreateFrame("CheckButton", "ShowPlayerModelCheckButton", frame.SidePanel.Options, "ChatConfigCheckButtonTemplate");
    frame.SidePanel.Options.ShowPlayerModel:ClearAllPoints();
    frame.SidePanel.Options.ShowPlayerModel:SetPoint("TOP", frame.SidePanel.Options.ShowMinimapIcon, "BOTTOM", 0, -3);
    frame.SidePanel.Options.ShowPlayerModel:SetText("Show player model");
    frame.SidePanel.Options.ShowPlayerModel:SetChecked(not BetterThanBis.db.playermodel.hide);
    frame.SidePanel.Options.ShowPlayerModel.text = frame.SidePanel.Options.ShowPlayerModel:CreateFontString();
    frame.SidePanel.Options.ShowPlayerModel.text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
    frame.SidePanel.Options.ShowPlayerModel.text:SetText("Show player model");
    frame.SidePanel.Options.ShowPlayerModel.text:ClearAllPoints();
    frame.SidePanel.Options.ShowPlayerModel.text:SetPoint("LEFT", frame.SidePanel.Options.ShowPlayerModel, "RIGHT", 0, 0);
    frame.SidePanel.Options.ShowPlayerModel:SetScript("OnClick", function()
        if BetterThanBis.db.playermodel.hide then
            frame.PlayerModel:Show()
            BetterThanBis.db.playermodel.hide = false;
        else
            frame.PlayerModel:Hide()
            BetterThanBis.db.playermodel.hide = true;
        end
    end)

    if BetterThanBis.db.optionspanel.hide then
        frame.SidePanel:Hide();
    end
end

function BetterThanBis:PlayerModel(frame)
    local _, race = UnitRace("player")
    local _,_,classIndex = UnitClass("player")

    frame.PlayerModel = CreateFrame("Frame", "PlayerCharacterModelFrame", frame);
    frame.PlayerModel:ClearAllPoints();
    frame.PlayerModel:SetPoint("RIGHT", frame, "LEFT", 0, 0);
    frame.PlayerModel:SetSize(250, sizeY);
    frame.PlayerModel:EnableMouse(true);
    frame.PlayerModel.background = frame.PlayerModel:CreateTexture(nil, "BACKGROUND");
    -- Set the correct scaling for the model;
    frame.PlayerModel.background:SetAtlas("dressingroom-background-"..classIndex);

    -- Create the top background
    frame.PlayerModel.BGTop = frame.PlayerModel:CreateTexture(nil, "BACKGROUND");
    frame.PlayerModel.BGTop:SetSize(250, 400)
    frame.PlayerModel.BGTop:SetPoint("TOPLEFT", frame.PlayerModel, "TOPLEFT", 0, 0);
    frame.PlayerModel.BGTop:SetTexCoord(0, 0.61, 0, 1.0);
    frame.PlayerModel.BGTop:SetTexture("Interface\\DressUpFrame\\DressUpBackground-"..race.."1");

    -- Create the bottom background
    frame.PlayerModel.BGBottom = frame.PlayerModel:CreateTexture(nil, "BACKGROUND");
    frame.PlayerModel.BGBottom:SetSize(250, 100)
    frame.PlayerModel.BGBottom:SetPoint("TOPLEFT", frame.PlayerModel.BGTop, "BOTTOMLEFT", 0, 0);
    frame.PlayerModel.BGBottom:SetTexCoord(0, 0.61, 0, 0.588);
    frame.PlayerModel.BGBottom:SetTexture("Interface\\DressUpFrame\\DressUpBackground-"..race.."3");

    -- The Player Model
    frame.PlayerModel.Model = CreateFrame("DressUpModel", "PLayerCharacterModel", frame.PlayerModel);
    frame.PlayerModel.Model:SetAllPoints();
    frame.PlayerModel.Model:SetUnit("Player");
    frame.PlayerModel.Model:SetPosition(0.35,0.05,0);

    if BetterThanBis.db.playermodel.hide then
        frame.PlayerModel:Hide();
    else
        frame.PlayerModel:Show();
    end
end

function BetterThanBis:MainFrame(frame)

    frame.MainFrame = CreateFrame("Frame", "AddonMainFrame", frame);
    frame.MainFrame:SetSize(frame:GetWidth(), frame:GetHeight()-frame.TopPanel:GetHeight());
    frame.MainFrame:ClearAllPoints();
    frame.MainFrame:SetPoint("TOP", frame, "TOP", 0, -frame.TopPanel:GetHeight());

    frame.MainFrame.background = frame.MainFrame:CreateTexture(nil, "BACKGROUND");
    frame.MainFrame.background:SetAllPoints();
    frame.MainFrame.background:SetDrawLayer("ARTWORK", 1);
    frame.MainFrame.background:SetColorTexture(1, 1, 1, 1);

    BetterThanBis:GearsetFrame(frame.MainFrame);
    BetterThanBis:InfoFrame(frame.MainFrame);

end

function BetterThanBis:GearsetFrame(frame)

    frame.GearFrame = CreateFrame("Frame", "GearSetFrame", frame);
    frame.GearFrame:SetSize(250, frame:GetHeight());
    frame.GearFrame:ClearAllPoints();
    frame.GearFrame:SetPoint("LEFT", frame, "LEFT", 0, 0);
    frame.GearFrame:SetBackdrop({bgFile = "Interface/FrameGeneral/UI-Background-Rock", 
                                                      tile = false,});
    frame.GearFrame:SetBackdropColor(1,1,1,1);

    -- Add the gearset selector dropdown frame
    frame.GearFrame.GearSetDropDownFrame = CreateFrame("Frame", "GearSetDropDownFrame", frame.GearFrame, "UIDropDownMenuTemplate");
    frame.GearFrame.GearSetDropDownFrame:SetPoint("TOP", frame.GearFrame, "TOP", 0, 0);

    -- local pointer to the dropdown with much shorter name (easier to handle)
    local dd = frame.GearFrame.GearSetDropDownFrame;

    -- Standard blizzard dropdown (hope this works)
    UIDropDownMenu_SetWidth(dd, frame.GearFrame:GetWidth()*0.6);
    UIDropDownMenu_SetText(dd, "Select Gearset");
    UIDropDownMenu_JustifyText(dd, "LEFT");
    UIDropDownMenu_SetAnchor(dd, 0, 5, "TOP", dd, "BOTTOM");

    -- Initialize the dropdown
    BetterThanBis:SetupGearDropdown(dd);

    --------------------------------------------------------
    -- Adding the gear window ------------------------------
    --------------------------------------------------------

    -- pointer to the parent frame
    local f = frame.GearFrame;

    -- Head Frame
    f.head = CreateFrame("Button", "HeadFrame", f); --UIPanelLargeSilverButton
    f.head:ClearAllPoints();
    f.head:SetPoint("TOPLEFT", f, "TOPLEFT", 5, -30);
    f.head:SetSize(45, 45);
    f.head.background = f.head:CreateTexture(nil, "BACKGROUND");
    f.head.background:SetAllPoints();
    f.head.background:SetTexture("Interface\\Icons\\inv_misc_desecrated_platehelm");
    f.head.background:SetDesaturated(1)

    f.head = CreateFrame("Frame", "TestFrame", f); --UIPanelLargeSilverButton
    f.head:ClearAllPoints();
    f.head:SetPoint("TOPLEFT", f, "TOPLEFT", 5, -80);
    f.head:SetSize(45, 45);
end

function BetterThanBis:SetupGearDropdown(dd)

    UIDropDownMenu_Initialize(dd, function(self, level, menuList)
    
        --TODO: Sort the gearset table first for consistent display

        for key,value in pairs(BetterThanBis.char.gearsets) do

            local info = UIDropDownMenu_CreateInfo();
            if string.len(tostring(key)) > 35 then
                info.text = tostring(key):sub(1, 35).."...";
            else
                info.text = key;
            end
            info.icon = value.icon;
            info.tCoordLeft = 1;
            info.tCoordTop = 0;
            info.tCoordRight = 0;
            info.tCoordBottom = 1;
            info.minWidth = dd:GetWidth()*0.8;
            info.justifyH = "LEFT"
            info.notCheckable = true;
            info.isNotRadio = true;
            info.arg1 = key;
            info.func = function(value)
                selectedGearset = BetterThanBis.char.gearsets[value.arg1];
                UIDropDownMenu_SetText(dd, value.arg1);
            end
            UIDropDownMenu_AddButton(info);

        end

        local addGearsetButton = UIDropDownMenu_CreateInfo();
        addGearsetButton.text = "|cff00ff00<Add New Gearset>";
        addGearsetButton.justifyH = "CENTER";
        addGearsetButton.notCheckable = true;
        addGearsetButton.isNotRadio = true;
        addGearsetButton.func = function()
            BetterThanBis.AddonWindow.AddGearsetPopup:Show();
        end
        UIDropDownMenu_AddButton(addGearsetButton);
    end);

end

-- Create the add gearset popup frame
function BetterThanBis:AddGearsetPopup(frame)

    frame.AddGearsetPopup = CreateFrame("Frame", "AddGearsetPopup", frame);
    frame.AddGearsetPopup:SetSize(300, 120);
    frame.AddGearsetPopup:ClearAllPoints();
    frame.AddGearsetPopup:SetPoint("CENTER", frame, "CENTER", 0, 0);
    frame.AddGearsetPopup:SetFrameStrata("DIALOG");
    frame.AddGearsetPopup:Hide();
    frame.AddGearsetPopup:SetBackdrop({bgFile = "Interface/Buttons/WHITE8X8", 
                                       tile = false,
                                       edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
                                       insets = {left = 4, top = 4, right = 4, bottom = 4}});
    frame.AddGearsetPopup:SetBackdropColor(0,0,0,0.7)
    
    frame.AddGearsetPopup.Title = frame.AddGearsetPopup:CreateFontString();
    frame.AddGearsetPopup.Title:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE");
    frame.AddGearsetPopup.Title:SetText("Gearset Name:");
    frame.AddGearsetPopup.Title:ClearAllPoints();
    frame.AddGearsetPopup.Title:SetPoint("TOP", frame.AddGearsetPopup, "TOP", 0, -25);
    

    frame.AddGearsetPopup.editbox = CreateFrame("EditBox", "GearsetNameEditbox", frame.AddGearsetPopup, "InputBoxTemplate");
    frame.AddGearsetPopup.editbox:ClearAllPoints();
    frame.AddGearsetPopup.editbox:SetPoint("BOTTOM", frame.AddGearsetPopup, "CENTER", 0, -8)
    frame.AddGearsetPopup.editbox:SetWidth(frame.AddGearsetPopup:GetWidth()*0.7);
    frame.AddGearsetPopup.editbox:SetHeight(25)
    frame.AddGearsetPopup.editbox:SetScript("OnTextChanged", function()
        if string.len(frame.AddGearsetPopup.editbox:GetText()) > 0 then
            frame.AddGearsetPopup.okayButton:Enable();
        else
            frame.AddGearsetPopup.okayButton:Disable();
        end
    end);

    frame.AddGearsetPopup.okayButton = CreateFrame("Button", "AddgearsetOkayButton", frame.AddGearsetPopup, "UIPanelButtonTemplate");
    frame.AddGearsetPopup.okayButton:ClearAllPoints();
    frame.AddGearsetPopup.okayButton:SetPoint("TOPRIGHT", frame.AddGearsetPopup, "CENTER", 0, -10);
    frame.AddGearsetPopup.okayButton:SetText("Okay");
    frame.AddGearsetPopup.okayButton:Disable()
    frame.AddGearsetPopup.okayButton:SetWidth(frame.AddGearsetPopup:GetWidth()*0.4);
    frame.AddGearsetPopup.okayButton:SetScript("OnClick", function() 

        -- Save the gearset to the database
        local gearsetName = frame.AddGearsetPopup.editbox:GetText();
        -- TODO: make a function that generates a gearset object to save
        -- Adds the item to the database
        BetterThanBis.char.gearsets[gearsetName] = {};

        -- Adds the item to show in the dropdown
        BetterThanBis:SetupGearDropdown(frame.MainFrame.GearFrame.GearSetDropDownFrame);

        frame.AddGearsetPopup:Hide();
    end)

    frame.AddGearsetPopup.cancelButton = CreateFrame("Button", "AddgearsetCancelButton", frame.AddGearsetPopup, "UIPanelButtonTemplate");
    frame.AddGearsetPopup.cancelButton:ClearAllPoints();
    frame.AddGearsetPopup.cancelButton:SetPoint("TOPLEFT", frame.AddGearsetPopup, "CENTER", 0, -10)
    frame.AddGearsetPopup.cancelButton:SetText("Cancel");
    frame.AddGearsetPopup.cancelButton:SetWidth(frame.AddGearsetPopup:GetWidth()*0.4)
    frame.AddGearsetPopup.cancelButton:SetScript("OnClick", function()
        frame.AddGearsetPopup:Hide();
    end)

end

function BetterThanBis:InfoFrame(frame)

    frame.InfoFrame = CreateFrame("Frame", "GearSetFrame", frame);
    frame.InfoFrame:SetSize(550, frame:GetHeight());
    frame.InfoFrame:ClearAllPoints();
    frame.InfoFrame:SetPoint("RIGHT", frame, "RIGHT", 0, 0);

    frame.InfoFrame:SetBackdrop({bgFile = "Interface/AchievementFrame/UI-Achievement-Parchment-Horizontal", 
                                                      tile = false,});
    frame.InfoFrame:SetBackdropColor(1,1,1,1);

end

-----------------------------------------------------------------------------------------------
--
-- Functions used in/by the addon
--
-----------------------------------------------------------------------------------------------

function BetterThanBis:OnInitialize()
    -- Initialize a new database
    self.db = LibStub("AceDB-3.0"):New("BTBDB", Defaults).global;
    self.char = LibStub("AceDB-3.0"):New("BTBDB", Defaults).char;

    -- Register the chatcommands
    self:RegisterChatCommand("betterthanbis", "ChatCommand")
    self:RegisterChatCommand("btb", "ChatCommand")

    -- Register for events
    self:RegisterEvents()

    InitFrames()
    icon:Register("BetterThanBis", LDB, self.db.minimap)
end

-- Handles the chat commands
function BetterThanBis:ChatCommand(input)
    if not input or input:trim() == "" then
        self.ToggleVisible()
    end
end

function BetterThanBis:ToggleVisible() 
    if BetterThanBis.AddonWindow:IsShown() then
        BetterThanBis.AddonWindow:Hide();
        BetterThanBis.AddonWindow.AddGearsetPopup:Hide();
    else
        BetterThanBis.AddonWindow:Show();
        if not BetterThanBis.db.optionspanel.hide then
            BetterThanBis.AddonWindow.SidePanel:Show();
        end
    end
end

function BetterThanBis:RegisterEvents()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", function()
        BetterThanBis:GetCharacterBaseStats();
    end)
end

function BetterThanBis:GetCharacterBaseStats()
    -- Get the players name
    local playerName = UnitName("player");

    -- Get Base Main Stats
    local strBase, strStat = UnitStat("player", 1);
    local agiBase, agiStat = UnitStat("player", 2);
    local stamBase, stamStat = UnitStat("player", 3);
    local intBase, intStat = UnitStat("player", 4);

    -- Get Secondary Stats


    -- Add Stats to database
    self.char.stats["Strength"] = strBase;
    self.char.stats["Agility"] = agiBase;
    self.char.stats["Stamina"] = stamBase;
    self.char.stats["Intellect"] = intBase;

end