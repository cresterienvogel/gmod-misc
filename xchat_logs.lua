--[[
	Discord log system i made for my TTT server.
	## xChat is required.
	## https://github.com/cresterienvogel/xChat
]]

local CFG = {}

CFG.Webhook = "" -- Discord webhook URL of posting channel

CFG.Types = {
	["damage"] = true,
	["kills"] = true,
	["ttt"] = true
}

CFG.PostLog = function(msg, clr)
    http.Post(xChat.Config.Handler .. "custom.php", {
        webhook = CFG.Webhook, 
        message = msg, 
        color = clr or "ff957e"
    })
end

--[[
	Logs
]]

if CFG.Types["damage"] and xChat then
	hook.Add("EntityTakeDamage", "xChat Logs", function(target, dmg)
		local attacker = dmg:GetAttacker()
		local damage = math.Round(dmg:GetDamage(), 0)

		if not (target:IsPlayer() and attacker:IsPlayer()) then
			return
		end

		local text = attacker:Name() .. " (" .. attacker:SteamID() .. ") did " .. damage .. " damage to "
		if IsValid(attacker:GetActiveWeapon()) then
			text = text .. target:Name() .. " (" .. target:SteamID() .. ") with " .. attacker:GetActiveWeapon():GetClass()
		else
			text = text .. target:Name() .. " (" .. target:SteamID() .. ")"
		end

		CFG.PostLog(text, "9c4040")
	end)
end

if CFG.Types["kills"] and xChat then
	hook.Add("PlayerDeath", "xChat Logs", function(victim, inflictor, attacker)
		if not (victim:IsPlayer() and attacker:IsPlayer()) then
			return
		end

		local text = attacker:Name() .. " (" .. attacker:SteamID() .. ") killed "
		text = text .. victim:Name() .. " (" .. victim:SteamID() .. ") with " .. inflictor:GetClass()
		CFG.PostLog(text, "ff2e2e")
	end)
end

if CFG.Types["ttt"] and xChat and engine.ActiveGamemode() == "terrortown" then
	hook.Add("TTTEndRound", "xChat Logs", function(result)
		CFG.PostLog("The round has ended")
	end)

	hook.Add("TTTBeginRound", "xChat Logs", function()
		CFG.PostLog("The round has started")
	end)
end