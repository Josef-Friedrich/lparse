local lparse = require('lparse')
local Scanner = lparse.Scanner

Scanner = lparse.Scanner

return {
  assert_mandatory = function()
    Scanner('m'):assert('{\\fam \\bffam \\tenbf bold}')
  end,

  assert_verbatim = function()
    Scanner('v'):assert('{\\bf bold}')
  end,
}
