local classic = HZNHud:CreateModule()
classic:SaveSub("Classic Overhead", true)

local drawFunc = function()
    if (!timer.Exists("HZNHud.OverheadRefresh")) then
        timer.Create("HZNHud.OverheadRefresh", 0.55, 0, function()
            local client = LocalPlayer()
        
            if not IsValid(client) then return end
        
            local playercount = 0
        
            playercache = {}
            playertable = {}
        
            for k, v in pairs(ents.FindInSphere(client:GetPos(), 512)) do
                if not IsValid(v) or not v:IsPlayer() or not v:Alive() or v:GetRenderMode() == RENDERMODE_TRANSALPHA or v:sam_get_nwvar("cloaked") then continue end
                if v == client then continue end
        
                playercount = playercount + 1
                playercache[playercount] = v
        
                playertable[v] = {
                    name = v:Name(),
                    job = v:getDarkRPVar("job"),
                    teamColor = team.GetColor(v:Team()),
                    wanted = v:getDarkRPVar("wanted"),
                    license = v:getDarkRPVar("HasGunlicense"),
                    health = v:Health(),
                    duty = v:HZN_OnDuty()
                }
            end
        end)
    end

    hook.Add("PostDrawTranslucentRenderables", "HZNHud:SubModule:ClassicOverhead", function()
        if not playercache then return end

        for k,v in ipairs(playercache) do
            if not v:IsValid() then continue end

            local playerinfo = playertable[v]

            if not playerinfo then continue end

            local name = playerinfo.name
            local job = playerinfo.job
            local wanted = playerinfo.wanted
            local license = playerinfo.license
            local health = playerinfo.health
            local teamColor = playerinfo.teamColor
            local duty = playerinfo.duty

            local pos = v:LocalToWorld(Vector(0, 0, v:OBBMaxs().z + 18))
            local ang = LocalPlayer():GetAngles()
            ang:RotateAroundAxis(ang:Forward(), 90)
            ang:RotateAroundAxis(ang:Right(), 90)

            cam.Start3D2D(pos, ang, 0.16)
                draw.TextShadow({
                    text = name,
                    font = "HZN:Bold@40",
                    pos = {0, 0},
                    xalign = 1,
                    yalign = 1,
                    color = HZNHud:GetColor(1),
                }, 1.5, 200)

                draw.TextShadow({
                    text = job,
                    font = "HZN:Bold@35",
                    pos = {0, 30},
                    xalign = 1,
                    yalign = 1,
                    color = HZNHud:GetColor(1),
                }, 1.5, 200)

                draw.TextShadow({
                    text = health,
                    font = "HZN:Bold@30",
                    pos = {0, 60},
                    xalign = 1,
                    yalign = 1,
                    color = HZNHud:GetColor(1),
                }, 1.5, 200)

                draw.SimpleTextOutlined(name, "HZN:Bold@40", 0, 0, HZNHud:GetColor(3), 1, 1, 0.9, HZNHud:GetColor(1))
                draw.SimpleTextOutlined(job, "HZN:Bold@35", 0, 30, teamColor, 1, 1, 0.9, HZNHud:GetColor(1))
                draw.SimpleTextOutlined(health, "HZN:Bold@30", 0, 60, HZNHud:GetColor(5), 1, 1, 0.9, HZNHud:GetColor(1))    

                if (HZNSits) then
                    if (duty) then
                        local txt = "Staff on Duty!"
    
                        draw.TextShadow({
                            text = txt,
                            font = "HZN:Bold@40",
                            pos = {0, -75},
                            xalign = 1,
                            yalign = 1,
                            color = Color(237, 39, 25),
                        }, 1.5, 200)
    
                        draw.SimpleText(txt, "HZN:Bold@40", 0, -75, Color(237, 39, 25), 1, 1)
                    end
                end

                if wanted and license then
                    HZNHud.DrawShadowedRect(HZNHud.Materials.Wanted, -30, -50, 27, 27, HZNHud:GetColor(3), 0.5, 1)
                    HZNHud.DrawShadowedRect(HZNHud.Materials.License, 3, -50, 27, 27, HZNHud:GetColor(3), 0.5, 1)
                else
                    if wanted then
                        HZNHud.DrawShadowedRect(HZNHud.Materials.Wanted, -11, -50, 27, 27, HZNHud:GetColor(3), 0.5, 1)
                    end
                    if license then
                        HZNHud.DrawShadowedRect(HZNHud.Materials.License, -11, -50, 27, 27, HZNHud:GetColor(3), 0.5, 1)
                    end
                end
            cam.End3D2D()
        end
    end)
end

local clearFunc = function()
    timer.Remove("HZNHud.OverheadRefresh")
    hook.Remove("PostDrawTranslucentRenderables", "HZNHud:SubModule:ClassicOverhead")
end

classic:SetDrawFunction(drawFunc)
classic:SetClearFunction(clearFunc)