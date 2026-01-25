-- return {
--   {
--     "miikanissi/modus-themes.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--       -- vim.o.background = "auto" -- 핵심
--       vim.cmd.colorscheme("modus")
--     end,
--   },
-- }

return {
  -- 1. tokyonight 설정: 기본 스타일을 storm으로 고정
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm", -- 여기서 'storm'을 지정하면 colorscheme tokyonight 시 storm이 뜹니다.
      transparent = false,
    },
  },

  -- 2. modus-themes 설정
  {
    "miikanissi/modus-themes.nvim",
    priority = 1000,
  },
}
