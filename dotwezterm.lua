local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font_size = 20
config.color_scheme = 'Catppuccin Mocha'
config.font = wezterm.font 'Monaspace Argon Frozen'
config.window_decorations = "NONE"
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.hide_tab_bar_if_only_one_tab = true
config.enable_wayland = true
config.hide_mouse_cursor_when_typing = false

return config
