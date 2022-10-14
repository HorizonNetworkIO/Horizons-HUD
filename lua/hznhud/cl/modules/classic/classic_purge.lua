local sw = function (x) return (ScrW() * x)/1920 end
local sh = function (x) return (ScrH() * x)/1080 end

local boxX = sw(400) + sw(20)
local boxH = sh(75)

local classic = HZNHud:CreateModule()
classic:SaveSub("Classic Purge", true)

local clearFunc = function()
    hook.Remove("HUDPaint", "HZNHud:SubModule:Purge")
end

local drawFunc = function()
    hook.Add("HUDPaint", "HZNHud:SubModule:Purge", function()
        if (!HZNPurge.IsActive()) then return end

        local timeLeft = HZNPurge.GetTimeLeft()
        local primaryWidth = select(1, surface.GetTextSize(timeLeft))
        local boxW = math.max(primaryWidth, 100) + sw(20)
        local boxY = ScrH() - boxH - sh(10) 

        draw.RoundedBox(4, boxX, boxY, boxW, boxH, HZNHud:GetColor(2))
        draw.TextShadow({
            text = "PURGE",
            font = "HZN:Bold@25",
            pos = {boxX + boxW/2, boxY + (boxH/2) - sh(12)},
            color = HZNHud:GetColor(3),
            xalign = 1,
            yalign = 1
        }, 1, 200)
        draw.SimpleText("PURGE", "HZN:Bold@25", boxX + boxW/2, boxY + (boxH/2) - sh(12), HZNHud:GetColor(3), 1, 1)
        draw.TextShadow({
            text = timeLeft,
            font = "HZN:Default@20",
            pos = {boxX + boxW/2, boxY + (boxH/2) + sh(12)},
            color = HZNHud:GetColor(5),
            xalign = 1,
            yalign = 1
        }, 1.5, 230)
        draw.SimpleText(timeLeft, "HZN:Default@20", boxX + boxW/2, boxY + (boxH/2) + sh(12), HZNHud:GetColor(5), 1, 1)
    end)
end

classic:SetDrawFunction(drawFunc)
classic:SetClearFunction(clearFunc)

drawFunc()