-- lua/plugins/godot.lua
return {
  -- LSP for GDScript (Godot)
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      require("lspconfig")["gdscript"].setup({
        name = "godot",
        cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
      })
    end,
  },

  -- DAP for Godot
  {
    "mfussenegger/nvim-dap",
    optional = true, -- LazyVim already loads this; we just extend it
    config = function()
      local dap = require("dap")

      dap.adapters.godot = {
        type = "server",
        host = "127.0.0.1",
        port = 6006,
      }

      dap.configurations.gdscript = {
        {
          type = "godot",
          request = "launch",
          name = "Launch scene",
          project = "${workspaceFolder}",
          launch_scene = true,
        },
      }

      -- keymaps (same as your old config)
      local widgets = require("dap.ui.widgets")

      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { desc = desc })
      end

      map("n", "<F5>", function()
        dap.continue()
      end, "DAP continue")

      map("n", "<F10>", function()
        dap.step_over()
      end, "DAP step over")

      map("n", "<F11>", function()
        dap.step_into()
      end, "DAP step into")

      map("n", "<F12>", function()
        dap.step_out()
      end, "DAP step out")

      map("n", "<Leader>b", function()
        dap.toggle_breakpoint()
      end, "DAP toggle breakpoint")

      map("n", "<Leader>B", function()
        dap.set_breakpoint()
      end, "DAP set breakpoint")

      map("n", "<Leader>lp", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end, "DAP log point")

      map("n", "<Leader>dr", function()
        dap.repl.open()
      end, "DAP REPL")

      map("n", "<Leader>dl", function()
        dap.run_last()
      end, "DAP run last")

      map({ "n", "v" }, "<Leader>dh", function()
        widgets.hover()
      end, "DAP hover")

      map({ "n", "v" }, "<Leader>dp", function()
        widgets.preview()
      end, "DAP preview")

      map("n", "<Leader>df", function()
        widgets.centered_float(widgets.frames)
      end, "DAP frames")

      map("n", "<Leader>ds", function()
        widgets.centered_float(widgets.scopes)
      end, "DAP scopes")
    end,
  },
}
