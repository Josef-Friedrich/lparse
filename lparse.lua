---
---Scan for an optional argument.
---
---@param initial_delimiter? string # The character that marks the beginning of an optional argument (by default `[`).
---@param end_delimiter? string # The character that marks the end of an optional argument (by default `]`).
---
---@return string|nil # The string that was enclosed by the delimiters. The delimiters themselves are not returned.
local function scan_oarg(initial_delimiter, end_delimiter)
    if initial_delimiter == nil then initial_delimiter = '[' end

    if end_delimiter == nil then end_delimiter = ']' end

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

    local function get_next_char()
        local t = token.get_next()
        return convert_token_to_string(t), t
    end

    local char, t = get_next_char()

    if char == initial_delimiter then
        local oarg = {}
        char = get_next_char()
        while char ~= end_delimiter do
            table.insert(oarg, char)
            char = get_next_char()
        end
        local result = table.concat(oarg, '')
        print(result)
        return result
    else
        print('no argument')
        token.put_next(t)
    end
end

return {scan_oarg = scan_oarg}
