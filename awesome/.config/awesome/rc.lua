-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

local xrandr = require("xrandr")

-- Enable touch-to-click
local function enableTouchToClick()
	-- Use xinput command to find the touchpad device ID
	local touchpadID = io.popen("xinput list | grep -i touchpad | grep -o 'id=[0-9]\\+' | cut -d= -f2"):read("*n")

	-- If touchpad ID is found, enable tapping for left click
	if touchpadID then
		os.execute("xinput set-prop " .. touchpadID .. " 'libinput Tapping Enabled' 1")
	else
		print("Touchpad not found!")
	end
end

-- Call the function to enable touch-to-click
enableTouchToClick()

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "wezterm"
browser = "firefox"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
local mods = {
	super = "Mod4",
	alt = "Mod1",
	shift = "Shift",
	control = "Control",
}

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	-- awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	-- awful.layout.suit.fair,
	-- awful.layout.suit.fair.horizontal,
	-- awful.layout.suit.spiral,
	-- awful.layout.suit.spiral.dwindle,
	-- awful.layout.suit.max,
	-- awful.layout.suit.max.fullscreen,
	-- awful.layout.suit.magnifier,
	-- awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

if has_fdo then
	mymainmenu = freedesktop.menu.build({
		before = { menu_awesome },
		after = { menu_terminal },
	})
else
	mymainmenu = awful.menu({
		items = {
			menu_awesome,
			{ "Debian", debian.menu.Debian_menu.Debian },
			menu_terminal,
		},
	})
