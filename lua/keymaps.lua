-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Keybinds for terminal functions
local terminal_job_id = 0
vim.keymap.set('n', '<leader>st', function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 15)

  terminal_job_id = vim.bo.channel
end)

vim.keymap.set('n', '<leader>ad', function()
  vim.fn.chansend(terminal_job_id, GetAzureFunctionsRunner(true) .. '\r')
end, { desc = 'Run azure function with debug enabled' })

vim.keymap.set('n', '<leader>af', function()
  vim.fn.chansend(terminal_job_id, GetAzureFunctionsRunner(false) .. '\r')
end, { desc = 'Run azure function without debug' })

function GetSpringBootMavenRunner(debug)
  local debug_param = ''
  if debug then
    debug_param = ' -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005"'
  end
  return 'mvn spring-boot:run ' .. debug_param
end

function GetSpringBootGradleRunner(debug)
  local debug_param = ''
  if debug then
    debug_param = ' --debug-jvm'
  end
  return './gradlew bootRun ' .. debug_param
end

function GetAzureFunctionsRunner(debug)
  local debug_param = ''
  if debug then
    debug_param = ' -DenableDebug'
  end
  return 'mvn azure-functions:run ' .. debug_param
end
