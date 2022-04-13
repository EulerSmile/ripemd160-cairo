from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.bitwise import bitwise_and, bitwise_or, bitwise_not, bitwise_xor
from starkware.cairo.common.math import assert_nn_le, unsigned_div_rem
from pow2 import pow2

# collect four bytes into one word.
func BYTES_TO_WORD{bitwise_ptr : BitwiseBuiltin*}(x: felt*) -> (res):
    let (factor_3) = pow2(24)
    let (factor_2) = pow2(16)
    let (factor_1) = pow2(8)
    let l1 = [x + 3] * factor_3
    let l2 = [x + 2] * factor_2
    let l3 = [x + 1] * factor_1
    let l4 = [x]
    let (l1_or_l2) = bitwise_or(l1, l2)
    let (l1_or_l2_or_l3) = bitwise_or(l1_or_l2, l3)
    let (res) = bitwise_or(l1_or_l2_or_l3, l4)
    return (res=res)
end

#  ROL(x, n) cyclically rotates x over n bits to the left
# x must be of an unsigned 32 bits type and 0 <= n < 32.
func ROL{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(x, n) -> (res):
    assert_nn_le(x, 2**32-1)
    assert_nn_le(n, 31)

    let (factor_n) = pow2(n)
    let (factor_diff) = pow2(32-n)
    let x_left_shift = x * factor_n
    let (x_right_shift, _) = unsigned_div_rem(x, factor_diff)
    let (res) = bitwise_or(x_left_shift, x_right_shift)
    return (res=res)
end

# the five basic functions F(), G(), H(), I(), J().
func F{bitwise_ptr : BitwiseBuiltin*}(x, y, z) -> (res):
    let (x_xor_y) = bitwise_xor(x, y)
    let (res) = bitwise_xor(x_xor_y, z)
    return (res=res)
end

func G{bitwise_ptr : BitwiseBuiltin*}(x, y, z) -> (res):
    let (x_and_y) = bitwise_and(x, y)
    let (not_x) = bitwise_not(x)
    let (not_x_and_z) = bitwise_and(not_x, z)
    let (res) = bitwise_or(x_and_y, not_x_and_z)
    return (res=res)
end

func H{bitwise_ptr : BitwiseBuiltin*}(x, y, z) -> (res):
    let (not_y) = bitwise_not(y)
    let (x_or_not_y) = bitwise_or(x, not_y)
    let (res) = bitwise_xor(x_or_not_y, z)
    return (res=res)
end

func I{bitwise_ptr : BitwiseBuiltin*}(x, y, z) -> (res):
    let (x_and_z) = bitwise_and(x, z)
    let (not_z) = bitwise_not(z)
    let (y_and_not_z) = bitwise_and(y, not_z)
    let (res) = bitwise_or(x_and_z, y_and_not_z)
    return (res=res)
end

func J{bitwise_ptr : BitwiseBuiltin*}(x, y, z) -> (res):
    let (not_z) = bitwise_not(z)
    let (y_or_not_z) = bitwise_or(y, not_z)
    let (res) = bitwise_xor(x, y_or_not_z)
    return (res=res)
end

# the ten basic operations FF() through JJJ().
func ROLASE{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, s, e) -> (res):
    let (rol_a_s) = ROL(a, s)
    let res = rol_a_s + e
    return (res=res)
end

func FF{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (f_bcd) = F(b, c, d)
    let a = a + f_bcd + x
    let (res1) = ROLASE(a, s, e)
    let (res2) = ROL(c, 10)
    return (res1=res1, res2=res2)
end

func GG{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (g_bcd) = G(b, c, d)
    let a = a + g_bcd + x + 0x5a827999
    let (res1) = ROLASE(a, s, e)
    let (res2) = ROL(c, 10)
    return (res1=res1, res2=res2)
end

func HH{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (h_bcd) = H(b, c, d)
    let a = a + h_bcd + x + 0x6ed9eba1
    let (res1) = ROLASE(a, s, e)
    let (res2) = ROL(c, 10)
    return (res1=res1, res2=res2)
end

func II{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (i_bcd) = I(b, c, d)
    let a = a + i_bcd + x + 0x8f1bbcdc
    let (res1) = ROLASE(a, s, e)
    let (res2) = ROL(c, 10)
    return (res1=res1, res2=res2)
end

func JJ{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (j_bcd) = J(b, c, d)
    let a = a + j_bcd + x + 0xa953fd4e
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
    let a = a + g_bcd + x + 0x7a6d76e9
    let (res1) = ROLASE(a, s, e)
    let (res2) = ROL(c, 10)
    return (res1=res1, res2=res2)
end

func HHH{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (h_bcd) = H(b, c, d)
    let a = a + h_bcd + x + 0x6d703ef3
    let (res1) = ROLASE(a, s, e)
    let (res2) = ROL(c, 10)
    return (res1=res1, res2=res2)
end

func III{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (i_bcd) = I(b, c, d)
    let a = a + i_bcd + x + 0x5c4dd124
    let (res1) = ROLASE(a, s, e)
    let (res2) = ROL(c, 10)
    return (res1=res1, res2=res2)
end

func JJJ{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(a, b, c, d, e, x, s) -> (res1, res2):
    let (j_bcd) = J(b, c, d)
    let a = a + j_bcd + x + 0x50a28be6
    let (res1) = ROLASE(a, s, e)
    let (res2) = ROL(c, 10)
    return (res1=res1, res2=res2)
end