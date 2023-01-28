local inspect = require('inspect')
local lpeg = require('lpeg')
local Variable = lpeg.V
local Pattern = lpeg.P
local Set = lpeg.S
local Range = lpeg.R
local CaptureGroup = lpeg.Cg
local CaptureFolding = lpeg.Cf
local CaptureTable = lpeg.Ct
local CaptureConstant = lpeg.Cc
local CaptureSimple = lpeg.C

local function add_result(result, value)
  if not result then
    result = {}
  end
  table.insert(result, value)
  return result
end

local patt = Pattern({
  'init',
  init = Variable('whitespace') ^ 0 *
    CaptureFolding(CaptureTable('') * Variable('list'), add_result),
  list = (Variable('arg') * Variable('whitespace') ^ 1) ^ 1,
  arg = Variable('m') + Variable('o') + Variable('s') + Variable('R'),
  m = Pattern('m') * CaptureConstant({ optional = false }),
  o = Pattern('o') * CaptureConstant({ optional = true }),
  s = Pattern('s') * CaptureConstant({ star = true }),
  R = Pattern('R') * Range('az') * Range('az') *
    CaptureConstant({ required = true }),
  whitespace = Set(' \t\n\r'),
})

local function parse(s)
  return patt:match(s)
end

print(inspect(parse(' o s m m o Rab')))
