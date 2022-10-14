HZNHud.ShouldDraw = true

function HZNHud:Init()
    HZNHud:LoadFonts()
    HZNHud:LoadConfig()
end

function HZNHud:RefreshHUD()
    if (not IsValid(LocalPlayer())) then 
        timer.Create("HZNHud:RefreshHUD", 1, 1, function()
            HZNHud:RefreshHUD()
        end)
        return
    end

    local cfg = HZNHud:GetConfig()

    // draw modules
    for k, v in pairs(HZNHud.Modules) do
        if (HZNHud.ShouldDraw) then
            if (cfg.modules[v.name]) then
                if (v.alwaysDraw) then
                    v:Draw()
                elseif (v.context) then
                    if (HZNHud.ContextOpen) then
                        v:Draw()
                    else
                        v:Clear()
                    end
                else
                    v:Clear()
                    v:Draw()
                end
            elseif (v.isDrawing) then
                v:Clear()
            end
        else
            if (v.isDrawing) then // should not draw + enabled
                if (not v.context or (v.context and !HZNHud.ContextOpen)) then
                    if (!v.alwaysDraw) then
                        v:Clear()
                    end
                end
            else
                if (cfg.modules[v.name]) then
                    if ((v.context and HZNHud.ContextOpen) or v.alwaysDraw) then
                        v:Draw()
                    end 
                end
            end
        end
    end

    // draw submodules
    for k, v in pairs(HZNHud.SubModules) do
        if (HZNHud.ShouldDraw) then
            if cfg.submodules[v.name] then // should draw + enabled
                v:Clear()
                v:Draw()
            elseif (v.isDrawing) then // should draw + disabled
                v:Clear()
            end
        elseif (v.isDrawing) then // should not draw + enabled
            v:Clear()
        end
    end
end