end

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("  %a %b %d, %I:%M %p ")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	})

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
	})

	-- https://github.com/deficient/battery-widget
	local battery_widget = require("battery-widget")

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "bottom", screen = s })

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			mylauncher,
			s.mytaglist,
			s.mypromptbox,
		},
		s.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			-- mykeyboardlayout,
			battery_widget({
				ac = "AC",
				adapter = "BAT0",
				ac_prefix = {
					{ 25, "warning" },
					{ 50, "1/4 charged " },
					{ 75, "2/4 charged " },
					{ 95, "3/4 charged " },
					{ 100, "charged " },
				},
				battery_prefix = {
					{ 25, "#--- " },
					{ 50, "##-- " },
					{ 75, "###- " },
					{ 100, "#### " },
				},
				percent_colors = {
					{ 25, "red" },
					{ 50, "orange" },
					{ 999, "white" },
				},
				listen = true,
				timeout = 10,
				widget_text = "${AC_BAT}${color_on}${percent}%${color_off}",
				-- widget_font = "Deja Vu Sans Mono 16",
				tooltip_text = "Battery ${state}${time_est}\nCapacity: ${capacity_percent}%",
				alert_threshold = 5,
				alert_timeout = 0,
				alert_title = "Low battery !",
				alert_text = "${AC_BAT}${time_est}",
				alert_icon = "~/Downloads/low_battery_icon.png",
				warn_full_battery = false,
				full_battery_icon = "~/Downloads/full_battery_icon.png",
			}),
			wibox.widget.systray(),
			mytextclock,
			s.mylayoutbox,
		},
	})
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
	awful.button({}, 3, function()
		mymainmenu:toggle()
	end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings

-- Monitor screen setup support
-- Pressing C-r repeatedly will cycle through the available screen configurations
globalkeys = gears.table.join(
	awful.key({ mods.super }, "r", function()
		xrandr.xrandr()
	end),

	-- awful.key({ mods.super, mods.shift }, "r", function()
	-- 	awful.spawn("autorandr --change")
	-- end, { description = "Change display configuration", group = "hotkeys" }),
	awful.key({ mods.super, mods.control }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ mods.super, mods.shift }, "Escape", awesome.quit, { description = "quit awesome", group = "awesome" }),
	awful.key({ mods.super }, "/", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),

	-- Standard programs
	awful.key({ mods.super }, "Return", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "launcher" }),

	awful.key({ mods.super }, "b", function()
		awful.spawn(browser)
	end, { description = "open a browser", group = "launcher" }),

	-- TODO: I'm not going to use these I think
	-- awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	-- awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
	-- awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

	-- Default client focus
	awful.key({ mods.alt }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),
	awful.key({ mods.alt }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),
	-- Default client swap
	awful.key({ mods.alt, mods.shift }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),
	awful.key({ mods.alt, mods.shift }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),

	-- Focus by direction
	awful.key({ mods.super }, "j", function()
		awful.client.focus.global_bydirection("down")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus down", group = "client" }),
	awful.key({ mods.super }, "k", function()
		awful.client.focus.global_bydirection("up")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus up", group = "client" }),
	awful.key({ mods.super }, "h", function()
		awful.client.focus.global_bydirection("left")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus left", group = "client" }),
	awful.key({ mods.super }, "l", function()
		awful.client.focus.global_bydirection("right")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus right", group = "client" }),

	-- Focus screen
	awful.key({ mods.super }, "f", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),
	awful.key({ mods.super }, "s", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),

	-- TODO: error
	-- awful.key({ mods.super }, "w", function()
	-- 	awful.util.mymainmenu:show()
	-- end, { description = "show main menu", group = "awesome" }),

	-- Swap by direction
	awful.key({ mods.super, mods.shift }, "j", function()
		awful.client.swap.global_bydirection("down")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus down", group = "client" }),
	awful.key({ mods.super, mods.shift }, "k", function()
		awful.client.swap.global_bydirection("up")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus up", group = "client" }),
	awful.key({ mods.super, mods.shift }, "h", function()
		awful.client.swap.global_bydirection("left")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus left", group = "client" }),
	awful.key({ mods.super, mods.shift }, "l", function()
		awful.client.swap.global_bydirection("right")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus right", group = "client" }),

	awful.key(
		{ mods.super },
		"u",
		awful.client.urgent.jumpto,
		{ description = "jump to urgent client", group = "client" }
	),
	awful.key({ mods.super }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "go back", group = "client" }),

	-- TODO: I set these keybinds to something else, remap these?
	-- awful.key({ modkey }, "l", function()
	-- 	awful.tag.incmwfact(0.05)
	-- end, { description = "increase master width factor", group = "layout" }),
	-- awful.key({ modkey }, "h", function()
	-- 	awful.tag.incmwfact(-0.05)
	-- end, { description = "decrease master width factor", group = "layout" }),

	-- TODO: I set these keybinds to something else, remap these?
	-- awful.key({ modkey, "Shift" }, "h", function()
	-- 	awful.tag.incnmaster(1, nil, true)
	-- end, { description = "increase the number of master clients", group = "layout" }),
	-- awful.key({ modkey, "Shift" }, "l", function()
	-- 	awful.tag.incnmaster(-1, nil, true)
	-- end, { description = "decrease the number of master clients", group = "layout" }),

	-- TODO: I set these keybinds to something else, remap these?
	-- awful.key({ modkey, "Control" }, "h", function()
	-- 	awful.tag.incncol(1, nil, true)
	-- end, { description = "increase the number of columns", group = "layout" }),
	-- awful.key({ modkey, "Control" }, "l", function()
	-- 	awful.tag.incncol(-1, nil, true)
	-- end, { description = "decrease the number of columns", group = "layout" }),

	-- Cycle the layout options
	awful.key({ modkey }, "space", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),
	awful.key({ modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),

	-- TODO: do I want to minimize clients?
	-- awful.key({ modkey, "Control" }, "n", function()
	-- 	local c = awful.client.restore()
	-- 	-- Focus restored client
	-- 	if c then
	-- 		c:emit_signal("request::activate", "key.unminimize", { raise = true })
	-- 	end
	-- end, { description = "restore minimized", group = "client" }),

	-- Prompt
	awful.key({ mods.super, mods.shift }, "r", function()
		awful.screen.focused().mypromptbox:run()
	end, { description = "run prompt", group = "launcher" }),

	awful.key({ mods.super }, "c", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "lua execute prompt", group = "awesome" }),

	-- Menubar
	awful.key({ mods.super }, "p", function()
		menubar.show()
	end, { description = "show the menubar", group = "launcher" })
)

clientkeys = gears.table.join(
	-- TODO: This makes other windows around it an easter egg hunt.
	-- awful.key({ mods.super }, "f", function(c)
	-- 	c.fullscreen = not c.fullscreen
	-- 	c:raise()
	-- end, { description = "toggle fullscreen", group = "client" }),

	-- Close the window
	awful.key({ mods.super }, "x", function(c)
		c:kill()
	end, { description = "close", group = "client" }),

	-- Make a window float
	awful.key(
		{ mods.super, mods.control },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),

	-- Send to the master window
	awful.key({ mods.super, mods.shift }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),

	-- Move over to screen
	awful.key({ mods.super }, "g", function(c)
		c:move_to_screen()
	end, { description = "send to screen", group = "client" })

	-- TODO: Is this useful?
	-- awful.key({ mods.super }, "t", function(c)
	-- 	c.ontop = not c.ontop
	-- end, { description = "toggle keep on top", group = "client" }),

	-- TODO: Minimizing is confusing, the window dissapears??
	-- awful.key({ mods.super }, "n", function(c)
	-- 	-- The client currently has the input focus, so it cannot be
	-- 	-- minimized, since minimized clients can't have the focus.
	-- 	c.minimized = true
	-- end, { description = "minimize", group = "client" }),
	-- awful.key({ mods.super }, "m", function(c)
	-- 	c.maximized = not c.maximized
	-- 	c:raise()
	-- end, { description = "(un)maximize", group = "client" }),
	-- awful.key({ mods.super, mods.control }, "m", function(c)
	-- 	c.maximized_vertical = not c.maximized_vertical
	-- 	c:raise()
	-- end, { description = "(un)maximize vertically", group = "client" }),
	-- awful.key({ mods.super, mods.shift }, "m", function(c)
	-- 	c.maximized_horizontal = not c.maximized_horizontal
	-- 	c:raise()
	-- end, { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	-- Add titlebars to normal clients and dialogs
	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = false } },

	-- Set Firefox to always map on the tag named "2" on screen 1.
	-- { rule = { class = "Firefox" },
	--   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c):setup({
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{ -- Middle
			{ -- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{ -- Right
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	})
end)

-- Merge tags with same name on different screens
-- https://github.com/awesomeWM/awesome/issues/1382#issuecomment-289378695
tag.connect_signal("request::screen", function(t)
	local fallback_tag = nil

	-- find tag with same name on any other screen
	for other_screen in screen do
		if other_screen ~= t.screen then
			fallback_tag = awful.tag.find_by_name(other_screen, t.name)
			if fallback_tag ~= nil then
				break
			end
		end
	end

	-- no tag with same name exists, chose random one
	if fallback_tag == nil then
		fallback_tag = awful.tag.find_fallback()
	end

	-- delete the tag and move it to other screen
	t:delete(fallback_tag, true)
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)
-- }}}
