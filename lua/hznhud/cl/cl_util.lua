function HZNHud.SW(val)
    return (val / 1920) * ScrW()
end

function HZNHud.SH(val)
    return (val / 1080) * ScrH()
end

function HZNHud.FormatText(text, maxLength)
    if #text > maxLength then
        text = string.sub(text, 1, maxLength) .. "..."
    end
    return text
end

function HZNHud.DrawShadowedRect(mat, x, y, w, h, color, colorDrop, distance)
    local shadowColor = Color(color.r * colorDrop, color.g * colorDrop, color.b * colorDrop, color.a)
    surface.SetDrawColor(shadowColor)
    surface.SetMaterial(mat)
    surface.DrawTexturedRect(x + distance, y + distance, w, h)
    surface.SetDrawColor(color)
    surface.DrawTexturedRect(x, y, w, h)
end

function HZNHud.GetPrimaryAmmo()
    local ply = LocalPlayer()

    if (!ply:IsValid()) then return "" end
    if (!ply:GetActiveWeapon():IsValid()) then return "" end

    if (ply:GetActiveWeapon():GetClass() == "weapon_physgun" or ply:GetActiveWeapon():GetClass() == "gmod_tool") then
        return ply:GetCount("props")
    else
        if (ply:GetActiveWeapon():Clip1() > -1) then
            return ply:GetActiveWeapon():Clip1()
        end
    end

    return "0"
end

function HZNHud.GetSecondaryAmmo()
    local ply = LocalPlayer()

    if (!ply:IsValid()) then return "" end
    if (!ply:GetActiveWeapon():IsValid()) then return "" end

    local maxProps = 0

    if (ply:GetActiveWeapon():GetClass() == "weapon_physgun" or ply:GetActiveWeapon():GetClass() == "gmod_tool") then
        -- max props limit
        if (ply.GetLimit) then
            if (ply:GetLimit("props")) then
                maxProps = LocalPlayer():GetLimit("props")
            else
                maxProps = 0
            end
        else
            maxProps = GetConVar( "sbox_maxprops" ):GetInt()
        end

        if (maxProps == -1) then 
            maxProps = "INF"
        end
        return maxProps
    else
        return ply:GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())
    end

    return "0"
end

function HZNHud.GetCurrentTime()
    return os.date("%I:%M %p")
end