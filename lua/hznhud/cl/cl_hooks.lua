local disabled = {
    ["CHudBattery"] = true,
    ["CHudHealth"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["DarkRP_HUD"] = true,
    ["DarkRP_EntityDisplay"] = true,
    ["DarkRP_LocalPlayerHUD"] = true,
    ["DarkRP_Hungermod"] = true,
    ["DarkRP_Agenda"] = true,
    ["DarkRP_LockdownHUD"] = true,
    ["DarkRP_ArrestedHUD"] = true,
    ["DarkRP_ChatReceivers"] = false
}

local disabledWeapons = {
    ["polaroid"] = true,
    ["gmod_camera"] = true
}

hook.Add("HUDShouldDraw", "HZNHud:DisableDefaultHUDElements", function(name)
    if disabled[name] then return false end
end)

hook.Add("OnSpawnMenuOpen", "HZNHud.StopDrawingSpawnMenu", function()
    HZNHud.ShouldDraw = false
    HZNHud:RefreshHUD()
end)

hook.Add("OnSpawnMenuClose", "HZNHud.StartDrawingSpawnMenu", function()
    HZNHud.ShouldDraw = true
    HZNHud:RefreshHUD()
end)

hook.Add("OnContextMenuOpen", "HZNHud.StopDrawingContextMenu", function()
    HZNHud.ShouldDraw = false
    HZNHud.ContextOpen = true
    HZNHud:RefreshHUD()
end)

hook.Add("OnContextMenuClose", "HZNHud.StopDrawingContextMenu", function()
    HZNHud.ShouldDraw = true
    HZNHud.ContextOpen = false
    HZNHud:RefreshHUD()
end)

hook.Add("PlayerSwitchWeapon", "HZNHud.ToggleHUDOnCamera", function(ply, oldWep, newWep)
    if (ply == LocalPlayer() and ply:Alive() and ply:IsValid() and IsValid(newWep)) then
        if (disabledWeapons[newWep:GetClass()]) then
            HZNHud.ShouldDraw = false
        else
            HZNHud.ShouldDraw = true
        end
        HZNHud:RefreshHUD()
    end
end)