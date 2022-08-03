if SERVER then
	util.AddNetworkString("NWTable Broadcast")
	util.AddNetworkString("NWTable Broadcast Tables")

	hook.Add("PlayerInitialSpawn", "NWTable Broadcast", function(pl)
		timer.Simple(1, function()
			if not IsValid(pl) then
				return
			end
			for _, ent in ipairs(ents.GetAll()) do
				if ent.NWTables then
					net.Start("NWTable Broadcast Tables")
						net.WriteEntity(ent)
						net.WriteTable(ent.NWTables)
					net.Send(pl)
				end
			end
		end)
	end)
else
	net.Receive("NWTable Broadcast", function()
		local ent = net.ReadEntity()
		local name = net.ReadString()
		local tbl = net.ReadTable()

		if IsValid(ent) then
			ent.NWTables = ent.NWTables or {}
			ent.NWTables[name] = tbl
		end
	end)

	net.Receive("NWTable Broadcast Tables", function()
		local ent = net.ReadEntity()
		local tbl = net.ReadTable()

		if IsValid(ent) then
			ent.NWTables = tbl
		end
	end)
end

local meta = FindMetaTable("Entity")

function meta:AddNWTableVal(name, value, key)
	self.NWTables = self.NWTables or {}
	if not self.NWTables[name] then
		self.NWTables[name] = {}
	end

	if key then
		self.NWTables[name][key] = value
	else
		table.insert(self.NWTables[name], value)
	end

	if SERVER then
		net.Start("NWTable Broadcast")
			net.WriteEntity(self)
			net.WriteString(name)
			net.WriteTable(self.NWTables[name])
		net.Broadcast()
	end

	return self.NWTables[name]
end

function meta:RemoveNWTableVal(name, value)
	self.NWTables = self.NWTables or {}
	if not self.NWTables[name] then
		self.NWTables[name] = {}
	end

	local key = table.KeyFromValue(self.NWTables[name], value)
	self.NWTables[name][key] = nil

	if SERVER then
		net.Start("NWTable Broadcast")
			net.WriteEntity(self)
			net.WriteString(name)
			net.WriteTable(self.NWTables[name])
		net.Broadcast()
	end

	return self.NWTables[name]
end

function meta:SetNWTable(name, tbl)
	self.NWTables = self.NWTables or {}
	self.NWTables[name] = tbl

	if SERVER then
		net.Start("NWTable Broadcast")
			net.WriteEntity(self)
			net.WriteString(name)
			net.WriteTable(self.NWTables[name])
		net.Broadcast()
	end

	return self.NWTables[name]
end

function meta:GetNWTable(name)
	return (self.NWTables and self.NWTables[name]) or {}
end
