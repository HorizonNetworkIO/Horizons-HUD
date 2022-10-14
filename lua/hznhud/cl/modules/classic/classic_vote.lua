local draw_RoundedBox = draw.RoundedBox
local draw_SimpleText = draw.SimpleText
local draw_DrawText = draw.DrawText

local totalheight = 0
local votes = {}
local questions = {}

function HZNHud.StartVotes()

	local number = (HZNHud.AgendaEnabled and HZNHud.AgendaSize + 120) or 60

    PrintTable(votes)

	for k, v in SortedPairs(votes) do
		v:SetPos(ScrW() - v:GetWide() - 10, number)
		number = number + v:GetTall() + 20
	end

	for k, v in SortedPairs(questions) do
		v:SetPos(ScrW() - v:GetWide() - 10, number)
		number = number + v:GetTall() + 20
	end
end

--[[------------------------------------------------------------

	Vote

------------------------------------------------------------]]--
local function DoVote(msg)

	if not IsValid(LocalPlayer()) then return end

	local question = msg:ReadString()
	local voteid = msg:ReadShort()
	local expires = msg:ReadFloat()

	if expires == 0 then
		expires = 100
	end

	local oldtime = CurTime()

	LocalPlayer():EmitSound("buttons/combine_button2.wav", 100, 100)

	question = DarkRP.textWrap(question:gsub("\\n", "\n"), "HZN:Default@20", 176)

	surface.SetFont("HZN:Default@20")
	local width, height = surface.GetTextSize(question)

	local voteheight = (HZNHud.AgendaEnabled and HZNHud.AgendaSize + 120) or 60
	voteheight = voteheight + totalheight

	local pnl = vgui.Create("DFrame")
	pnl:SetSize(208, 56 + height)
	pnl:SetPos(ScrW() - pnl:GetWide() - 10, voteheight)
	pnl:SetTitle("")
	pnl:ShowCloseButton(false)
	pnl:SetDraggable(false)
	pnl.Paint = function(self, w, h)
		draw_RoundedBox(0, 0, 0, w, h, HZNHud:GetColor(1))
		draw_DrawText(question, "HZN:Default@20", w * 0.5, 12, HZNHud:GetColor(5), 1)
	end
	pnl.OnClose = function(self)
		totalheight = totalheight - self:GetTall() - 20
		votes[voteid] = nil

		HZNHud.StartVotes()

		self:Remove()
	end
	pnl.Think = function(self)
		if expires - (CurTime() - oldtime) <= 0 then
			self:Close()
		end
	end

	local yeabtn = vgui.Create("DButton", pnl)
	yeabtn:SetSize(48, 24)
	yeabtn:SetPos(51, pnl:GetTall() - 34)
	yeabtn:SetText("")
	yeabtn.Paint = function(self, w, h)
		draw_RoundedBox(0, 0, 0, w, h, HZNHud:GetColor(2))
		draw_SimpleText("Yes", "HZN:Default@20", w * 0.5, h * 0.5 - 1, HZNHud:GetColor(3), 1, 1)
	end
	yeabtn.DoClick = function()
		LocalPlayer():ConCommand("vote " .. voteid .. " yea\n")
		pnl:Close()
	end

	local naybtn = vgui.Create("DButton", pnl)
	naybtn:SetSize(48, 24)
	naybtn:SetPos(109, pnl:GetTall() - 34)
	naybtn:SetText("")
	naybtn.Paint = function(self, w, h)
		draw_RoundedBox(0, 0, 0, w, h, HZNHud:GetColor(2))
		draw_SimpleText("No", "HZN:Default@20", w * 0.5, h * 0.5 - 1, HZNHud:GetColor(3), 1, 1)
	end
	naybtn.DoClick = function()
		LocalPlayer():ConCommand("vote " .. voteid .. " nay\n")
		pnl:Close()
	end

	totalheight = totalheight + pnl:GetTall() + 20
	votes[voteid] = pnl

