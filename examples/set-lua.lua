local lparse = require('lparse')
local functions = lua.get_functions_table()
local index = 1

while functions[index] do
  index = index + 1
end

functions[index] = function(slot)
  local n1, n2 = lparse.scan('m m')
  tex.print(tonumber(n1) + tonumber(n2))
end

token.set_lua('calculate', index)
