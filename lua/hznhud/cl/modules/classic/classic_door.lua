local doorcache = {}
local trace = {}
local offset = Angle(0, 90, 90)

local classic = HZNHud:CreateModule()
classic:SaveSub("Classic Door", true)

local function drawFunc()
    if (!timer.Exists("HZNHud:SubModule:DoorRefresh")) then
        timer.Create("HZNHud:SubModule:DoorRefresh", 0.5, 0, function()
            local client = LocalPlayer()
        
            if not IsValid(client) then return end
        
            local doorcount = 0
            doorcache = {}
        
            for k,v in ipairs(ents.FindInSphere(client:GetPos(), 300)) do
                if not IsValid(v) or not v:isDoor() or not v:isKeysOwnable() then continue end
        
                doorcount = doorcount + 1
                doorcache[doorcount] = v
            end
        end)
    end

    local purchaseWidth
    hook.Add("PostDrawTranslucentRenderables", "HZN:SubModules:ClassicDoor", function()
        if (!purchaseWidth) then
            surface.SetFont("HZN:Default@30")
            purchaseWidth = select(1, surface.GetTextSize("Purchase for "))
        end

        for k,v in ipairs(doorcache) do
            if not IsValid(v) then continue end

            local client = LocalPlayer()
            local pos = v:LocalToWorld(v:OBBCenter())
            pos.z = pos.z + 17.5

            trace.start = client:GetPos() + client:OBBCenter()
            trace.endpos = pos
            trace.filter = client

            local tr = util.TraceLine(trace)

            if tr.Entity ~= v then continue end
            if pos:DistToSqr(tr.HitPos) > 65 then continue end

            local owned = v:isKeysOwned()
            local owner = v:getDoorOwner()
            local title = v:getKeysTitle()
            local coowners = v:getKeysCoOwners() or {}
            local group = v:getKeysDoorGroup()
            local teams = v:getKeysDoorTeams()
            local disallowed = v:getKeysNonOwnable()

            cam.Start3D2D(tr.HitPos + tr.HitNormal, tr.HitNormal:Angle() + offset, .15)
                if owned then
                    draw.SimpleText(title or "Owned by", "HZN:Default@40", 0, 0, HZNHud:GetColor(5), 1, 1)

                    local nick = owner:Name()

                    draw.SimpleText(nick, "HZN:Bold@30", 0, HZNHud.SH(30), HZNHud:GetColor(3), 1, 1)

                    local count = 1

                    for k,v in pairs(coowners) do
                        local ply = Player(k)

                        if not IsValid(ply) then continue end

                        local coownernick = ply:Name()

                        draw.SimpleText(coownernick, "HZN:Bold@30", 0, 30 + (count * 25), HZNHud:GetColor(3), 1, 1)

                        count = count + 1
                    end
                elseif group then
                    draw.SimpleText(title or "Group", "HZN:Default@40", 0, 0, HZNHud:GetColor(5), 1, 1)

                    -- group
                    local name = group
                    draw.SimpleText(name, "HZN:Bold@30", 0, HZNHud.SH(30), HZNHud:GetColor(3), 1, 1)
                elseif teams then
                    draw.SimpleText(title or "Teams", "HZN:Default@40", 0, 0, HZNHud:GetColor(5), 1, 1)

                    local count = 0

                    for k,v in pairs(teams) do
                        if not v or not RPExtraTeams[k] then continue end

                        local name = RPExtraTeams[k].name

                        draw.SimpleText(name, "HZN:Default@40", 0, 30 + (count * 20), HZNHud:GetColor(5), 1, 1)

                        count = count + 1
                    end
                elseif not disallowed and not owned then
                    draw.SimpleText("Unowned", "HZN:Bold@40", 0, 0, HZNHud:GetColor(5), 1, 1)
                    draw.SimpleText("Purchase for ", "HZN:Default@30", HZNHud.SW(-purchaseWidth/2 - 25), HZNHud.SH(30), HZNHud:GetColor(5), 3, 1)
                    draw.SimpleText(DLL.FormatMoney(tonumber(GAMEMODE.Config.doorcost)), "HZN:Bold@30", HZNHud.SW(-purchaseWidth/2 - 25) + purchaseWidth, HZNHud.SH(31), HZNHud:GetColor(3), 3, 1)
                end
            cam.End3D2D()
        end
    end)
end

local function clearFunc()
    hook.Remove("PostDrawTranslucentRenderables", "HZN:SubModules:ClassicDoor")
    timer.Remove("HZNHud:SubModule:DoorRefresh")
end

classic:SetDrawFunction(drawFunc)
classic:SetClearFunction(clearFunc)