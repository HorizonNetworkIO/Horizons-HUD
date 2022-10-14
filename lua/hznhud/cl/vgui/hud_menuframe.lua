local PANEL = {}

local sw, sh = HZNHud.SW, HZNHud.SH
local navbar_height = sh(50)

local function drawColorsTab(frame)
    frame.colormenu = vgui.Create("DScrollPanel", frame.scrollPnl)
    frame.colormenu:SetTall(sh(500))
    frame.colormenu:Dock(TOP)
    frame.colormenu:DockMargin(0, 0, 0, 0)
    local vbar = frame.colormenu:GetVBar()
    vbar:SetWide(0)

    local colorInfo = vgui.Create("DLL.Label", frame.colormenu)
    colorInfo:SetText("Colors")
    colorInfo:SetFont("HZN:Bold@30")
    colorInfo:SetTextColor(Color(255, 255, 255))
    colorInfo:DockMargin(0, sh(5), 0, sh(30))
    colorInfo:Dock(TOP)
    colorInfo:SetTextAlign(1)

    local cfg = HZNHud:GetConfig()

    for k,v in ipairs(cfg.colors) do
        local colorPnl = vgui.Create("DPanel", frame)
        colorPnl:SetTall(sw(150))
        colorPnl:DockMargin(0, 0, 0, sh(20))
        colorPnl:Dock(TOP)
        colorPnl.Paint = function(self, w, h)
            DLL.DrawSimpleText("Color: " .. k, "HZN:Bold@20", sw(10), sh(10), DLL.Colors.PrimaryText, 3, 1)
        end

        local color = vgui.Create("DLL.ColorPicker", colorPnl)
        color:SetWide(sw(200))
        color:Dock(RIGHT)
        color:SetColor(v)

        local saveBtn = vgui.Create("DLL.Button", colorPnl)
        saveBtn:SetText("Save")
        saveBtn:SetSize(sw(50), sh(25))
        saveBtn:SetPos(sw(10), sh(30))
        saveBtn.DoClick = function()
            local cfg = HZNHud:GetConfig()
            cfg.colors[k] = color:GetColor()
            cfg:Save()
            cfg:Load()
        end
        saveBtn.PaintExtra = function(s, w, h)
            DLL.DrawSimpleText("Save", "HZN:Bold@20", w / 2, h / 2, DLL.Colors.PrimaryText, 1, 1)
        end

        local resetBtn = vgui.Create("DLL.Button", colorPnl)
        resetBtn:SetText("Reset")
        resetBtn:SetSize(sw(50), sh(25))
        resetBtn:SetPos(sw(10), sh(60))
        resetBtn.DoClick = function()
            local cfg = HZNHud:GetConfig()
            cfg.colors[k] = HZNHud.Colors[k]
            cfg:Save()
            cfg:Load()
            color:SetColor(cfg.colors[k])
        end
        resetBtn.PaintExtra = function(s, w, h)
            DLL.DrawSimpleText("Reset", "HZN:Bold@20", w / 2, h / 2, DLL.Colors.PrimaryText, 1, 1)
        end

        frame.colormenu:AddItem(colorPnl)
    end

    frame.scrollPnl:AddItem(frame.colormenu)
end

local function drawModulesTab(frame)
    local cfg = HZNHud:GetConfig()
    frame.modulesmenu = vgui.Create("DScrollPanel", frame.scrollPnl)
    frame.modulesmenu:SetTall(sh(90 * table.Count(cfg.modules)))
    frame.modulesmenu:Dock(TOP)
    frame.modulesmenu:DockMargin(0, 0, 0, sh(20))
    local vbar = frame.modulesmenu:GetVBar()
    vbar:SetWide(0)

    local moduleInfo = vgui.Create("DLL.Label", frame.modulesmenu)
    moduleInfo:SetText("Modules")
    moduleInfo:SetFont("HZN:Bold@30")
    moduleInfo:SetTextColor(Color(255, 255, 255))
    moduleInfo:DockMargin(0, sh(5), 0, sh(10))
    moduleInfo:Dock(TOP)
    moduleInfo:SetTextAlign(1)


    for k,v in pairs(cfg.modules) do
        local modulePnl = vgui.Create("DPanel", frame)
        modulePnl:SetTall(sh(50))
        modulePnl:SetWide(frame:GetWide())
        modulePnl:DockMargin(0, 0, 0, sh(15))
        modulePnl:Dock(TOP)
        modulePnl.Paint = function(s, w, h) end

        moduleLbl = vgui.Create("DLL.Label", modulePnl)
        moduleLbl:SetText(k)
        moduleLbl:SetFont("HZN:Bold@20")
        moduleLbl:SetTextColor(Color(255, 255, 255))
        moduleLbl:DockMargin(sw(10), sh(14), 0, 0)
        moduleLbl:Dock(LEFT)
        moduleLbl:SetWide(sw(200))

        local Module = vgui.Create("DLL.LabelledCheckbox", modulePnl)
        Module:SetText("")
        Module.Checkbox:SetToggle(v)
        Module:DockMargin(0, 0, sw(10), 0)
        Module:SetWide(sw(40))
        Module:SetPos(modulePnl:GetWide() - Module:GetWide() - sw(10), modulePnl:GetTall()/2 - Module:GetTall()/2)

        Module.Checkbox.OnToggled = function(s, b)
            local cfg = HZNHud:GetConfig()
            cfg.modules[k] = b
            cfg:Save()
            cfg:Load()
        end

        frame.modulesmenu:AddItem(modulePnl)
    end
    
    frame.scrollPnl:AddItem(frame.modulesmenu)
