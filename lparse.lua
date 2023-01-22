---
---Scan for an optional argument.
---
---@param initial_delimiter? string # The character that marks the beginning of an optional argument (by default `[`).
---@param end_delimiter? string # The character that marks the end of an optional argument (by default `]`).
---
---@return string|nil # The string that was enclosed by the delimiters. The delimiters themselves are not returned.
local function scan_oarg(initial_delimiter,
  end_delimiter)
  if initial_delimiter == nil then
    initial_delimiter = '['
  end
  if end_delimiter == nil then
    end_delimiter = ']'
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
    if char == initial_delimiter then
      delimiter_stack = delimiter_stack + 1
    end

    if char == end_delimiter then
      delimiter_stack = delimiter_stack - 1
    end
    return char, t
  end

  local char, t = get_next_char()

  if char == initial_delimiter then
    local output = {}

    char, t = get_next_char()

    --“while” better than “repeat ... until”: The end_delimiter is
    --included in the result output.
    while not (char == end_delimiter and delimiter_stack == 0) do
      table.insert(output, char)
      char, t = get_next_char()
    end

    local result = table.concat(output, '')
    print(result)
    return result
  else
    print('no argument')
    token.put_next(t)
  end
end

return { scan_oarg = scan_oarg }
