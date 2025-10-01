return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {},
  },
  {
    "cschierig/linenumbers.nvim",
    event = "BufEnter",
    config = true,
  },
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    keys = {
      {
        "<leader>uW",
        "<cmd>ASToggle<cr>",
        mode = "n",
        desc = "Toggle Auto Save",
      },
    },
    opts = {
      callbacks = {
        before_saving = function()
          print(vim.b.autoformat)

          vim.b.temp_autoformat = vim.b.autoformat
          print(vim.b.temp_autoformat)
          vim.b.autoformat = false
        end,
        after_saving = function()
          vim.b.autoformat = false
          -- vim.b.autoformat = vim.b.temp_autoformat
        end,
      },
    },
  },
  {
    "chrisgrieser/nvim-rip-substitute",
    keys = {
      {
        "g/",
        function()
          require("rip-substitute").sub()
        end,
        mode = { "n", "x" },
        desc = "Rip Substitute",
      },
    },
  },
  {
    "augustocdias/gatekeeper.nvim",
    event = "VeryLazy",
    opts = {
      exclude = {
        vim.fn.expand("~/.config/nvim"),
      },
    },
  },
  { "gbprod/yanky.nvim", opts = {
    system_clipboard = { sync_with_ring = false },
  } },
}
