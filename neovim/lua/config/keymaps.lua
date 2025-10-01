-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- backspace
vim.keymap.set("i", "<C-BS>", "<C-o>db", { silent = true, desc = "delete from cursor to ending word" })
vim.keymap.set("i", "<C-Del>", "<C-o>dw", { silent = true, desc = "delete from cursor to beginning word" })

if vim.g.vscode then
  local vscode = require("vscode")
  -- quit/session
  vim.keymap.set("n", "<leader>qq", function()
    vscode.call("workbench.action.quit")
  end, { remap = false })
  -- quickfix
  vim.keymap.set("n", "<leader>ca", function()
    vscode.call("editor.action.quickFix")
  end, { remap = false })
end
