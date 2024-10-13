local wezterm = require("wezterm")
local action = wezterm.action
local mux = wezterm.mux

local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono NFM" },
	{
		family = "JetBrainsMono NFM",
		assume_emoji_presentation = true,
	},
})

config.font_size = 15

config.enable_tab_bar = false
config.window_decorations = "RESIZE"

config.force_reverse_video_cursor = true

config.default_prog = { "wsl", "--cd", "~" }

wezterm.on('gui-startup', function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

config.keys = {
	{
		key = 'k',
		mods = 'CTRL',
		action = action.Multiple {
			action.ClearScrollback 'ScrollbackAndViewport',
			action.SendKey { key = 'L', mods = 'CTRL' },
		},
	},
}

config.colors = {
	foreground = "#dcd7ba",
	background = "#1f1f28",

	cursor_bg = "#c8c093",
	cursor_fg = "#c8c093",
	cursor_border = "#c8c093",

	selection_fg = "#c8c093",
	selection_bg = "#2d4f67",

	scrollbar_thumb = "#16161d",
	split = "#16161d",

	ansi = { "#090618", "#c34043", "#76946a", "#c0a36e", "#7e9cd8", "#957fb8", "#6a9589", "#c8c093" },
	brights = { "#727169", "#e82424", "#98bb6c", "#e6c384", "#7fb4ca", "#938aa9", "#7aa89f", "#dcd7ba" },
	indexed = { [16] = "#ffa066", [17] = "#ff5d62" },
}


return config