end

local function KillVote(msg)
	local voteid = msg:ReadShort()
	local vote = votes[voteid]

	if vote and IsValid(vote) then
		vote:Close()
	end
end

--[[------------------------------------------------------------

	Question

------------------------------------------------------------]]--
local function DoQuestion(msg)
	if not IsValid(LocalPlayer()) then return end

	local question = msg:ReadString()
	local questionid = msg:ReadString()
	local expires = msg:ReadFloat()

	if expires == 0 then
		expires = 100
	end

	local oldtime = CurTime()

	LocalPlayer():EmitSound("buttons/combine_button2.wav", 100, 100)

	question = DarkRP.textWrap(question:gsub("\\n", "\n"), "HZN:Default@20", 176)

	surface.SetFont("HZN:Default@20")
	local width, height = surface.GetTextSize(question)
    
	local questionheight = (HZNHud.AgendaEnabled and HZNHud.AgendaSize + 120) or 60
	questionheight = questionheight + totalheight

	local pnl = vgui.Create("DFrame")
	pnl:SetSize(208, 56 + height)
	pnl:SetPos(ScrW() - pnl:GetWide() - 10, questionheight)
	pnl:SetTitle("")
	pnl:ShowCloseButton(false)
	pnl:SetDraggable(false)
	pnl.Paint = function(self, w, h)
		draw_RoundedBox(0, 0, 0, w, h, HZNHud:GetColor(1))
		draw_DrawText(question, "HZN:Default@20", w * 0.5, 12, HZNHud:GetColor(5), 1)
	end
	pnl.OnClose = function(self)
		totalheight = totalheight - self:GetTall() - 20
		questions[questionid] = nil

		HZNHud.StartVotes()

		self:Remove()
	end
	pnl.Think = function(self)
		if expires - (CurTime() - oldtime) <= 0 then
			self:Close()
		end
	end

	local yeabtn = vgui.Create("DButton", pnl)
	yeabtn:SetSize(48, 24)
	yeabtn:SetPos(51, pnl:GetTall() - 34)
	yeabtn:SetText("")
	yeabtn.Paint = function(self, w, h)
		draw_RoundedBox(0, 0, 0, w, h, HZNHud:GetColor(2))
		draw_SimpleText("Yes", "HZN:Default@20", w * 0.5, h * 0.5 - 1, HZNHud:GetColor(3), 1, 1)
	end
	yeabtn.DoClick = function()
		LocalPlayer():ConCommand("ans " .. questionid .. " 1\n")
		pnl:Close()
	end

	local naybtn = vgui.Create("DButton", pnl)
	naybtn:SetSize(48, 24)
	naybtn:SetPos(109, pnl:GetTall() - 34)
	naybtn:SetText("")
	naybtn.Paint = function(self, w, h)
		draw_RoundedBox(0, 0, 0, w, h, HZNHud:GetColor(2))
		draw_SimpleText("No", "HZN:Default@20", w * 0.5, h * 0.5 - 1, HZNHud:GetColor(3), 1, 1)
	end
	naybtn.DoClick = function()
		LocalPlayer():ConCommand("ans " .. questionid .. " 2\n")
		pnl:Close()
	end

	totalheight = totalheight + pnl:GetTall() + 20
	questions[questionid] = pnl
end

local function KillQuestion(msg)
	local questionid = msg:ReadString()
	local question = questions[questionid]

	if question and IsValid(question) then
		question:Close()
	end
end

--[[------------------------------------------------------------

	InitPostEntity

------------------------------------------------------------]]--
hook.Add("InitPostEntity", "HZNHud_Vote", function()

	usermessage.Hook("DoVote", DoVote)
	usermessage.Hook("KillVoteVGUI", KillVote)
	usermessage.Hook("DoQuestion", DoQuestion)
	usermessage.Hook("KillQuestionVGUI", KillQuestion)

end)