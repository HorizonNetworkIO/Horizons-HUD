local sw = function (x) return (ScrW() * x)/1920 end
local sh = function (x) return (ScrH() * x)/1080 end

local notifications = {}

local classic = HZNHud:CreateModule()
classic:SaveSub("Classic Notify", true)

local icons = {
    [NOTIFY_GENERIC] = Color(66, 139, 202),
    [NOTIFY_ERROR] = Color(231, 56, 49),
    [NOTIFY_UNDO] = Color(92, 184, 92),
    [NOTIFY_HINT] = Color(238, 206, 62),
    [NOTIFY_CLEANUP] = Color(228, 144, 88)
}

concommand.Add("hud_testnotify", function()
    notification.AddLegacy("Test Generic", NOTIFY_GENERIC, 2)
    notification.AddLegacy("Test Error", NOTIFY_ERROR, 2)
    notification.AddLegacy("Test Undo", NOTIFY_UNDO, 2)
    notification.AddLegacy("Test Hint", NOTIFY_HINT, 2)
    notification.AddLegacy("Test Cleanup", NOTIFY_CLEANUP, 2)
end)

local function draw_Icon(x, y, w, h, color, icon)
	surface.SetMaterial(icon)
	surface.SetDrawColor(color)
	surface.DrawTexturedRect(x, y, w, h)
end

do
    local oldAddLegacy = notification.AddLegacy
    local oldKill = notification.Kill

    local drawFunc = function()
        function notification.AddLegacy(text, type, time)
            local x, y = ScrW(), ScrH()
        
            surface.SetFont("HZN:Default@20")
            local w, h = surface.GetTextSize(text)
        
            table.insert(notifications, {x = x, y = y, w = w + 45, h = h + 17, text= text, icon = icons[type] or icons[1], time = CurTime() + time})
        end
        
        function notification.Kill(id)
            for k,v in pairs(notifications) do
                if v.id == id then
                    v.time = 0
                end
            end
        end

        hook.Add("HUDPaint", "HZNHud:Module:ClassicNotifications", function()
            local scrw = ScrW()
            local scrh = ScrH()

            for k, v in pairs(notifications) do
                local x = math.floor(v.x)
                local y = math.floor(v.y)
                local w = v.w
                local h = v.h

                draw.RoundedBox(4, x, y, w, h, HZNHud:GetColor(1))
                draw.RoundedBoxEx(4, x + w - sw(10), y, sw(10), h, v.icon, false, true, false, true)
                //draw_Icon(x + 10, y + 10, 16, 16, HZNHud:GetColor(3), v.icon)
                draw.DrawText(v.text, "HZN:Default@20", x + 18, y + 8, HZNHud:GetColor(5), TEXT_ALIGN_LEFT, 1)

                v.x = Lerp(FrameTime() * 8, v.x, v.time > CurTime() and scrw - v.w - 20 or scrw + 1)
                v.y = Lerp(FrameTime() * 8, v.y, scrh - 104 - (k * (v.h + 4)))
            end

            for k, v in pairs(notifications) do
                if v.x >= scrw and v.time < CurTime() then
                    table.remove(notifications, k)
                end
            end
        end)
    end

    local clearFunc = function()
        hook.Remove("HUDPaint", "HZNHud:Module:ClassicNotifications")

        notification.AddLegacy = oldAddLegacy
        notification.Kill = oldKill
    end

    classic:SetDrawFunction(drawFunc)
    classic:SetClearFunction(clearFunc)
end