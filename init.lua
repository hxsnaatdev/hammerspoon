--hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
--hs.alert.show("Hello world! ")
--end)

hs.hotkey.bind({ "cmd", "shift" }, "return", function()
	hs.application.open("WezTerm")
end)

hs.hotkey.bind({ "cmd", "shift" }, "F", function()
	hs.application.open("Firefox")
end)

hs.hotkey.bind({ "cmd", "shift" }, "W", function()
	hs.application.open("WhatsApp")
end)

hs.hotkey.bind({ "cmd", "shift" }, "O", function()
	hs.application.open("Obsidian")
end)

hs.hotkey.bind({ "cmd", "shift" }, "C", function()
	hs.application.open("Claude")
end)

local function toggleWifi()
	local current = hs.wifi.interfaceDetails()
	local newState = not (current and current.power)
	hs.wifi.setPower(newState)
	hs.notify.new({ title = "WiFi", informativeText = newState and "Enabled" or "Disabled" }):send()
end

local function toggleBluetooth()
	-- Use blueutil's built-in toggle, then read back state.
	local _, ok = hs.execute("/opt/homebrew/bin/blueutil --power toggle 2>&1")
	local stateOut, stateOk = hs.execute("/opt/homebrew/bin/blueutil --power 2>&1")
	local state = (stateOut or ""):match("^%s*(%d+)")
	if ok and stateOk and (state == "0" or state == "1") then
		hs.notify.new({ title = "Bluetooth", informativeText = (state == "1") and "Enabled" or "Disabled" }):send()
	end
end

hs.hotkey.bind({ "cmd", "shift" }, "B", function()
	toggleBluetooth()
end)

hs.hotkey.bind({ "cmd", "shift" }, ";", function()
	toggleWifi()
end)
