local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Split planes
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>", opts) -- Vertical Svlit
vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>", opts) -- Horizontal Split

-- Scroll horizontally
vim.keymap.set("n", "<leader>ll", "60zl", { remap = true })
vim.keymap.set("n", "<leader>hh", "60zh", { remap = true })

-- Re-highlight line after indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- chatgpt keybinds
vim.keymap.set("n", "<leader>gt", "<cmd>ChatGPT<CR>", { remap = true })
vim.keymap.set("n", "<leader>gr", ":ChatGPTRun ", { remap = true })
vim.keymap.set("v", "<leader>gr", ":ChatGPTRun ", { remap = true })
vim.keymap.set("n", "<leader>gec", "<cmd>ChatGPTRun explain_code<CR>", { remap = true })
vim.keymap.set("v", "<leader>gec", "<cmd>ChatGPTRun explain_code<CR>", { remap = true })

-- Disable arrowkeys
vim.keymap.set("n", "<Up>", "<Nop>", opts)
vim.keymap.set("n", "<Left", "<Nop>", opts)
vim.keymap.set("n", "<Right>", "<Nop>", opts)
vim.keymap.set("n", "<Down>", "<Nop>", opts)
vim.keymap.set("v", "<Up>", "<Nop>", opts)
vim.keymap.set("v", "<Left", "<Nop>", opts)
vim.keymap.set("v", "<Right>", "<Nop>", opts)
vim.keymap.set("v", "<Down>", "<Nop>", opts)
vim.keymap.set("i", "<Up>", "<Nop>", opts)
vim.keymap.set("i", "<Left", "<Nop>", opts)
vim.keymap.set("i", "<Right>", "<Nop>", opts)
vim.keymap.set("i", "<Down>", "<Nop>", opts)
