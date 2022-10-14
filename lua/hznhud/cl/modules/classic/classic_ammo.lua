local sw = function (x) return (ScrW() * x)/1920 end
local sh = function (x) return (ScrH() * x)/1080 end

local boxW = sw(150)
local boxH = sh(40)
local boxX = ScrW() - boxW - sw(10)
local boxY = ScrH() - boxH - sh(10)
local animationSpeed = 5

local classic = HZNHud:CreateModule()
classic:SaveSub("Classic Ammo", true)
local startTime = nil

local clearFunc = function()
    hook.Remove("HUDPaint", "HZNHud:SubModule:ClassicAmmo")
    startTime = nil
end

local drawFunc = function()
    if (startTime == nil) then
        startTime = SysTime()
    end

    hook.Add("HUDPaint", "HZNHud:SubModule:ClassicAmmo", function()
        surface.SetFont("HZN:Bold@30")
        local primaryAmmo = tostring(HZNHud.GetPrimaryAmmo())
        local secondaryAmmo = tostring(HZNHud.GetSecondaryAmmo())

        if (primaryAmmo == "0" and secondaryAmmo == "0") then return end

        local primaryWidth = select(1, surface.GetTextSize(primaryAmmo))
        local secondaryWidth = select(1, surface.GetTextSize(secondaryAmmo))

        local leftBoxX = ScrW() - primaryWidth - secondaryWidth - sw(20) - sw(30)
        local leftBoxW = primaryWidth + sw(20)

        local rightBoxX = ScrW() - secondaryWidth - sw(30)
        local rightBoxW = secondaryWidth + sw(20)

        // lerp the boxX from the right of the screen to it's position with startTime and animation speed
        local lerpedX = Lerp((SysTime() - startTime) * animationSpeed, ScrW() + (leftBoxW + rightBoxW), leftBoxX)
        local lerpedRightX = Lerp((SysTime() - startTime) * animationSpeed, ScrW() + (leftBoxW + rightBoxW), rightBoxX)

        draw.RoundedBox(0, lerpedX, boxY, leftBoxW, boxH, HZNHud:GetColor(1))
        draw.SimpleText(primaryAmmo, "HZN:Bold@30", lerpedX + leftBoxW/2, boxY + (boxH/2) - sw(1), HZNHud:GetColor(3), 1, 1)

        draw.RoundedBox(0, lerpedRightX, boxY, rightBoxW, boxH, HZNHud:GetColor(2))
        draw.SimpleText(secondaryAmmo, "HZN:Bold@30", lerpedRightX + rightBoxW/2, boxY + (boxH/2) - sw(1), HZNHud:GetColor(5), 1, 1)
    end)
end

classic:SetDrawFunction(drawFunc)
classic:SetClearFunction(clearFunc)