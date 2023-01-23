require('busted.runner')()

local lparse = require('lparse')

local Parser = lparse.Parser

describe('Class Parser', function()
  it('Constructor', function()
    local parser = Parser(' s\no  m \to ')
    assert.are.same(parser.args[1], { star = true, optional = true })
  end)

end)
