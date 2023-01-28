local inspect = require('inspect')
local lpeg = require('lpeg')
local V = lpeg.V
local P = lpeg.P
local Set = lpeg.S
local Range = lpeg.R
local CaptureGroup = lpeg.Cg
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
  return { start_delim = a, stop_delim = b }
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
  local function get_type(letter)
    return { argument_type = letter }
  end
  return CaptureSimple(P(letter)) / get_type
end

local T = ArgumentType

local patt = P({
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
  D = T('D') * V('delimiters') * V('default') * Cc({ optional = true }) /
    combine,
  s = T('s') * Cc({ star = true }) / combine,
  delimiter = CaptureSimple(Range('!~')),
  delimiters = V('delimiter') * V('delimiter') / collect_delims,
  whitespace = Set(' \t\n\r'),
  default = P('{') * CaptureSimple((1 - P('}')) ^ 1) * P('}') /
    set_default,
})

local function parse(s)
  return patt:match(s)
end

print(inspect(parse(
  'm r<> R(){default} o d?? O{default} D!!{default} s')))
