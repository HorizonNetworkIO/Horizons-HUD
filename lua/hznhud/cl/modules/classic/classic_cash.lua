local sw = function (x) return (ScrW() * x)/1920 end
local sh = function (x) return (ScrH() * x)/1080 end

local boxH = sh(35)
local boxY = sh(10)

local classic = HZNHud:CreateModule()
classic:SaveSub("Classic Cash", true)

local clearFunc = function()
    hook.Remove("HUDPaint", "HZNHud:SubModule:ClassicCash")
end

local drawFunc = function()
    hook.Add("HUDPaint", "HZNHud:SubModule:ClassicCash", function()
        local cash = LocalPlayer():GetHZNCash()
        if (cash) then
            cash = string.Comma(cash)
        else
            cash = "0"
        end
        cash = "¢" .. cash

        local primaryWidth = select(1, surface.GetTextSize(cash))

        local boxX = ScrW() - primaryWidth - sw(20) - sw(10)
        local boxW = primaryWidth + sw(20)

        if (!HZNHud:IsModuleActive("Classic Time")) then
            boxX = boxX - sw(120)
        end

        draw.RoundedBox(0, boxX, boxY, boxW, boxH, HZNHud:GetColor(1))
        draw.SimpleText(cash, "HZN:Bold@25", boxX + boxW/2, boxY + (boxH/2), HZNHud:GetColor(5), 1, 1)
    end)
end

classic:SetDrawFunction(drawFunc)
classic:SetClearFunction(clearFunc)