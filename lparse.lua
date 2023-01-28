if lpeg == nil then
  lpeg = require('lpeg')
end

---
---@param spec string
---@return Argument[]
local function parse_xparse_spec(spec)
  local V = lpeg.V
  local P = lpeg.P
  local Set = lpeg.S
  local Range = lpeg.R
  local CaptureFolding = lpeg.Cf
  local CaptureTable = lpeg.Ct
  local Cc = lpeg.Cc
  local CaptureSimple = lpeg.C

  local function add_result(result, value)
    if not result then
      result = {}
    end
    table.insert(result, value)
    return result
  end

  local function collect_delims(a, b)
    return { init_delim = a, end_delim = b }
  end

  local function set_default(a)
    return { default = a }
  end

  local function combine(...)
    local args = { ... }

    local output = {}

    for _, arg in ipairs(args) do
      if type(arg) ~= 'table' then
        arg = {}
      end

      for key, value in pairs(arg) do
        output[key] = value
      end

    end

    return output
  end

  local function ArgumentType(letter)
    local function get_type(l)
      return { argument_type = l }
    end
    return CaptureSimple(P(letter)) / get_type
  end

  local T = ArgumentType

  local pattern = P({
    'init',
    init = V('whitespace') ^ 0 *
      CaptureFolding(CaptureTable('') * V('list'), add_result),

    list = (V('arg') * V('whitespace') ^ 1) ^ 1 * V('arg') ^ -1,

    arg = V('m') + V('r') + V('R') + V('o') + V('d') + V('O') + V('D') +
      V('s'),

    m = T('m') / combine,

    r = T('r') * V('delimiters') / combine,

    R = T('R') * V('delimiters') * V('default') / combine,

    o = T('o') * Cc({ optional = true }) / combine,

    d = T('d') * V('delimiters') * Cc({ optional = true }) / combine,

    O = T('O') * V('default') * Cc({ optional = true }) / combine,

    D = T('D') * V('delimiters') * V('default') *
      Cc({ optional = true }) / combine,

    s = T('s') * Cc({ star = true }) / combine,

    delimiter = CaptureSimple(Range('!~')),

    delimiters = V('delimiter') * V('delimiter') / collect_delims,

    whitespace = Set(' \t\n\r'),

    default = P('{') * CaptureSimple((1 - P('}')) ^ 1) * P('}') /
      set_default,
  })

  return pattern:match(spec)

end

---
---Scan for an optional argument.
---
---@param init_delim? string # The character that marks the beginning of an optional argument (by default `[`).
---@param end_delim? string # The character that marks the end of an optional argument (by default `]`).
---
---@return string|nil # The string that was enclosed by the delimiters. The delimiters themselves are not returned.
local function scan_oarg(init_delim, end_delim)
  if init_delim == nil then
    init_delim = '['
  end
  if end_delim == nil then
    end_delim = ']'
  end

  ---
  ---@param t Token
  ---
  ---@return string
  local function convert_token_to_string(t)
    if t.index ~= nil then
      return utf8.char(t.index)
    else
      return '\\' .. t.csname
    end
  end

  local delimiter_stack = 0

  local function get_next_char()
    local t = token.get_next()
    local char = convert_token_to_string(t)
    if char == init_delim then
      delimiter_stack = delimiter_stack + 1
    end

    if char == end_delim then
      delimiter_stack = delimiter_stack - 1
    end
    return char, t
  end

  local char, t = get_next_char()

  if char == init_delim then
    local output = {}

    char, t = get_next_char()

    -- “while” better than “repeat ... until”: The end_delimiter is
    -- included in the result output.
    while not (char == end_delim and delimiter_stack == 0) do
      table.insert(output, char)
      char, t = get_next_char()
    end
    return table.concat(output, '')
  else
    token.put_next(t)
  end
end

---@class Argument
---@field argument_type? string
---@field optional? boolean
---@field init_delim? string
---@field end_delim? string
---@field dest? string
---@field star? boolean
---@field default? string

---@class Parser
---@field args Argument[]
---@field result any[]
local Parser = {}
---@private
Parser.__index = Parser

function Parser:new(spec)
  local parser = {}
  setmetatable(parser, Parser)
  parser.spec = spec
  parser.args = parse_xparse_spec(spec)
  parser.result = parser:parse(parser.args)
  return parser
end

---@return any[]
function Parser:parse()
  local result = {}
  local index = 1
  for _, arg in pairs(self.args) do
    if arg.star then
      result[index] = token.scan_keyword('*')
    elseif arg.optional then
      result[index] = scan_oarg()
    else
      result[index] = token.scan_argument(false)
    end
    index = index + 1
  end
  return result
end

---@private
function Parser:set_result(...)
  self.result = { ... }
end

function Parser:assert(...)
  local arguments = { ... }
  for index, arg in ipairs(arguments) do
    assert(self.result[index] == arg, string.format(
      'Argument at index %d doesn’t match: “%s” != “%s”',
      index, self.result[index], arg))
  end
end

---@return Parser
local function create_parser(spec)
  return Parser:new(spec)
end

return { Parser = create_parser, scan_oarg = scan_oarg }
