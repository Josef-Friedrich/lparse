require('busted.runner')()

local lparse = require('lparse')

local parse_spec = lparse.utils.parse_spec

describe('Function: parse_spec', function()
  it('Constructor', function()
    assert.are.same(parse_spec(' s\no \t m '), {
      { argument_type = 's', star = true },
      { argument_type = 'o', optional = true },
      { argument_type = 'm' },
    })
  end)

  it('m', function()
    assert.are.same(parse_spec('m'), { { argument_type = 'm' } })
  end)

  it('r', function()
    assert.are.same(parse_spec('r<>'), {
      { argument_type = 'r', end_delim = '>', init_delim = '<' },
    })
  end)

  it('R', function()
    assert.are.same(parse_spec('R<>{default}'), {
      {
        argument_type = 'R',
        end_delim = '>',
        init_delim = '<',
        default = 'default',
      },
    })
  end)

  it('v', function()
    assert.are.same(parse_spec('v'), {
      {
        argument_type = 'v',
        verbatim = true,
      },
    })
  end)

  it('o', function()
    assert.are.same(parse_spec('o'),
      { { argument_type = 'o', optional = true } })
  end)

  it('d', function()
    assert.are.same(parse_spec('d<>'), {
      {
        argument_type = 'd',
        optional = true,
        end_delim = '>',
        init_delim = '<',
      },
    })
  end)

  it('O', function()
    assert.are.same(parse_spec('O{default}'), {
      { argument_type = 'O', optional = true, default = 'default' },
    })
  end)

  it('D', function()
    assert.are.same(parse_spec('D<>{ default }'), {
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
    assert.are
      .same(parse_spec('s'), { { argument_type = 's', star = true } })
  end)

  it('t', function()
    assert.are
      .same(parse_spec('t+'), { { argument_type = 't', token = '+' } })
  end)

end)
