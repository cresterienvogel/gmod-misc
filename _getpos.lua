concommand.Add("_getpos", function()
	local pos = LocalPlayer():GetPos()
	print("Vector(" .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. "),")
end)