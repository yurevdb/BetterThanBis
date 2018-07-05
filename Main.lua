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
            frame.SidePanel.WidgetGroup.frame:Show();
            BetterThanBis.db.optionspanel.hide = false;
        else
            frame.SidePanel:Hide();
            frame.SidePanel.WidgetGroup.frame:Hide()
            BetterThanBis.db.optionspanel.hide = true;
        end
    end);
end

function BetterThanBis:OptionsPanel(frame)

    -- Options panel frame
    frame.SidePanel = CreateFrame("Frame", "SidePanel", frame);
    frame.SidePanel:ClearAllPoints();
    frame.SidePanel:SetPoint("LEFT", frame, "RIGHT", 0, 0);
    frame.SidePanel:SetWidth(200);
    frame.SidePanel:SetHeight(sizeY);
    --frame.SidePanel.background = frame.SidePanel:CreateTexture(nil, "BACKGROUND");
	--frame.SidePanel.background:SetAllPoints();
	--frame.SidePanel.background:SetDrawLayer("ARTWORK", -5);
	--frame.SidePanel.background:SetColorTexture(0.2, 0.2, 0.2, 1);
    --frame.SidePanel.background:SetAlpha(1);
    frame.SidePanel:SetBackdrop({bgFile = "Interface/AchievementFrame/UI-GuildAchievement-Parchment-Horizontal", 
                                 tile = false,});
    frame.SidePanel:SetBackdropColor(1,1,1,1);

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

    -- AceGui group
    frame.SidePanel.WidgetGroup = AceGUI:Create("SimpleGroup");
    frame.SidePanel.WidgetGroup:SetWidth(frame.SidePanel:GetWidth()-6);
    frame.SidePanel.WidgetGroup:SetHeight(frame.SidePanel:GetHeight());
    frame.SidePanel.WidgetGroup:SetPoint("TOPRIGHT", frame.SidePanel, "TOPRIGHT", 3, -25);
    frame.SidePanel.WidgetGroup:SetLayout("Flow");
    frame.SidePanel.WidgetGroup.frame:SetFrameStrata("HIGH");
    frame.SidePanel.WidgetGroup.frame:Hide()

    frame.SidePanel.WidgetGroup.ShowMinimapIcon = AceGUI:Create("CheckBox");
    frame.SidePanel.WidgetGroup.ShowMinimapIcon:SetLabel("Show minimap icon");
    if not BetterThanBis.db.minimap.hide then
        frame.SidePanel.WidgetGroup.ShowMinimapIcon:ToggleChecked();
    end
    frame.SidePanel.WidgetGroup.ShowMinimapIcon:SetCallback("OnValueChanged", function()
        if BetterThanBis.db.minimap.hide then
            icon:Show("BetterThanBis")
            BetterThanBis.db.minimap.hide = false;
        else
            icon:Hide("BetterThanBis")
            BetterThanBis.db.minimap.hide = true;
        end
    end)
    frame.SidePanel.WidgetGroup:AddChild(frame.SidePanel.WidgetGroup.ShowMinimapIcon);

    frame.SidePanel.WidgetGroup.ShowPlayerModel = AceGUI:Create("CheckBox");
    frame.SidePanel.WidgetGroup.ShowPlayerModel:SetLabel("Show player model");
    if not BetterThanBis.db.playermodel.hide then
        frame.SidePanel.WidgetGroup.ShowPlayerModel:ToggleChecked();
    end
    frame.SidePanel.WidgetGroup.ShowPlayerModel:SetCallback("OnValueChanged", function()
        if BetterThanBis.db.playermodel.hide then
            frame.PlayerModel:Show()
            BetterThanBis.db.playermodel.hide = false;
        else
            frame.PlayerModel:Hide()
            BetterThanBis.db.playermodel.hide = true;
        end
    end)
    frame.SidePanel.WidgetGroup:AddChild(frame.SidePanel.WidgetGroup.ShowPlayerModel);

    if BetterThanBis.db.optionspanel.hide then
        frame.SidePanel:Hide();
    end
end

