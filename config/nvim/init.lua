require('naki.base')
require('naki.keymaps')
require('naki.plugins')

local has = vim.fn.has
local is_mac = has "macunix"
local is_win = has "win32"
local is_wsl = has "wsl"

if is_mac then
  require('naki.macos')
end
if is_win then
  require('naki.windows')
end
if is_wsl then
  require('naki.wsl')
end
