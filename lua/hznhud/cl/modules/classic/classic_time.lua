local sw = function (x) return (ScrW() * x)/1920 end
local sh = function (x) return (ScrH() * x)/1080 end

local boxW = sw(110)
local boxH = sh(35)
local boxX = ScrW() - boxW - sw(10)
local boxY = sh(10)

local classic = HZNHud:CreateModule()
classic:SaveSub("Classic Time", true)

local clearFunc = function()
    hook.Remove("HUDPaint", "HZNHud:SubModule:ClassicTime")
end

local drawFunc = function()
    hook.Add("HUDPaint", "HZNHud:SubModule:ClassicTime", function()
        local time = HZNHud.GetCurrentTime()

        draw.RoundedBox(0, boxX, boxY, boxW, boxH, HZNHud:GetColor(1))
        draw.SimpleText(time, "HZN:Bold@25", boxX + boxW/2, boxY + (boxH/2), HZNHud:GetColor(5), 1, 1)
    end)
end

classic:SetDrawFunction(drawFunc)
classic:SetClearFunction(clearFunc)