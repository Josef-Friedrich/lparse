local lparse = require('lparse')
local Parser = lparse.Parser

Parser = lparse.Parser

return {
  assert_mandatory = function()
    Parser('m'):assert('{\\fam \\bffam \\tenbf bold}')
  end,

  assert_verbatim = function()
    Parser('v'):assert('{\\bf bold}')
  end,
}
