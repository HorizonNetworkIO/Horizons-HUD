local HUDData = {}

function HUDData:Load()
    if (not file.Exists("hznhud/config.txt", "DATA")) then
        if (HZNHud:GetConfig() == nil) then
            HZNHud:CreateConfig()
        else
            self:Save()
        end
    end

    local f = file.Read("hznhud/config.txt", "DATA")

    if (not f) then
        if (HZNHud:GetConfig() == nil) then
            HZNHud:CreateConfig()
        else
            self:Save()
        end
        return
    end

    local config = util.JSONToTable(f)

    if (config.version ~= HZNHud.Config.Version) then
        if (HZNHud:GetConfig() == nil) then
            HZNHud:CreateConfig()
        else
            self:Save()
        end
        return
    end

    HZNHud.dataconfig = self
    HZNHud.dataconfig.version = config.version
    HZNHud.dataconfig.options = config.options
    HZNHud.dataconfig.modules = config.modules
    HZNHud.dataconfig.submodules = config.submodules
    HZNHud.dataconfig.colors = config.colors

    HZNHud:RefreshHUD()
end

function HUDData:Save()
    if (not file.IsDir("hznhud", "DATA")) then
        file.CreateDir("hznhud")
    end

    local saveData = {}
    saveData.version = HZNHud.Config.Version
    saveData.options = self.options
    saveData.colors =  self.colors
    saveData.modules = self.modules
    saveData.submodules = self.submodules

    file.Write("hznhud/config.txt", util.TableToJSON(saveData))

    self:Load()
end

function HZNHud:CreateConfig()
    HZNHud:Log("Creating config file...") 

    local cfg = {}

    cfg.Load = HUDData.Load
    cfg.Save = HUDData.Save
    cfg.version = HZNHud.Config.Version

    cfg.modules = {}
    cfg.submodules = {}

    for k, v in ipairs(HZNHud.Modules) do
        cfg.modules[v.name] = v.enabledDefault
    end
    for k, v in ipairs(HZNHud.SubModules) do
        cfg.submodules[v.name] = v.enabledDefault
    end

    cfg.colors = HZNHud.Colors

    HZNHud.dataconfig = cfg

    return cfg
end

function HZNHud:GetConfig()
    return self.dataconfig
end

function HZNHud:GetColor(index)
    if (not self.dataconfig) then
        self:CreateConfig()
    end

    return self.dataconfig.colors[index]
end

function HZNHud:LoadConfig()
    local cfg = self:GetConfig()
    if not cfg then
        cfg = self:CreateConfig()
    end

    HZNHud:Log("Loading config file. Version " .. cfg.version)

    if cfg.version ~= HZNHud.Config.Version then
        cfg.version = HZNHud.Config.Version

        for k,v in ipairs(cfg.submodules) do
            if not HZNHud.SubModules[k] then
                cfg.submodules[k] = nil
                HZNHud:Log("Removed submodule " .. k)
            end
        end

        for k,v in ipairs(cfg.modules) do
            if not HZNHud.Modules[k] then
                cfg.modules[k] = nil
                HZNHud:Log("Removed module " .. k)
            end
        end

        cfg:Save()
    end

    cfg:Load()
end