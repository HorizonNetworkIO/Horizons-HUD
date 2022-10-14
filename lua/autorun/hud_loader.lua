// Steel's Addon Loader
// Fuck off

local AddonSubFolder = "hznhud"
local AddonName = "HZNHud"
local AddonColor = Color(171, 55, 206)
local DebugAddon = true

HZNHud = {}

function HZNHud:Log(str)
    MsgC(AddonColor, "[" .. AddonName .. "] ", Color(255, 255, 255), str .. "\n")
end

local function loadServerFile(str)
    if CLIENT then return end
    include(str)
    HZNHud:Log("Loaded Server File " .. str)
end

local function loadClientFile(str)
    if SERVER then AddCSLuaFile(str) return end
    include(str)
    HZNHud:Log("Loaded Client File " .. str)
end

local function loadSharedFile(str)
    if SERVER then AddCSLuaFile(str) end
    include(str)
    HZNHud:Log("Loaded Shared File " .. str)
end

local function load()
    local clientFiles = file.Find(AddonSubFolder .. "/cl/*.lua", "LUA")
    local sharedFiles = file.Find(AddonSubFolder .. "/sh/*.lua", "LUA")
    local serverFiles = file.Find(AddonSubFolder .. "/sv/*.lua", "LUA")
    local vguiFiles = file.Find(AddonSubFolder .. "/cl/vgui/*.lua", "LUA")
    local _, moduleFiles = file.Find(AddonSubFolder .. "/cl/modules/*", "LUA")

    for _, file in pairs(clientFiles) do
        loadClientFile(AddonSubFolder .. "/cl/" .. file)
    end

    for _, file in pairs(vguiFiles) do
        loadClientFile(AddonSubFolder .. "/cl/vgui/" .. file)
    end

    for _, file in pairs(sharedFiles) do
        loadSharedFile(AddonSubFolder .. "/sh/" .. file)
    end

    for _, file in pairs(serverFiles) do
        loadServerFile(AddonSubFolder .. "/sv/" .. file)
    end

    // find all folders in /cl/modules then load all lua files in them
    local addedFiles = 0
    for _, folder in pairs(moduleFiles) do
        HZNHud:Log("Loading module: " .. folder)
        local files = file.Find(AddonSubFolder .. "/cl/modules/" .. folder .. "/*.lua", "LUA")
        for _, fl in pairs(files) do
            HZNHud:Log("Loading module file: " .. fl)
            loadClientFile(AddonSubFolder .. "/cl/modules/" .. folder .. "/" .. fl)
            addedFiles = addedFiles + 1
        end
    end

    HZNHud:Log("Loaded " .. #clientFiles + #sharedFiles + #serverFiles + addedFiles .. " files")

    if (CLIENT) then
        HZNHud:Init()
    end
end

load()