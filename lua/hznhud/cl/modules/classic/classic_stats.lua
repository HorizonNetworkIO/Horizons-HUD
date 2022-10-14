local sw = function (x) return (ScrW() * x)/1920 end
local sh = function (x) return (ScrH() * x)/1080 end

local statW = sw(400)
local statH = sh(75)
local statX = sw(10)
local statY = ScrH() - statH - sh(10)

local classic = HZNHud:CreateModule()
classic:Save("Classic", true)

local clearFunc = function()
    hook.Remove("HUDPaint", "HZNHud:Module:ClassicStat")
    
    if (HZNHud.PlayerAvatar) then
        HZNHud.PlayerAvatar:Remove()
    end
end

local startHp, oldHp, newHp = 0, -1, -1
local startAp, oldAp, newAp = 0, -1, -1
local animationTime = 0.5
local barW = sw(85)
local drawFunc = function()
    hook.Add("HUDPaint", "HZNHud:Module:ClassicStat", function()
        if (!LocalPlayer():HZN_FullySpawned()) then
            return
        end
        surface.SetFont("HZN:Bold@20")
        draw.RoundedBoxEx(4, sw(10), ScrH() - statH - sh(10), statW / 2 * 1.25, statH, HZNHud:GetColor(1), true, false, true, false) -- left bg
        draw.RoundedBoxEx(4, sw(10) + statW / 2 * 1.25, ScrH() - statH - sh(10), statW / 2 * .75, statH, HZNHud:GetColor(2), false, true, false, true) -- right bg

        // left panel
        local name = HZNHud.FormatText(LocalPlayer():Name(), 16)
        local job = (LocalPlayer():getDarkRPVar("job") or "Citizen")
        local money = "$" .. string.Comma((LocalPlayer():getDarkRPVar("money") or 0))
        local moneyWidth = select(1, surface.GetTextSize(money))
        local salary = "$" .. string.Comma((LocalPlayer():getDarkRPVar("salary") or 0))
        draw.SimpleText(name, "HZN:Default@25", statX + sw(69) + sw(10), statY + sw(17), HZNHud:GetColor(5), 3, 1)
        draw.SimpleText(job, "HZN:Default@20", statX + sw(69) + sw(10), statY + sw(37), HZNHud:GetColor(5), 3, 1)
        draw.SimpleText(money, "HZN:Bold@20", statX + sw(69) + sw(10), statY + sw(57), HZNHud:GetColor(5), 3, 1)
        draw.SimpleText("+ " .. salary, "HZN:Default@15", statX + sw(69) + sw(10) + moneyWidth + sw(5), statY + sw(57), HZNHud:GetColor(5), 3, 1)

        // right panel


        local health = LocalPlayer():Health()
        local maxHp = LocalPlayer():GetMaxHealth()
        if (oldHp == -1 and newHp == -1) then
            oldHp = health
            newHp = health
        end
        local smoothHP = Lerp((SysTime() - startHp) / animationTime, oldHp, newHp)

        if (newHp ~= health) then
            if (smoothHP ~= health) then
                newHp = smoothHP
            end

            oldHp = newHp
            startHp = SysTime()
            newHp = health
        end

        local armor = LocalPlayer():Armor()
        local maxAp = LocalPlayer():GetMaxArmor()
        if (oldAp == -1 and newAp == -1) then
            oldAp = armor
            newAp = armor
        end
        local smoothAP = Lerp((SysTime() - startAp) / animationTime, oldAp, newAp)

        if (newAp ~= armor) then
            if (smoothAP ~= armor) then
                newAp = smoothAP
            end

            oldAp = newAp
            startAp = SysTime()
            newAp = armor
        end

        local pnlX = statX + statW / 2 * 1.25
        draw.SimpleText(health .. "%", "HZN:Default@15", pnlX + sw(16), statY + sw(20), HZNHud:GetColor(5), 1, 1)
        draw.SimpleText(armor .. "%", "HZN:Default@15", pnlX + sw(16), statY + statH - sw(25), HZNHud:GetColor(5), 1, 1)

        surface.SetDrawColor(HZNHud:GetColor(3))

        surface.SetMaterial(HZNHud.Materials.Heart)
        surface.DrawTexturedRect(pnlX + sw(34), statY + sh(15), sw(15), sw(15))

        surface.SetMaterial(HZNHud.Materials.Shield)
        surface.DrawTexturedRect(pnlX + sw(33), statY + statH - sh(30), sw(15), sw(15))

        -- bg bar
        draw.RoundedBox(4, pnlX + sw(55), statY + sw(20), barW, sh(6), HZNHud:GetColor(4))
        draw.RoundedBox(4, pnlX + sw(55), statY + sw(20), math.Clamp(math.max( 0, smoothHP ) / maxHp * barW, 0, barW), sh(6), HZNHud:GetColor(3))
        
        -- lerp width
        draw.RoundedBox(4, pnlX + sw(55), statY + statH - sh(26), barW, sh(6), HZNHud:GetColor(4))
        draw.RoundedBox(4, pnlX + sw(55), statY + statH - sw(26), math.Clamp(math.max( 0, smoothAP ) / maxAp * barW, 0, barW), sh(6), HZNHud:GetColor(3))

        HZNHud.previousHealth = LocalPlayer():Health()

        local topStatY = GetGlobalBool("DarkRP_LockDown") and ScrH() - statH - sh(45 + 40) or ScrH() - statH - sh(45)
        local stats = -1

        if (LocalPlayer():GetNWBool("HZN_OnDuty", false)) then
            stats = stats + 1
            draw.RoundedBox(2, sw(10) + (stats * 110), topStatY, sw(100), sh(30), HZNHud:GetColor(2), true, false, true, false) -- left bg
            draw.SimpleText("On Duty", "HZN:Bold@20", sw(10) + (stats * 100) + sw(10 * (5 + stats)), topStatY + sh(14), HZNHud:GetColor(5), 1, 1) 
        end

        if (LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP) then
            stats = stats + 1
            draw.RoundedBox(2, sw(10) + (stats * 110), topStatY, sw(100), sh(30), HZNHud:GetColor(2), true, false, true, false) -- left bg
            draw.SimpleText("Noclip", "HZN:Bold@20", sw(10) + (stats * 100) + sw(10 * (5 + stats)), topStatY + sh(14), HZNHud:GetColor(5), 1, 1) 
        end

        if (LocalPlayer():GetNWBool("HasGodMode", false)) then
            stats = stats + 1
            draw.RoundedBox(2, sw(10) + (stats * 110), topStatY, sw(100), sh(30), HZNHud:GetColor(2), true, false, true, false) -- left bg
            draw.SimpleText("God", "HZN:Bold@20", sw(10) + (stats * 100) + sw(10 * (5 + stats)), topStatY + sh(14), HZNHud:GetColor(5), 1, 1) 
        end

        if (LocalPlayer():sam_get_nwvar("cloaked")) then
            stats = stats + 1

            if (stats > 2) then
                draw.RoundedBox(2, sw(10) + ((stats - 3) * 110), topStatY - sh(40), sw(100), sh(30), HZNHud:GetColor(2), true, false, true, false) -- left bg
                draw.SimpleText("Cloak", "HZN:Bold@20", sw(10) + ((stats - 3) * 100) + sw(10 * (5 + (stats - 3))), topStatY - sh(26), HZNHud:GetColor(5), 1, 1)
            else
                draw.RoundedBox(2, sw(10) + (stats * 110), topStatY, sw(100), sh(30), HZNHud:GetColor(2), true, false, true, false) -- left bg
                draw.SimpleText("Cloak", "HZN:Bold@20", sw(10) + (stats * 100) + sw(10 * (5 + stats)), topStatY + sh(14), HZNHud:GetColor(5), 1, 1) 
            end
        end         
    end)

    if (HZNHud.PlayerAvatar) then
        HZNHud.PlayerAvatar:Remove()
    end

    HZNHud.PlayerAvatar = vgui.Create("AvatarImage")
    HZNHud.PlayerAvatar:SetSize(sw(64), sh(64))
    HZNHud.PlayerAvatar:SetPos(statX + sw(5), statY + sh(5))
    HZNHud.PlayerAvatar:SetPlayer(LocalPlayer(), 64)
    HZNHud.PlayerAvatar:SetVisible(true)
    HZNHud.PlayerAvatar:ParentToHUD()
end

classic:SetDrawFunction(drawFunc)
classic:SetClearFunction(clearFunc)