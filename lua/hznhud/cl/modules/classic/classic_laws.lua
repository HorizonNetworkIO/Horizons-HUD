local sw = function (x) return (ScrW() * x)/1920 end
local sh = function (x) return (ScrH() * x)/1080 end

local boxW = sw(110)
local boxH = sh(35)
local boxX = ScrW() - boxW - sw(10)
local boxY = sh(50)

local classic = HZNHud:CreateModule()
classic:Save("Context Laws", true, true)

local lawsTbl = {}
local lawsStr = ""

local clearFunc = function()
    hook.Remove("HUDPaint", "HZNHud:Module:ClassicLaws")
    lawsTbl = {}
    lawsStr = ""
end

local drawFunc = function()
    lawsTbl = DarkRP.getLaws()
    lawsStr = ""

    for k,v in ipairs(lawsTbl) do
        lawsStr = lawsStr .. "\n" .. k .. ". " .. v    
    end

    surface.SetFont("HZN:Default@15")
    local stringWidth, stringHeight = surface.GetTextSize(lawsStr)

    boxW = stringWidth + sw(20)
    boxH = stringHeight + sw(30)
    boxX = ScrW() - boxW - sw(10)

    hook.Add("HUDPaint", "HZNHud:Module:ClassicLaws", function()

        draw.RoundedBox(2, boxX, boxY, boxW, boxH, HZNHud:GetColor(1))
        draw.SimpleText("Laws", "HZN:Bold@25", boxX + boxW/2, boxY + sh(18), HZNHud:GetColor(3), 1, 1)
        draw.DrawText(lawsStr, "HZN:Default@15", boxX + boxW/2, boxY + sh(20), HZNHud:GetColor(5), 1, 1)
    end)
end

classic:SetDrawFunction(drawFunc)
classic:SetClearFunction(clearFunc)
