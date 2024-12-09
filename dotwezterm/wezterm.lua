local wezterm = require('wezterm')
local config = {}
local theme = require('lua/rose-pine').moon
config.colors = theme.colors()
config.window_frame = theme.window_frame()
config.font = wezterm.font_with_fallback({
  {family = 'SF Mono', weight = 'Medium'},
  -- add glyphs here
})
config.font_size = 17
config.enable_wayland = true
return config
