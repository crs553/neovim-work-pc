return {
  'saghen/blink.cmp',

  dependencies = 'rafamadriz/friendly-snippets',

  version = '*',

  opts = {

    keymap = { preset = 'default' },

    fuzzy = {
      prebuilt_binaries = {
        download = false,
      },
    },

    appearance = {
      nerd_font_variant = 'mono'
    },

    -- experimental signature help support
    signature = { enabled = true }

  },
}
