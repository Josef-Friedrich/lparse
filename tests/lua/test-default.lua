require('busted.runner')()

local lparse = require('lparse')

local parse = lparse.parse_spec

describe('Function parse_spec', function()
  it('Constructor', function()
    assert.are.same(parse(' s\no \t m '), {
      { argument_type = 's', star = true },
      { argument_type = 'o', optional = true },
      { argument_type = 'm' },
    })
  end)

end)
