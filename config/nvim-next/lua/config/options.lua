vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

local opt = vim.opt

opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.scrolloff = 8
opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
