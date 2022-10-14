local sw = function (x) return (ScrW() * x)/1920 end
local sh = function (x) return (ScrH() * x)/1080 end

local boxW = sw(250)
local boxH = sh(35)
local boxX = ScrW() - boxW - sw(10)
local boxY = sh(55)

local classic = HZNHud:CreateModule()
classic:SaveSub("Classic Agenda", true)

local clearFunc = function()
    hook.Remove("HUDPaint", "HZNHud:SubModule:ClassicAgenda")
    HZNHud.AgendaEnabled = false
end

local drawFunc = function()
    hook.Add("HUDPaint", "HZNHud:SubModule:ClassicAgenda", function()
        if not LocalPlayer():getAgendaTable() then return end 

        local agenda = LocalPlayer():getDarkRPVar("agenda")

        if (!agenda or agenda == "") then 
            HZNHud.AgendaEnabled = false 
            return
        end

        HZNHud.AgendaEnabled = true

        surface.SetFont("HZN:Default@25")
        local agendaW, agendaH = surface.GetTextSize(agenda)

        // add newline to agenda text if it's too long
        if agendaW > boxW then
            local agendaLines = {}
            local agendaLine = ""
            for word in string.gmatch(agenda, "%S+") do
                if (#agendaLine + #word) > (boxW*.1) then
                    agendaLines[#agendaLines + 1] = agendaLine
                    agendaLine = word
                else
                    agendaLine = agendaLine .. " " .. word
                end
            end
            agendaLines[#agendaLines + 1] = agendaLine
            agenda = table.concat(agendaLines, "\n")
        end

        local agendaW, agendaH = surface.GetTextSize(agenda)
        HZNHud.AgendaSize = agendaH

        draw.RoundedBox(2, boxX, boxY, boxW, boxH + agendaH + sh(15), HZNHud:GetColor(1))
        draw.SimpleText("Agenda", "HZN:Bold@25", boxX + boxW/2, boxY + sh(15), HZNHud:GetColor(3), 1, 1)
        // draw multi line text with wrapping
        draw.DrawText(agenda, "HZN:Default@25", boxX + boxW/2, boxY + sh(35), HZNHud:GetColor(5), 1, 1)

        -- draw.Text({
        --     text = agenda,
        --     font = "HZN:Default@25",
        --     pos = {boxX + boxW/2, boxY + boxH + sh(15)},
        --     xalign = TEXT_ALIGN_CENTER,
        --     yalign = TEXT_ALIGN_TOP,
        --     color = HZNHud:GetColor(3),
        -- })

    end)
end

classic:SetDrawFunction(drawFunc)
classic:SetClearFunction(clearFunc)