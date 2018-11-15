local string = require("string")
local struct = require("struct")
local lua_struct = require("lua-struct")


function test_numbers_pack()
    for x = 0, 65535, 1 do
        local a = struct.pack(">H", x)
        local b = lua_struct.pack(">H", x)
        assert(a == b, string.format("number is %d ('%s' ~= '%s')", x, a, b))
    end
end


function _test_unpack(...)
    local a = {struct.unpack(...)}
    local b = {lua_struct.unpack(...)}
    assert(#a)
    assert(#b)
    table.remove(a, #a)
    assert(#a == #b, string.format("lenghts are not equal: %d ~= %d", #a, #b))
    for i = 1, #a do
        assert(a[i] == b[i], string.format("%dth value of a is %s, but for b it is %s", i, a[i], b[i]))
    end
end


-- 10 bytes required
function test_message_unpack(msg)
    _test_unpack("<HxxI", msg, 1)
    _test_unpack("<HxxI", msg, 2)
    _test_unpack("<I", msg)
    _test_unpack("<I", msg, 3, 200)
end


test_numbers_pack()
test_message_unpack("0123456789")
test_message_unpack("foobarbazz")

print("struct tests passed")
