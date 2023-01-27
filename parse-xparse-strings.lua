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

local function add(acc, newvalue)
  print(newvalue)
end

local patt = Pattern({
  'init',
  init = Variable('whitespace') ^ 0 * CaptureFolding(CaptureTable('') * Variable('list'), add),
  list = (Variable('arg') * Variable('whitespace') ^ 0) ^ 1,
  arg = Variable('marg') + Variable('oarg'),
  marg = Pattern('m') * CaptureConstant('marg'),
  oarg = Pattern('o') * CaptureConstant('oarg'),
  whitespace = Set(' \t\n\r'),
})

local function parse(s)
  lpeg.match(patt, s)
end

parse(' o m m  ')

-- + (Variable('whitespace') ^ 0) ^ -1)

-- CaptureFolding(add)