function BetterThanBis:PlayerModel(frame)

    frame.PlayerModel = CreateFrame("Frame", "PlayerCharacterModelFrame", frame);
    frame.PlayerModel:ClearAllPoints();
    frame.PlayerModel:SetPoint("RIGHT", frame, "LEFT", 0, 0);
    frame.PlayerModel:SetSize(250, sizeY);
    frame.PlayerModel.Background = frame.PlayerModel:CreateTexture(nil, "BACKGROUND");
    frame.PlayerModel.Background:SetAllPoints();
    frame.PlayerModel.Background:SetDrawLayer("ARTWORK", 1);
    frame.PlayerModel.Background:SetColorTexture(0, 0, 0, 1);
    frame.PlayerModel.Background:SetAlpha(0.6);

    -- The Player Model
    frame.PlayerModel.Model = CreateFrame("DressUpModel", "PLayerCharacterModel", frame.PlayerModel);
    frame.PlayerModel.Model:ClearAllPoints();
    frame.PlayerModel.Model:SetPoint("CENTER", frame.PlayerModel, "CENTER", 0, 0);
    frame.PlayerModel.Model:SetUnit("Player");
    frame.PlayerModel.Model:SetPosition(-110,-0.1,-1.4); 
    -- -110 is to zoom out so you see the entire model
    -- -0.1 is to center the model horizontally
    -- -1.4 is to lower the model vertically

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
    frame.GearFrame.background = frame.GearFrame:CreateTexture(nil, "BACKGROUND");
    frame.GearFrame.background:SetAllPoints();
    frame.GearFrame.background:SetDrawLayer("ARTWORK", 1);
    frame.GearFrame.background:SetColorTexture(1, 0.8, 0.9, 1);

    -- Add the gearset selector dropdown frame
    frame.GearFrame.GearSetDropDownFrame = CreateFrame("Frame", "GearSetDropDownFrame", frame.GearFrame);
    frame.GearFrame.GearSetDropDownFrame:SetSize(frame.GearFrame:GetWidth(), 30);
    frame.GearFrame.GearSetDropDownFrame:ClearAllPoints();
    frame.GearFrame.GearSetDropDownFrame:SetPoint("TOP", frame.GearFrame, "TOP", 0, 0);
    frame.GearFrame.GearSetDropDownFrame.background = frame.GearFrame.GearSetDropDownFrame:CreateTexture(nil, "BACKGROUND");
    frame.GearFrame.GearSetDropDownFrame.background:SetAllPoints();
    frame.GearFrame.GearSetDropDownFrame.background:SetDrawLayer("ARTWORK", 1);
    frame.GearFrame.GearSetDropDownFrame.background:SetColorTexture(1, 1, 1, 1);

    -- Dropdown group to make acegui widgets work
    frame.GearFrame.GearSetDropDownFrame.group = AceGUI:Create("SimpleGroup");
    frame.GearFrame.GearSetDropDownFrame.group:SetWidth(frame.GearFrame.GearSetDropDownFrame:GetWidth()*0.8);
    frame.GearFrame.GearSetDropDownFrame.group:SetHeight(frame.GearFrame.GearSetDropDownFrame:GetHeight());
    frame.GearFrame.GearSetDropDownFrame.group:SetPoint("CENTER", frame.GearFrame.GearSetDropDownFrame, "CENTER", 0, 0);
    frame.GearFrame.GearSetDropDownFrame.group:SetLayout("Fill");
    frame.GearFrame.GearSetDropDownFrame.group.frame:SetFrameStrata("DIALOG");
    frame.GearFrame.GearSetDropDownFrame.group.frame:Hide()

    -- Create the dropdown
    frame.GearFrame.GearSetDropDownFrame.group.dropdown = AceGUI:Create("Dropdown");
    frame.GearFrame.GearSetDropDownFrame.group.dropdown:SetText("Select Gearset");
    frame.GearFrame.GearSetDropDownFrame.group:AddChild(frame.GearFrame.GearSetDropDownFrame.group.dropdown);
    prevKey = "";
    frame.GearFrame.GearSetDropDownFrame.group.dropdown:SetCallback("OnValueChanged", function(key)
        if tostring(key.value) == "Add" then
            if prevKey ~= "" then
                frame.GearFrame.GearSetDropDownFrame.group.dropdown:SetValue(prevKey);
            else
                frame.GearFrame.GearSetDropDownFrame.group.dropdown:SetValue("1");
            end
            BetterThanBis.AddonWindow.AddGearsetPopup:Show();
            BetterThanBis.AddonWindow.AddGearsetPopup.group.frame:Show();
            BetterThanBis.AddonWindow.AddGearsetPopup.group.editbox:SetFocus();
        else
            prevKey = tostring(key.value)
            -- Select the gearset duh!
        end
    end)

    local gearsetList = {};
    local count = 1;
    for i,_ in pairs(BetterThanBis.char.gearsets) do
        gearsetList[tostring(count)] = tostring(i);
        count = count + 1;
    end
    gearsetList["Add"] = "Add Gearset";
    frame.GearFrame.GearSetDropDownFrame.group.dropdown:SetList(gearsetList);

end

