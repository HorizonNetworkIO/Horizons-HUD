local pnl
local voices = {}

local PANEL = {}

local function draw_OutlinedBox(x, y, w, h, thick, color)
	surface.SetDrawColor(color)
	for i = 0, thick - 1 do
		surface.DrawOutlinedRect(x + i, y + i, w - i * 2, h - i * 2)
	end
end

function PANEL:Init()
    self.TalkerModel = vgui.Create("DModelPanel", self)
    self.TalkerModel:SetSize(32, 32)
    self.TalkerModel:SetPos(8, 8)
    self.TalkerModel:SetModel("models/gman_high.mdl")
    self.TalkerModel.LayourEntity = function() return end

    local eyepos = self.TalkerModel.Entity:GetBonePosition(self.TalkerModel.Entity:LookupBone("ValveBiped.Bip01_Head1"))
    eyepos:Add(Vector(0, 0, -2))

    self.TalkerModel:SetLookAt(eyepos)
    self.TalkerModel:SetCamPos(eyepos - Vector(-17, 3, -2))

    self.TalkerNick = vgui.Create("DLabel", self)
    self.TalkerNick:SetFont("HZN:Bold@20")
    self.TalkerNick:SetPos(52, 5)
    self.TalkerNick:SetTextColor(HZNHud:GetColor(3))

    self.TalkerJob = vgui.Create("DLabel", self)
    self.TalkerJob:SetFont("HZN:Default@20")
    self.TalkerJob:SetPos(52, 22)
    self.TalkerJob:SetTextColor(HZNHud:GetColor(5))
    
    self:SetSize(188, 48)
    self:DockMargin(0, 10, 0, 0)
    self:Dock(BOTTOM)
end

function PANEL:Setup(ply)
    self.Talker = ply
    self.VoiceColor = HZNHud:GetColor(1)

    local model = ply:GetModel()

    if util.IsValidModel(model) then
        self.TalkerModel:SetModel(model)
        self.Model = model
    else
        self.TalkerModel:SetModel("")
        self.Model = ""
    end

    local nick = ply:Name()
    nick = (#nick > 13 and nick:Left(25)) or nick
    
    self.TalkerNick:SetText(nick)
    self.TalkerNick:SizeToContents()

    local job = ply:getDarkRPVar("job") or "Unassigned"
    job = (#job > 13 and job:Left(25)) or job

    self.TalkerJob:SetText(job)
    self.TalkerJob:SizeToContents()

    self:InvalidateLayout()
end

function PANEL:Paint(w, h)
    if not IsValid(self.Talker) then return end

    draw.RoundedBox(0, 0, 0, w, h, HZNHud:GetColor(1))

    local color1 = self.VoiceColor
    local vol = 150
    if (self.Talker ~= LocalPlayer()) then
        vol = self.Talker:VoiceVolume() * 255
    end
    local color2 = Color(HZNHud:GetColor(3).r, HZNHud:GetColor(3).g, HZNHud:GetColor(3).b, vol)

    draw_OutlinedBox(6, 6, 36, 36, 1, color1)
	draw_OutlinedBox(5, 5, 38, 38, 1, color2)
end

function PANEL:Think()
    if self.fadeAnim then
        self.fadeAnim:Run()
    end

    if not IsValid(self.Talker) and IsValid(voices[self.Talker]) then 
        voices[self.Talker]:Remove()
        voices[self.Talker] = nil
    end
end

function PANEL:FadeOut(anim, delta)
    if anim.Finished then
        if IsValid(voices[self.Talker]) then
            voices[self.Talker]:Remove()
            voices[self.Talker] = nil
            return
        end

        return
    end

    self:SetAlpha(255 - (255 * delta))
end

derma.DefineControl("HZNHud_Voice", "", PANEL, "DPanel")

hook.Add("PlayerEndVoice", "HZNHud_Voice", function(ply)
    local voice = voices[ply]

    if IsValid(voice) then
        if voice.fadeAnim then return end

        if voice.TalkerModel then
            voice.TalkerModel:SetModel("")
        end

        voice.fadeAnim = Derma_Anim("FadeOut", voice, voice.FadeOut)
        voice.fadeAnim:Start(0.125)

        voice.VoiceColor = HZNHud:GetColor(4)
    end
end)

hook.Add("PlayerStartVoice", "HZNHud_Voice", function(ply)
    if not IsValid(HZNHud.VoicePnl) then return end

    GAMEMODE:PlayerEndVoice(ply)

    local voice = voices[ply]

    if IsValid(voice) then
        if voice.fadeAnim then
            voice.fadeAnim:Stop()
            voice.fadeAnim = nil
        end

        if voice.TalkerModel and voice.Model then
            voice.TalkerModel:SetModel(voice.Model)
        end

        voice:SetAlpha(255)
        voice.VoiceColor = HZNHud:GetColor(3)
        return
    end

    if IsValid(ply) then
        local panel = HZNHud.VoicePnl:Add("HZNHud_Voice")
        panel:Setup(ply)

        voices[ply] = panel
    end
end)

timer.Create("HZNHud_VoiceClean", 10, 0, function()
    for ply in pairs(voices) do
        if not IsValid(ply) then
            GAMEMODE:PlayerEndVoice(ply)
        end
    end 
end)

hook.Add("InitPostEntity", "HZNHud_Voice", function()
    if (HZNHud.VoicePnl) then
        HZNHud.VoicePnl:Remove()
    end

    timer.Simple(2, function()
        if not IsValid(g_VoicePanelList) then return end
        g_VoicePanelList:Remove()
    end)

    HZNHud.VoicePnl = vgui.Create("DPanel")
    HZNHud.VoicePnl:ParentToHUD()
    HZNHud.VoicePnl:SetPos(ScrW() - 208, 0)
    HZNHud.VoicePnl:SetSize(188, ScrH() - 200)
    HZNHud.VoicePnl:SetPaintBackground(false)
end)