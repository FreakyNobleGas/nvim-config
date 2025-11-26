require "nvchad.options"

-- add yours here!

-- Set timeout for key sequences (reduces <20> display issue)
vim.opt.timeoutlen = 300 -- ms to wait for mapped sequence

-- Set faster update time for better LSP responsiveness
vim.opt.updatetime = 250 -- ms to wait before triggering CursorHold and writing swap file

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
