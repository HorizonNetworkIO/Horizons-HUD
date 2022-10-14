local sw = function (x) return (ScrW() * x)/1920 end
local sh = function (x) return (ScrH() * x)/1080 end

local boxW = sw(400)
local boxH = sh(35)
local boxX = sw(10)
local boxY = ScrH() - boxH - sh(90)

local classic = HZNHud:CreateModule()
classic:SaveSub("Classic Lockdown", true)


local startTextPos = boxX + sw(40)
local endTextPos = boxX + boxW - sw(170)
local textPos = startTextPos
local startTime = 0
local destination = endTextPos

local clearFunc = function()
    hook.Remove("HUDPaint", "HZNHud:SubModule:ClassicLockdown")
end

local drawFunc = function()
    hook.Add("HUDPaint", "HZNHud:SubModule:ClassicLockdown", function()
        if (!GetGlobalBool("DarkRP_LockDown")) then return end

        if (startTime == 0) then 
            startTime = SysTime()
        end
        draw.RoundedBox(4, boxX, boxY, boxW, boxH, HZNHud:GetColor(2))

        HZNHud.CityLockTextPosLerp = Lerp((SysTime() - startTime) * 0.3, textPos, destination)
        if (HZNHud.CityLockTextPosLerp) then            
            if (HZNHud.CityLockTextPosLerp == endTextPos) then
                startTime = 0
                destination = startTextPos
                textPos = endTextPos
            elseif (HZNHud.CityLockTextPosLerp == startTextPos) then
                startTime = 0
                destination = endTextPos
                textPos = startTextPos
            end
        end



        draw.SimpleText("City Lockdown!", "HZN:Bold@25", HZNHud.CityLockTextPosLerp, boxY + (boxH/2), HZNHud:GetColor(5), TEXT_ALIGN_LEFT, 1)

        surface.SetDrawColor(HZNHud:GetColor(3))
        surface.SetMaterial(HZNHud.Materials.Lock)
        surface.DrawTexturedRect(boxX + sw(10), boxY + (boxH/2) - sh(10), sh(20), sh(20))
        surface.DrawTexturedRect(boxX + boxW - sw(30), boxY + (boxH/2) - sh(10), sh(20), sh(20))
    end)
end

classic:SetDrawFunction(drawFunc)
classic:SetClearFunction(clearFunc)