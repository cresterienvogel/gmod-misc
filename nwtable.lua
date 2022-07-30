if SERVER then
	util.AddNetworkString("NWTable Broadcast")
	util.AddNetworkString("NWTable Broadcast Table")
else
	net.Receive("NWTable Broadcast", function()
		local ent = net.ReadEntity()
		local name = net.ReadString()
		local tbl = net.ReadTable()

		ent.NWTables = ent.NWTables or {}
		ent.NWTables[name] = tbl
	end)

	net.Receive("NWTable Broadcast Table", function()
		local ent = net.ReadEntity()
		local tbl = net.ReadTable()

		ent.NWTables = tbl
	end)
end

local meta = FindMetaTable("Entity")
function meta:SetNWTable(name, value, key)
	local tbl = {}
	if key then
		tbl[key] = value
	else
		table.insert(tbl, value)
	end

	self.NWTables = self.NWTables or {}
	self.NWTables[name] = tbl

	if SERVER then
		net.Start("NWTable Broadcast")
			net.WriteEntity(self)
			net.WriteString(name)
			net.WriteTable(tbl)
		net.Broadcast()
	end
end

function meta:GetNWTable(name)
	return self.NWTables[name] or {}
end

hook.Add("PlayerInitialSpawn", "NWTable Broadcast", function(pl)
	for _, ent in ipairs(ents.GetAll()) do
		if ent.NWTables then
			net.Start("NWTable Broadcast Table")
				net.WriteEntity(ent)
				net.WriteTable(ent.NWTables)
			net.Send(pl)
		end
	end
end)