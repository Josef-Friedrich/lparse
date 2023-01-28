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

  it('o', function()
    assert.are.same(parse('o'),
      { { argument_type = 'o', optional = true } })
  end)

  it('d', function()
    assert.are.same(parse('d<>'), {
      {
        argument_type = 'd',
        optional = true,
        end_delim = '>',
        init_delim = '<',
      },
    })
  end)

  it('O', function()
    assert.are.same(parse('O{default}'), {
      { argument_type = 'O', optional = true, default = 'default' },
    })
  end)

  it('D', function()
    assert.are.same(parse('D<>{ default }'), {
      {
        argument_type = 'D',
        optional = true,
        default = ' default ',
        end_delim = '>',
        init_delim = '<',
      },
    })
  end)

  it('s', function()
    assert.are.same(parse('s'), {
      {
        argument_type = 's',
        star = true
      },
    })
  end)

end)
