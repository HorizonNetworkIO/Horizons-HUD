HZNHud.Modules = {}
HZNHud.SubModules = {}
local MODULE = {}

function HZNHud:CreateModule()
    local mod = {}
    for k,v in pairs(MODULE) do
        mod[k] = v
    end
    return mod
end

function HZNHud:GetModule(name)
    for k,v in ipairs(HZNHud.Modules) do
        if (v.name == name) then
            return v
        end
    end
    for k,v in ipairs(HZNHud.SubModules) do
        if (v.name == name) then
            return v
        end
    end
    return nil
end

function HZNHud:IsModuleActive(mod)
    if (HZNHud:GetModule(mod)) then
        if (HZNHud:GetModule(mod).isDrawing) then
            return false 
        end
    end
    return true
end

function HZNHud:GetActiveModules()
    local cfg = HZNHud:GetConfig()
    local modules = {}
    for k, v in ipairs(HZNHud.Modules) do
        if cfg.modules[v.name] then
            modules[v.name] = v
        end
    end
    return modules
end

function HZNHud:GetActiveSubModules()
    local modules = {}
    for k, v in ipairs(HZNHud.SubModules) do
        if cfg.submodules[v.name] then
            modules[v.name] = v
        end
    end
    return modules
end

function MODULE:SetClearFunction(func)
    self.ClearFunc = function()
        func()
        self.isDrawing = false 
    end
end

function MODULE:SetDrawFunction(func)
    self.DrawFunc = function()
        func()
        self.isDrawing = true
    end
end

function MODULE:Save(name, enabledByDefault, contextHud, alwaysDraw)
    if (not name) then
        name = "default"
    end

    if (not enabledByDefault) then
        enabledByDefault = false
    end

    if (HZNHud:GetModule(name) != nil) then return end

    self.enabledDefault = enabledByDefault
    if (contextHud) then
        self.context = contextHud
    end
    if (alwaysDraw) then
        self.alwaysDraw = alwaysDraw
    end
    self.name = name
    self.id = #HZNHud.Modules + 1
    table.insert(HZNHud.Modules, self)
end

function MODULE:SaveSub(name, enabledByDefault, contextHud, alwaysDraw)
    if (not name) then
        name = "default"
    end

    if (not enabledByDefault) then
        enabledByDefault = false
    end

    if (HZNHud:GetModule(name) != nil) then return end

    self.enabledDefault = enabledByDefault
    if (contextHud) then
        self.context = contextHud
    end
    self.name = name
    self.id = #HZNHud.SubModules + 1
    self.subModule = true
    if (alwaysDraw) then
        self.alwaysDraw = alwaysDraw
    end
    table.insert(HZNHud.SubModules, self)
end

function MODULE:Draw()
    if (self.DrawFunc) then
        self.DrawFunc()
    end
end

function MODULE:Clear()
    if (self.ClearFunc) then
        self.ClearFunc()
    end
end