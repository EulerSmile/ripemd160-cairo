from utils import FF, GG, HH, II, JJ, GGG, HHH, III, JJJ

func init(buf: felt*, size: felt):
    assert size == 5
    assert [buf] = 0x67452301
    assert [buf + 1] = 0xefcdab89
    assert [buf + 2] = 0x98badcfe
    assert [buf + 3] = 0x10325476
    assert [buf + 4] = 0xc3d2e1f0
end

# the compression function.
# transforms buf using message bytes X[0] through X[15].
func compress{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(buf: felt*, bufsize: felt, dword: felt*, dwsize: felt):
end

# puts bytes from strptr into X and pad out; appends length 
# and finally, compresses the last block(s)
# note: length in bits == 8 * (lswlen + 2^32 mswlen).
# note: there are (lswlen mod 64) bytes left in strptr.
func finish{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(buf: felt*, bufsize: felt, strptr: felt*, lswlen: felt, mswlen: felt):
end
