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
	self.NWTables = self.NWTables or {}
	if not self.NWTables[name] then
		self.NWTables[name] = {}
	end

	if key ~= nil or value ~= nil then
		if key then
			self.NWTables[name][key] = value
		else
			table.insert(self.NWTables[name], value)
		end
	end

	if SERVER then
		net.Start("NWTable Broadcast")
			net.WriteEntity(self)
			net.WriteString(name)
			net.WriteTable(self.NWTables[name])
		net.Broadcast()
	end
end

function meta:GetNWTable(name)
	return (self.NWTables and self.NWTables[name]) or {}
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