end

local function drawSubModulesTab(frame)
    local cfg = HZNHud:GetConfig()
    frame.submodulesmenu = vgui.Create("DLL.ScrollPanel", frame.scrollPnl)
    frame.submodulesmenu:SetTall(sh(75 * table.Count(cfg.submodules)))
    frame.submodulesmenu:Dock(TOP)
    frame.submodulesmenu:DockMargin(0, 0, 0, sh(20))
    local vbar = frame.submodulesmenu:GetVBar()
    vbar:SetWide(0)

    local submoduleInfo = vgui.Create("DLL.Label", frame.submodulesmenu)
    submoduleInfo:SetText("Sub-Modules")
    submoduleInfo:SetFont("HZN:Bold@30")
    submoduleInfo:SetTextColor(Color(255, 255, 255))
    submoduleInfo:DockMargin(0, sh(5), 0, sh(10))
    submoduleInfo:Dock(TOP)
    submoduleInfo:SetTextAlign(1)

    for k,v in pairs(cfg.submodules) do
        local submodulePnl = vgui.Create("DPanel", frame)
        submodulePnl:SetTall(sh(50))
        submodulePnl:SetWide(frame:GetWide())
        submodulePnl:DockMargin(0, 0, 0, sh(15))
        submodulePnl:Dock(TOP)
        submodulePnl.Paint = function(s, w, h) end

        submoduleLbl = vgui.Create("DLL.Label", submodulePnl)
        submoduleLbl:SetText(k)
        submoduleLbl:SetFont("HZN:Bold@20")
        submoduleLbl:SetTextColor(Color(255, 255, 255))
        submoduleLbl:DockMargin(sw(10), 0, 0, 0)
        submoduleLbl:Dock(LEFT)
        submoduleLbl:SetWide(sw(200))

        local subModule = vgui.Create("DLL.LabelledCheckbox", submodulePnl)
        subModule:SetText("")
        subModule.Checkbox:SetToggle(v)
        subModule:DockMargin(0, 0, sw(10), 0)
        subModule:SetWide(sw(40))
        subModule:SetPos(submodulePnl:GetWide() - subModule:GetWide() - sw(10), submodulePnl:GetTall()/2 - subModule:GetTall()/2)

        subModule.Checkbox.OnToggled = function(s, b)
            local cfg = HZNHud:GetConfig()
            cfg.submodules[k] = b
            cfg:Save()
            cfg:Load()
        end

        frame.submodulesmenu:AddItem(submodulePnl)
    end
    
    frame.scrollPnl:AddItem(frame.submodulesmenu)
end

function HZNHud:OpenConfigMenu()
    if (HZNHud.Menu) then
        HZNHud.Menu:Remove()
    end

    local frame = vgui.Create("DLL.Frame")
    frame:SetTitle("HUD Config")
    frame:SetSize(sw(450), sh(500))
    frame:Center()
    frame:MakePopup()
    frame:Open()

    frame.scrollPnl = vgui.Create("DLL.ScrollPanel", frame)
    frame.scrollPnl:DockMargin(0, sh(10), 0, sh(20))
    frame.scrollPnl:Dock(FILL)
    local vbar = frame.scrollPnl:GetVBar()
    vbar:SetWide(0)

    drawColorsTab(frame)
    drawModulesTab(frame)
    drawSubModulesTab(frame)

    HZNHud.Menu = frame
end

concommand.Add("hznhud_menu", function()
    HZNHud:OpenConfigMenu()
end)