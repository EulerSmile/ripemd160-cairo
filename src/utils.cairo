from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.bitwise import bitwise_and, bitwise_or, bitwise_xor
from starkware.cairo.common.math import assert_nn_le, unsigned_div_rem
from pow2 import pow2

const MAX_32_BIT = 2 ** 32
const MAX_BYTE = 2 ** 8

func uint32_not(x : felt) -> (not_x : felt):
    return (not_x=MAX_32_BIT - 1 - x)
end

# collect four bytes into one word.
func BYTES_TO_WORD{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x: felt*) -> (res: felt):
    alloc_locals
    let (local factor_3) = pow2(24)
    let (local factor_2) = pow2(16)
    let (local factor_1) = pow2(8)
    local x3 = [x + 3]
    local x2 = [x + 2]
    local x1 = [x + 1]
    tempvar l1 = x3 * factor_3
    let (_, l1) = unsigned_div_rem(l1, MAX_32_BIT)
    tempvar l2 = x2 * factor_2
    let (_, l2) = unsigned_div_rem(l2, MAX_32_BIT)
    tempvar l3 = x1 * factor_1
    let (_, l3) = unsigned_div_rem(l3, MAX_32_BIT)
    let l4 = [x]
    let (l1_or_l2) = bitwise_or(l1, l2)
    let (l1_or_l2_or_l3) = bitwise_or(l1_or_l2, l3)
    let (res) = bitwise_or(l1_or_l2_or_l3, l4)
    return (res=res)
end

#  ROL(x, n) cyclically rotates x over n bits to the left
# x must be mod of an unsigned 32 bits type and 0 <= n < 32.
func ROL{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x, n) -> (res):
    assert_nn_le(x, 2**32-1)
    assert_nn_le(n, 31)

    let (factor_n) = pow2(n)
    let (factor_diff) = pow2(32-n)
    let x_left_shift = x * factor_n
    let (x_right_shift, _) = unsigned_div_rem(x, factor_diff)
    let (res) = bitwise_or(x_left_shift, x_right_shift)
    let (_, res) = unsigned_div_rem(res, MAX_32_BIT)
    return (res=res)
end

