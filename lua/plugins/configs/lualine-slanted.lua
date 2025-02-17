-- check out: https://github.com/nvim-lualine/lualine.nvim



-- colors adjusted to solarized, check
 -- https://github.com/maxmx03/solarized.nvim/blob/main/lua/solarized/palette/solarized-light.lua
local colors = {
  red = '#DC322F',
  blue = '#268BD2',
  magenta = '#D33682',
  orange = '#CB4B16',
  green = '#859900',
  white = '#fbf3db',
  grey = '#a0a1a7',
  black = '#383a42',
}

local custom_theme = {
  normal = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.black, bg = colors.grey },
    c = { fg = colors.black, bg = colors.white },
    z = { fg = colors.white, bg = colors.black },
  },
  insert = { a = { fg = colors.black, bg = colors.green } },
  visual = { a = { fg = colors.black, bg = colors.magenta } },
  replace = { a = { fg = colors.white, bg = colors.orange } },
  command = { a = { fg = colors.white, bg = colors.orange } },
  inactive = {
    a = { fg = colors.white, bg = colors.grey },
    b = { fg = colors.grey, bg = colors.white },
    c = { fg = colors.grey, bg = colors.white },
    z = { fg = colors.white, bg = colors.grey },
  },
}

local empty = require('lualine.component'):extend()
function empty:draw(default_highlight)
  self.status = ''
  self.applied_separator = ''
  self:apply_highlights(default_highlight)
  self:apply_section_separators()
  return self.status
end

-- auto-hide when terminal gets narrow
local hide_in_width80 = function()
  return vim.fn.winwidth(0) > 80
end
local hide_in_width60 = function()
  return vim.fn.winwidth(0) > 60
end

-- Put proper separators and gaps between components in sections
local function process_sections(sections)
  for name, section in pairs(sections) do
    local left = name:sub(9, 10) < 'x'
    for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
      table.insert(section, pos * 2, { empty, color = { fg = colors.white, bg = colors.white } })
    end
    for id, comp in ipairs(section) do
      if type(comp) ~= 'table' then
        comp = { comp }
        section[id] = comp
      end
      comp.separator = left and { right = '' } or { left = '' }
    end
  end
  return sections
end

local function search_result()
  if vim.v.hlsearch == 0 then
    return ''
  end
  local last_search = vim.fn.getreg('/')
  if not last_search or last_search == '' then
    return ''
  end
  local searchcount = vim.fn.searchcount { maxcount = 9999 }
  return last_search .. '(' .. searchcount.current .. '/' .. searchcount.total .. ')'
end

local function modified()
  if vim.bo.modified then
    return '+'
  elseif vim.bo.modifiable == false or vim.bo.readonly == true then
    return '-'
  end
  return ''
end


require('lualine').setup {
  options = {
    theme = custom_theme,
    component_separators = '',
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      'NvimTree',
      'starter',
    },
    refresh = {
      statusline = 1000,
    },
  },

  -- Lualine has sections as shown below.
  -- +-------------------------------------------------+
  -- | a | b | c                             x | y | z |
  -- +-------------------------------------------------+
  sections = process_sections {
    lualine_a = { { 'mode', cond = hide_in_width80, } },
    lualine_b = {
      { modified,
        cond = function()
          return not vim.bo.readonly
        end,
        color = { bg = colors.red },
      },
      {
        '%r',
        cond = function()
          return vim.bo.readonly
        end,
        color = { bg = colors.red },
      },
      { 'branch', cond = hide_in_width80, },
      -- { 'diff',
      --   colored = true,
      --   diff_color = {
      --     added = { fg = colors.green },
      --     modified = { fg = colors.orange },
      --     removed = { fg = colors.red },
      --   },
      --   cond = hide_in_width80,
      -- },
      {
        'diagnostics',
        source = { 'nvim' },
        sections = { 'error' },
        diagnostics_color = { error = { bg = colors.red, fg = colors.white } },
        cond = hide_in_width80,
      },
      {
        'diagnostics',
        source = { 'nvim' },
        sections = { 'warn' },
        diagnostics_color = { warn = { bg = colors.orange, fg = colors.white } },
        cond = hide_in_width80,
      },
      -- {
      --   '%w',
      --   cond = function()
      --     return vim.wo.previewwindow
      --   end,
      -- },
    },
    lualine_c = {
      {
        'filename',
        file_status = false, -- displays file status (readonly status, modified status)
        path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
      },
    },
    lualine_x = {},
    -- lualine_y = { search_result, 'filetype' },
    lualine_y = {
      function()
        local msg = '%y No Lsp'
        local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
        local clients = vim.lsp.get_clients()
        if next(clients) == nil then
          return msg
        end
        for _, client in ipairs(clients) do
          local filetypes = client.config.filetypes
          if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            if client.name ~= 'null-ls' then
              return '%y ' .. client.name
            end
          end
        end
        return msg
      end,
    },
    lualine_z = {
      {
        'progress',
        fmt = function(progress)
          local spinners = { '󰚀', '󰪞', '󰪠', '󰪡', '󰪢', '󰪣', '󰪤', '󰚀' }

          if string.match(progress, '%a+') then
            return spinners[1] .. ' %l/%L:%c'
            -- return progress
          end

          local p = tonumber(string.match(progress, '%d+'))
          if p ~= nil then
            local index = math.floor(p / (100 / #spinners)) + 1
            return spinners[index] .. ' %l/%L:%c'
          end
        end,
        cond = hide_in_width60,
      },
    },
  },
  inactive_sections = {
    lualine_c = { '%f %y %m' },
    lualine_x = {},
  },
  tabline = {},
  extensions = {},
}
