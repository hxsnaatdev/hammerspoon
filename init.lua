--hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
--hs.alert.show("Hello world! ")
--end)
local hs = hs
pcall(require, "hs.ipc")

hs.application.enableSpotlightForNameSearches(true)

hs.hotkey.bind({ "cmd", "shift" }, "return", function()
	hs.application.open("wezterm")
end)

local function focusOrLaunchApp(bundleID, appName)
	local app = hs.application.get(bundleID)
	if app then
		app:activate(true)
		local window = app:mainWindow()
		if window then
			window:unminimize()
			window:focus()
		end
	else
		hs.application.launchOrFocus(appName)
	end
end

hs.hotkey.bind({ "cmd", "shift" }, "F", function()
	focusOrLaunchApp("org.nixos.firefox", "Firefox")
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

local obsidianClaudePath = "/Users/ariz/SecondBrain/hammerspoon/obsidian_claude.lua"
if hs.fs.attributes(obsidianClaudePath) then
	dofile(obsidianClaudePath)
end
