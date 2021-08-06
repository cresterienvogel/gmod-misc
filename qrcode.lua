--[[
	Creating a QR Code takes some time,
		use some timer or something.
]]

function QRCode(data, size)
	local id = util.Base64Encode(data)

	local exp = string.Explode("\n", id)
	if #exp > 1 then
		id = exp[1]
	end

	size = size and size or 256
	data = string.Explode(" ", data)
	data = table.concat(data, "%20")

	if not file.Exists("qr", "DATA") then
		file.CreateDir("qr")
	end

	if file.Exists("qr/" .. id .. ".png", "DATA") then
		return "data/qr/" .. id .. ".png"
	else
		http.Fetch("https://api.qrserver.com/v1/create-qr-code/?size=" .. size .. "x" .. size .. "&data=" .. data, function(content)
			file.Write("qr/" .. id .. ".png", content)
		end)
		return "data/qr/" .. id .. ".png"
	end
end