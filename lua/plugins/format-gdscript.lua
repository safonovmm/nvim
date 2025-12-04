return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters_by_ft.gdscript = { "gdformat" }

    opts.formatters = opts.formatters or {}
    opts.formatters.gdformat = {
      -- Mason installs into its bin dir; just call `gdformat` and let PATH handle it
      command = "gdformat",
      args = { "-" }, -- read from stdin
      stdin = true,
    }
  end,
}
