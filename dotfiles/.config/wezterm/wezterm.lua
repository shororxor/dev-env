local wezterm = require("wezterm")
local act = wezterm.action

return {
	color_scheme = "Catppuccin Mocha",
	window_background_opacity = 0.9,

	hide_tab_bar_if_only_one_tab = true,
	enable_scroll_bar = false,

	window_padding = {
		left = 3,
		right = 3,
		top = 3,
		bottom = 3,
	},

	use_fancy_tab_bar = false,
	enable_wayland = true,

	keys = {
		-- Split panes
		{
			key = "v",
			mods = "CTRL|ALT",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "h",
			mods = "CTRL|ALT",
			action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		},

		-- Navigate panes
		{
			key = "LeftArrow",
			mods = "ALT",
			action = act.ActivatePaneDirection("Left"),
		},
		{
			key = "RightArrow",
			mods = "ALT",
			action = act.ActivatePaneDirection("Right"),
		},
		{
			key = "UpArrow",
			mods = "ALT",
			action = act.ActivatePaneDirection("Up"),
		},
		{
			key = "DownArrow",
			mods = "ALT",
			action = act.ActivatePaneDirection("Down"),
		},

		-- Resize panes
		{
			key = "LeftArrow",
			mods = "CTRL|SHIFT",
			action = act.AdjustPaneSize({ "Left", 5 }),
		},
		{
			key = "RightArrow",
			mods = "CTRL|SHIFT",
			action = act.AdjustPaneSize({ "Right", 5 }),
		},
		{
			key = "UpArrow",
			mods = "CTRL|SHIFT",
			action = act.AdjustPaneSize({ "Up", 5 }),
		},
		{
			key = "DownArrow",
			mods = "CTRL|SHIFT",
			action = act.AdjustPaneSize({ "Down", 5 }),
		},
		{
			key = "w",
			mods = "CTRL|ALT",
			action = act.CloseCurrentPane({ confirm = true }),
		},
	},
}