# the five basic functions F(), G(), H(), I(), J().
func F{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(x, y, z) -> (res):
    let (x_xor_y) = bitwise_xor(x, y)
    let (_, x_xor_y) = unsigned_div_rem(x_xor_y, MAX_32_BIT)
    let (res) = bitwise_xor(x_xor_y, z)
    let (_, res) = unsigned_div_rem(res, MAX_32_BIT)
    return (res=res)
end

func G{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(x, y, z) -> (res):
    let (x_and_y) = bitwise_and(x, y)
    let (_, x_and_y) = unsigned_div_rem(x_and_y, MAX_32_BIT)
    let (not_x) = uint32_not(x)
    let (_, not_x) = unsigned_div_rem(not_x, MAX_32_BIT)
    let (not_x_and_z) = bitwise_and(not_x, z)
    let (_, not_x_and_z) = unsigned_div_rem(not_x_and_z, MAX_32_BIT)
    let (res) = bitwise_or(x_and_y, not_x_and_z)
    let (_, res) = unsigned_div_rem(res, MAX_32_BIT)
    return (res=res)
end

func H{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(x, y, z) -> (res):
    let (not_y) = uint32_not(y)
    let (_, not_y) = unsigned_div_rem(not_y, MAX_32_BIT)
    let (x_or_not_y) = bitwise_or(x, not_y)
    let (_, x_or_not_y) = unsigned_div_rem(x_or_not_y, MAX_32_BIT)
    let (res) = bitwise_xor(x_or_not_y, z)
    let (_, res) = unsigned_div_rem(res, MAX_32_BIT)
    return (res=res)
end

func I{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(x, y, z) -> (res):
    let (x_and_z) = bitwise_and(x, z)
    let (_, x_and_z) = unsigned_div_rem(x_and_z, MAX_32_BIT)
    let (not_z) = uint32_not(z)
    let (_, not_z) = unsigned_div_rem(not_z, MAX_32_BIT)
    let (y_and_not_z) = bitwise_and(y, not_z)
    let (_, y_and_not_z) = unsigned_div_rem(y_and_not_z, MAX_32_BIT)
    let (res) = bitwise_or(x_and_z, y_and_not_z)
    let (_, res) = unsigned_div_rem(res, MAX_32_BIT)
    return (res=res)
end

func J{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(x, y, z) -> (res):
    let (not_z) = uint32_not(z)
    let (_, not_z) = unsigned_div_rem(not_z, MAX_32_BIT)
    let (y_or_not_z) = bitwise_or(y, not_z)
    let (_, y_or_not_z) = unsigned_div_rem(y_or_not_z, MAX_32_BIT)
    let (res) = bitwise_xor(x, y_or_not_z)
    let (_, res) = unsigned_div_rem(res, MAX_32_BIT)
    return (res=res)
end

# the ten basic operations FF() through JJJ().
func ROLASE{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, s, e) -> (res):
    let (rol_a_s) = ROL(a, s)
    let (_, res) = unsigned_div_rem(rol_a_s + e, MAX_32_BIT)
    return (res=res)
end

func FF{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (_, b) = unsigned_div_rem(b, MAX_32_BIT)
    let (_, c) = unsigned_div_rem(c, MAX_32_BIT)
    let (_, d) = unsigned_div_rem(d, MAX_32_BIT)
    let (f_bcd) = F(b, c, d)
    let (_, a) = unsigned_div_rem(a + f_bcd, MAX_32_BIT)
    let (_, a) = unsigned_div_rem(a + x, MAX_32_BIT)
    let (_, s) = unsigned_div_rem(s, MAX_32_BIT)
    let (res1) = ROLASE(a, s, e)
    let (res2) = ROL(c, 10)
    return (res1=res1, res2=res2)
end

func GG{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (_, b) = unsigned_div_rem(b, MAX_32_BIT)
    let (_, c) = unsigned_div_rem(c, MAX_32_BIT)
    let (_, d) = unsigned_div_rem(d, MAX_32_BIT)
    let (g_bcd) = G(b, c, d)
    let (_, a) = unsigned_div_rem(a + g_bcd, MAX_32_BIT)
    let (_, a) = unsigned_div_rem(a + x, MAX_32_BIT)
    let (_, a) = unsigned_div_rem(a + 0x5a827999, MAX_32_BIT)
    let (_, s) = unsigned_div_rem(s, MAX_32_BIT)
    let (res1) = ROLASE(a, s, e)
    let (res2) = ROL(c, 10)
    return (res1=res1, res2=res2)
end

func HH{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (_, b) = unsigned_div_rem(b, MAX_32_BIT)
    let (_, c) = unsigned_div_rem(c, MAX_32_BIT)
    let (_, d) = unsigned_div_rem(d, MAX_32_BIT)
    let (h_bcd) = H(b, c, d)
    let (_, a) = unsigned_div_rem(a + h_bcd, MAX_32_BIT)
    let (_, a) = unsigned_div_rem(a + x, MAX_32_BIT)
    let (_, a) = unsigned_div_rem(a + 0x6ed9eba1, MAX_32_BIT)
    let (_, s) = unsigned_div_rem(s, MAX_32_BIT)
    let (res1) = ROLASE(a, s, e)
    let (res2) = ROL(c, 10)
    return (res1=res1, res2=res2)
end

func II{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (_, b) = unsigned_div_rem(b, MAX_32_BIT)
    let (_, c) = unsigned_div_rem(c, MAX_32_BIT)
    let (_, d) = unsigned_div_rem(d, MAX_32_BIT)
    let (i_bcd) = I(b, c, d)
    let (_, a) = unsigned_div_rem(a + i_bcd, MAX_32_BIT)
    let (_, a) = unsigned_div_rem(a + x, MAX_32_BIT)
    let (_, a) = unsigned_div_rem(a + 0x8f1bbcdc, MAX_32_BIT)
    let (_, s) = unsigned_div_rem(s, MAX_32_BIT)
    let (res1) = ROLASE(a, s, e)
    let (res2) = ROL(c, 10)
    return (res1=res1, res2=res2)
end

func JJ{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (_, b) = unsigned_div_rem(b, MAX_32_BIT)
    let (_, c) = unsigned_div_rem(c, MAX_32_BIT)
    let (_, d) = unsigned_div_rem(d, MAX_32_BIT)
    let (j_bcd) = J(b, c, d)
    let (_, a) = unsigned_div_rem(a + j_bcd, MAX_32_BIT)
    let (_, a) = unsigned_div_rem(a + x, MAX_32_BIT)
    let (_, a) = unsigned_div_rem(a + 0xa953fd4e, MAX_32_BIT)
    let (_, s) = unsigned_div_rem(s, MAX_32_BIT)
    let (res1) = ROLASE(a, s, e)
    let (res2) = ROL(c, 10)
    return (res1=res1, res2=res2)
end

func FFF{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (res1, res2) = FF(a, b, c, d, e, x, s)
    return (res1=res1, res2=res2)
end

func GGG{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (g_bcd) = G(b, c, d)
    let (_, a) = unsigned_div_rem(a + g_bcd, MAX_32_BIT)
    let (_, a) = unsigned_div_rem(a + x, MAX_32_BIT)
    let (_, a) = unsigned_div_rem(a + 0x7a6d76e9, MAX_32_BIT)
    let (_, s) = unsigned_div_rem(s, MAX_32_BIT)
    let (res1) = ROLASE(a, s, e)
    let (res2) = ROL(c, 10)
    return (res1=res1, res2=res2)
end

func HHH{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (h_bcd) = H(b, c, d)
    let (_, a) = unsigned_div_rem(a + h_bcd, MAX_32_BIT)
    let (_, a) = unsigned_div_rem(a + x, MAX_32_BIT)
    let (_, a) = unsigned_div_rem(a + 0x6d703ef3, MAX_32_BIT)
    let (_, s) = unsigned_div_rem(s, MAX_32_BIT)
    let (res1) = ROLASE(a, s, e)
    let (res2) = ROL(c, 10)
    return (res1=res1, res2=res2)
end

func III{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (i_bcd) = I(b, c, d)
    let (_, a) = unsigned_div_rem(a + i_bcd, MAX_32_BIT)
    let (_, a) = unsigned_div_rem(a + x, MAX_32_BIT)
    let (_, a) = unsigned_div_rem(a + 0x5c4dd124, MAX_32_BIT)
    let (_, s) = unsigned_div_rem(s, MAX_32_BIT)
    let (res1) = ROLASE(a, s, e)
    let (res2) = ROL(c, 10)
    return (res1=res1, res2=res2)
end

func JJJ{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (j_bcd) = J(b, c, d)
    let (_, a) = unsigned_div_rem(a + j_bcd, MAX_32_BIT)
    let (_, a) = unsigned_div_rem(a + x, MAX_32_BIT)
    let (_, a) = unsigned_div_rem(a + 0x50a28be6, MAX_32_BIT)
    let (_, s) = unsigned_div_rem(s, MAX_32_BIT)
    let (res1) = ROLASE(a, s, e)
    let (res2) = ROL(c, 10)
    return (res1=res1, res2=res2)
end