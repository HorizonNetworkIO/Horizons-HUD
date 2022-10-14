hook.Add("PlayerSay", "HZNHud:PlayerSay", function(ply, text)
    if (string.lower(text) == "!hud" or string.lower(text) == "/hud") then
        ply:ConCommand("hznhud_menu")
        return ""
    end
end)