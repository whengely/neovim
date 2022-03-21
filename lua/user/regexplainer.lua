local status_ok, regex = pcall(require, "regexplainer")
if not status_ok then
  vim.notify('regexplainer could not be loaded')
	return
end

local setup = {
  -- 'narrative'
  mode = 'narrative', -- TODO: 'ascii', 'graphical'

  -- automatically show the explainer when the cursor enters a regexp
  auto = false,

  -- Whether to log debug messages
  debug = false,

  -- 'split', 'popup'
  display = 'popup',

  mappings = {
    toggle = 'gR',
    -- examples, not defaults:
    -- show = 'gS',
    -- hide = 'gH',
    show_split = 'gP',
    -- show_popup = 'gU',
  },

  narrative = {
    separator = '\n',
  },
}

regex.setup(setup)