-- Create the add gearset popup frame
function BetterThanBis:AddGearsetPopup(frame)

    frame.AddGearsetPopup = CreateFrame("Frame", "AddGearsetPopup", frame);
    frame.AddGearsetPopup:SetSize(300, 120);
    frame.AddGearsetPopup:ClearAllPoints();
    frame.AddGearsetPopup:SetPoint("CENTER", frame, "CENTER", 0, 0);
    frame.AddGearsetPopup:SetFrameStrata("DIALOG");
    frame.AddGearsetPopup:Hide();
    frame.AddGearsetPopup:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
                                       tile = false,
                                       edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
                                       insets = {left = 4, top = 4, right = 4, bottom = 4}});
    frame.AddGearsetPopup:SetBackdropColor(1,1,1,1);

    frame.AddGearsetPopup.group = AceGUI:Create("SimpleGroup");
    frame.AddGearsetPopup.group:SetWidth(frame.AddGearsetPopup:GetWidth()*0.8);
    frame.AddGearsetPopup.group:SetHeight(frame.AddGearsetPopup:GetHeight());
    frame.AddGearsetPopup.group:SetPoint("CENTER", frame.AddGearsetPopup, "CENTER", 0, 0);
    frame.AddGearsetPopup.group:SetLayout("Flow");
    frame.AddGearsetPopup.group.frame:SetFrameStrata("DIALOG");
    frame.AddGearsetPopup.group.frame:Hide();

    frame.AddGearsetPopup.group.editbox = AceGUI:Create("EditBox");
    frame.AddGearsetPopup.group.editbox:SetLabel("Gearset name");
    frame.AddGearsetPopup.group.editbox:DisableButton(true);
    frame.AddGearsetPopup.group.editbox:SetCallback("OnTextChanged", function()
        local hasText = string.len(frame.AddGearsetPopup.group.editbox:GetText()) == 0;
        frame.AddGearsetPopup.group.okayButton:SetDisabled(hasText)
    end)
    frame.AddGearsetPopup.group:AddChild(frame.AddGearsetPopup.group.editbox)

    frame.AddGearsetPopup.group.okayButton = AceGUI:Create("Button");
    frame.AddGearsetPopup.group.okayButton:SetText("Okay");
    frame.AddGearsetPopup.group.okayButton:SetDisabled(true)
    frame.AddGearsetPopup.group.okayButton:SetWidth(frame.AddGearsetPopup.group.frame:GetWidth()*0.5);
    frame.AddGearsetPopup.group.okayButton:SetCallback("OnClick", function() 

        -- Save the gearset to the database
        local gearsetName = frame.AddGearsetPopup.group.editbox:GetText();
        -- TODO: make a function that generates a gearset object to save
        -- Adds the item to the database
        BetterThanBis.char.gearsets[gearsetName] = {};

        -- Adds the item to show in the dropdown
        BetterThanBis.AddonWindow.MainFrame.GearFrame.GearSetDropDownFrame.group.dropdown:AddItem(#BetterThanBis.char.gearsets+1, gearsetName);
        BetterThanBis.AddonWindow.MainFrame.GearFrame.GearSetDropDownFrame.group.dropdown:SetValue(#BetterThanBis.char.gearsets+1)

        frame.AddGearsetPopup:Hide();
        frame.AddGearsetPopup.group.frame:Hide();
    end)
    frame.AddGearsetPopup.group:AddChild(frame.AddGearsetPopup.group.okayButton)

    frame.AddGearsetPopup.group.cancelButton = AceGUI:Create("Button");
    frame.AddGearsetPopup.group.cancelButton:SetText("Cancel");
    frame.AddGearsetPopup.group.cancelButton:SetWidth(frame.AddGearsetPopup.group.frame:GetWidth()*0.5)
    frame.AddGearsetPopup.group.cancelButton:SetCallback("OnClick", function()
        if prevKey ~= "" then
            BetterThanBis.AddonWindow.MainFrame.GearFrame.GearSetDropDownFrame.group.dropdown:SetValue(prevKey)
        else
            BetterThanBis.AddonWindow.MainFrame.GearFrame.GearSetDropDownFrame.group.dropdown:SetValue("1")
        end
        frame.AddGearsetPopup:Hide();
        frame.AddGearsetPopup.group.frame:Hide();
    end)
    frame.AddGearsetPopup.group:AddChild(frame.AddGearsetPopup.group.cancelButton)

end

function BetterThanBis:InfoFrame(frame)

    frame.InfoFrame = CreateFrame("Frame", "GearSetFrame", frame);
    frame.InfoFrame:SetSize(550, frame:GetHeight());
    frame.InfoFrame:ClearAllPoints();
    frame.InfoFrame:SetPoint("RIGHT", frame, "RIGHT", 0, 0);

    frame.InfoFrame.background = frame.InfoFrame:CreateTexture(nil, "BACKGROUND");
    frame.InfoFrame.background:SetAllPoints();
    frame.InfoFrame.background:SetDrawLayer("ARTWORK", 1);
    frame.InfoFrame.background:SetColorTexture(0, 1, 0, 1);

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
        BetterThanBis.AddonWindow.SidePanel.WidgetGroup.frame:Hide();
        BetterThanBis.AddonWindow.MainFrame.GearFrame.GearSetDropDownFrame.group.frame:Hide();
        BetterThanBis.AddonWindow.AddGearsetPopup:Hide();
        BetterThanBis.AddonWindow.AddGearsetPopup.group.frame:Hide();
    else
        BetterThanBis.AddonWindow:Show();
        BetterThanBis.AddonWindow.MainFrame.GearFrame.GearSetDropDownFrame.group.frame:Show();
        if not BetterThanBis.db.optionspanel.hide then
            BetterThanBis.AddonWindow.SidePanel.WidgetGroup.frame:Show();
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