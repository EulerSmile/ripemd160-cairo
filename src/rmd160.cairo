from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_nn_le
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor, bitwise_or
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from starkware.cairo.common.dict import dict_new, dict_read, dict_write, dict_squash
from utils import MAX_32_BIT, FF, GG, HH, II, JJ, FFF, GGG, HHH, III, JJJ
from pow2 import pow2

func absorb_data{range_check_ptr, bitwise_ptr : BitwiseBuiltin*, dict_ptr : DictAccess*}(data: felt*, len: felt, index: felt):
    if index - len == 0:
        return ()
    end

    let (index_4, _) = unsigned_div_rem(index, 4)
    let (index_and_3) = bitwise_and(index, 3)
    let (_, factor) = unsigned_div_rem(8 * index_and_3, MAX_32_BIT)
    let (factor) = pow2(factor)
    let (_, tmp) = unsigned_div_rem([data] * factor, MAX_32_BIT)
    let (old_val) = dict_read{dict_ptr=dict_ptr}(index_4)
    let (val) = bitwise_xor(old_val, tmp)
    let (_, val) = unsigned_div_rem(val, MAX_32_BIT)
    dict_write{dict_ptr=dict_ptr}(index_4, val)

    absorb_data{dict_ptr=dict_ptr}(data+1, len, index+1)
    return ()
end

func dict_to_array{dict_ptr : DictAccess*}(arr: felt*, len):
    if len == 0:
        return ()
    end

    let index = len - 1
    let (x) = dict_read{dict_ptr=dict_ptr}(index)
    assert arr[index] = x

    dict_to_array{dict_ptr=dict_ptr}(arr, len - 1)

    return ()
end

# init buf to magic constants.
func init(buf: felt*, size: felt):
    assert size = 5
    assert [buf] = 0x67452301
    assert [buf + 1] = 0xefcdab89
    assert [buf + 2] = 0x98badcfe
    assert [buf + 3] = 0x10325476
    assert [buf + 4] = 0xc3d2e1f0

    return ()
end

# the compression function.
# transforms buf using message bytes X[0] through X[15].
func compress{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(buf: felt*, bufsize: felt, x: felt*, xlen: felt) -> (res: felt*, rsize: felt):
    alloc_locals

    assert bufsize = 5
    assert xlen = 16

    # all element is in [0, 2^32).
    let (_, aa) = unsigned_div_rem([buf], MAX_32_BIT)
    let (_, bb) = unsigned_div_rem([buf + 1], MAX_32_BIT)
    let (_, cc) = unsigned_div_rem([buf + 2], MAX_32_BIT)
    let (_, dd) = unsigned_div_rem([buf + 3], MAX_32_BIT)
    let (_, ee) = unsigned_div_rem([buf + 4], MAX_32_BIT)
    local aaa = aa
    local bbb = bb
    local ccc = cc
    local ddd = dd
    local eee = ee

    # round 1
    let (local aa, local cc) = FF(aa, bb, cc, dd, ee, [x +  0],11)
    let (local ee, local bb) = FF(ee, aa, bb, cc, dd, [x +  1],14)
    let (local dd, local aa) = FF(dd, ee, aa, bb, cc, [x +  2],15)
    let (local cc, local ee) = FF(cc, dd, ee, aa, bb, [x +  3],12)
    let (local bb, local dd) = FF(bb, cc, dd, ee, aa, [x +  4], 5)
    let (local aa, local cc) = FF(aa, bb, cc, dd, ee, [x +  5], 8)
    let (local ee, local bb) = FF(ee, aa, bb, cc, dd, [x +  6], 7)
    let (local dd, local aa) = FF(dd, ee, aa, bb, cc, [x +  7], 9)
    let (local cc, local ee) = FF(cc, dd, ee, aa, bb, [x +  8],11)
    let (local bb, local dd) = FF(bb, cc, dd, ee, aa, [x +  9],13)
    let (local aa, local cc) = FF(aa, bb, cc, dd, ee, [x + 10],14)
    let (local ee, local bb) = FF(ee, aa, bb, cc, dd, [x + 11],15)
    let (local dd, local aa) = FF(dd, ee, aa, bb, cc, [x + 12], 6)
    let (local cc, local ee) = FF(cc, dd, ee, aa, bb, [x + 13], 7)
    let (local bb, local dd) = FF(bb, cc, dd, ee, aa, [x + 14], 9)
    let (local aa, local cc) = FF(aa, bb, cc, dd, ee, [x + 15], 8)

    # round 2
    let (local ee, local bb) = GG(ee, aa, bb, cc, dd, [x +  7], 7)
    let (local dd, local aa) = GG(dd, ee, aa, bb, cc, [x +  4], 6)
    let (local cc, local ee) = GG(cc, dd, ee, aa, bb, [x + 13], 8)
    let (local bb, local dd) = GG(bb, cc, dd, ee, aa, [x +  1],13)
    let (local aa, local cc) = GG(aa, bb, cc, dd, ee, [x + 10],11)
    let (local ee, local bb) = GG(ee, aa, bb, cc, dd, [x +  6], 9)
    let (local dd, local aa) = GG(dd, ee, aa, bb, cc, [x + 15], 7)
    let (local cc, local ee) = GG(cc, dd, ee, aa, bb, [x +  3],15)
    let (local bb, local dd) = GG(bb, cc, dd, ee, aa, [x + 12], 7)
    let (local aa, local cc) = GG(aa, bb, cc, dd, ee, [x +  0],12)
    let (local ee, local bb) = GG(ee, aa, bb, cc, dd, [x +  9],15)
    let (local dd, local aa) = GG(dd, ee, aa, bb, cc, [x +  5], 9)
    let (local cc, local ee) = GG(cc, dd, ee, aa, bb, [x +  2],11)
    let (local bb, local dd) = GG(bb, cc, dd, ee, aa, [x + 14], 7)
    let (local aa, local cc) = GG(aa, bb, cc, dd, ee, [x + 11],13)
    let (local ee, local bb) = GG(ee, aa, bb, cc, dd, [x +  8],12)

    # round 3
    let (local dd, local aa) = HH(dd, ee, aa, bb, cc, [x +  3],11)
    let (local cc, local ee) = HH(cc, dd, ee, aa, bb, [x + 10],13)
    let (local bb, local dd) = HH(bb, cc, dd, ee, aa, [x + 14], 6)
    let (local aa, local cc) = HH(aa, bb, cc, dd, ee, [x +  4], 7)
    let (local ee, local bb) = HH(ee, aa, bb, cc, dd, [x +  9],14)
    let (local dd, local aa) = HH(dd, ee, aa, bb, cc, [x + 15], 9)
    let (local cc, local ee) = HH(cc, dd, ee, aa, bb, [x +  8],13)
    let (local bb, local dd) = HH(bb, cc, dd, ee, aa, [x +  1],15)
    let (local aa, local cc) = HH(aa, bb, cc, dd, ee, [x +  2],14)
    let (local ee, local bb) = HH(ee, aa, bb, cc, dd, [x +  7], 8)
    let (local dd, local aa) = HH(dd, ee, aa, bb, cc, [x +  0],13)
    let (local cc, local ee) = HH(cc, dd, ee, aa, bb, [x +  6], 6)
    let (local bb, local dd) = HH(bb, cc, dd, ee, aa, [x + 13], 5)
    let (local aa, local cc) = HH(aa, bb, cc, dd, ee, [x + 11],12)
    let (local ee, local bb) = HH(ee, aa, bb, cc, dd, [x +  5], 7)
    let (local dd, local aa) = HH(dd, ee, aa, bb, cc, [x + 12], 5)

    # round 4
    let (local cc, local ee) = II(cc, dd, ee, aa, bb, [x +  1],11)
    let (local bb, local dd) = II(bb, cc, dd, ee, aa, [x +  9],12)
    let (local aa, local cc) = II(aa, bb, cc, dd, ee, [x + 11],14)
    let (local ee, local bb) = II(ee, aa, bb, cc, dd, [x + 10],15)
    let (local dd, local aa) = II(dd, ee, aa, bb, cc, [x +  0],14)
    let (local cc, local ee) = II(cc, dd, ee, aa, bb, [x +  8],15)
    let (local bb, local dd) = II(bb, cc, dd, ee, aa, [x + 12], 9)
    let (local aa, local cc) = II(aa, bb, cc, dd, ee, [x +  4], 8)
    let (local ee, local bb) = II(ee, aa, bb, cc, dd, [x + 13], 9)
    let (local dd, local aa) = II(dd, ee, aa, bb, cc, [x +  3],14)
    let (local cc, local ee) = II(cc, dd, ee, aa, bb, [x +  7], 5)
    let (local bb, local dd) = II(bb, cc, dd, ee, aa, [x + 15], 6)
    let (local aa, local cc) = II(aa, bb, cc, dd, ee, [x + 14], 8)
    let (local ee, local bb) = II(ee, aa, bb, cc, dd, [x +  5], 6)
    let (local dd, local aa) = II(dd, ee, aa, bb, cc, [x +  6], 5)
    let (local cc, local ee) = II(cc, dd, ee, aa, bb, [x +  2],12)

    # round 5
    let (local bb, local dd) = JJ(bb, cc, dd, ee, aa, [x +  4], 9)
    let (local aa, local cc) = JJ(aa, bb, cc, dd, ee, [x +  0],15)
    let (local ee, local bb) = JJ(ee, aa, bb, cc, dd, [x +  5], 5)
    let (local dd, local aa) = JJ(dd, ee, aa, bb, cc, [x +  9],11)
    let (local cc, local ee) = JJ(cc, dd, ee, aa, bb, [x +  7], 6)
    let (local bb, local dd) = JJ(bb, cc, dd, ee, aa, [x + 12], 8)
    let (local aa, local cc) = JJ(aa, bb, cc, dd, ee, [x +  2],13)
    let (local ee, local bb) = JJ(ee, aa, bb, cc, dd, [x + 10],12)
    let (local dd, local aa) = JJ(dd, ee, aa, bb, cc, [x + 14], 5)
    let (local cc, local ee) = JJ(cc, dd, ee, aa, bb, [x +  1],12)
    let (local bb, local dd) = JJ(bb, cc, dd, ee, aa, [x +  3],13)
    let (local aa, local cc) = JJ(aa, bb, cc, dd, ee, [x +  8],14)
    let (local ee, local bb) = JJ(ee, aa, bb, cc, dd, [x + 11],11)
    let (local dd, local aa) = JJ(dd, ee, aa, bb, cc, [x +  6], 8)
    let (local cc, local ee) = JJ(cc, dd, ee, aa, bb, [x + 15], 5)
    let (local bb, local dd) = JJ(bb, cc, dd, ee, aa, [x + 13], 6)

    # parallel round 1
    let (local aaa, local ccc) = JJJ(aaa, bbb, ccc, ddd, eee, [x +  5], 8)
    let (local eee, local bbb) = JJJ(eee, aaa, bbb, ccc, ddd, [x + 14], 9)
    let (local ddd, local aaa) = JJJ(ddd, eee, aaa, bbb, ccc, [x +  7], 9)
    let (local ccc, local eee) = JJJ(ccc, ddd, eee, aaa, bbb, [x +  0],11)
    let (local bbb, local ddd) = JJJ(bbb, ccc, ddd, eee, aaa, [x +  9],13)
    let (local aaa, local ccc) = JJJ(aaa, bbb, ccc, ddd, eee, [x +  2],15)
    let (local eee, local bbb) = JJJ(eee, aaa, bbb, ccc, ddd, [x + 11],15)
    let (local ddd, local aaa) = JJJ(ddd, eee, aaa, bbb, ccc, [x +  4], 5)
    let (local ccc, local eee) = JJJ(ccc, ddd, eee, aaa, bbb, [x + 13], 7)
    let (local bbb, local ddd) = JJJ(bbb, ccc, ddd, eee, aaa, [x +  6], 7)
    let (local aaa, local ccc) = JJJ(aaa, bbb, ccc, ddd, eee, [x + 15], 8)
    let (local eee, local bbb) = JJJ(eee, aaa, bbb, ccc, ddd, [x +  8],11)
    let (local ddd, local aaa) = JJJ(ddd, eee, aaa, bbb, ccc, [x +  1],14)
    let (local ccc, local eee) = JJJ(ccc, ddd, eee, aaa, bbb, [x + 10],14)
    let (local bbb, local ddd) = JJJ(bbb, ccc, ddd, eee, aaa, [x +  3],12)
    let (local aaa, local ccc) = JJJ(aaa, bbb, ccc, ddd, eee, [x + 12], 6)

    # parallel round 2
    let (local eee, local bbb) = III(eee, aaa, bbb, ccc, ddd, [x +  6], 9)
    let (local ddd, local aaa) = III(ddd, eee, aaa, bbb, ccc, [x + 11],13)
    let (local ccc, local eee) = III(ccc, ddd, eee, aaa, bbb, [x +  3],15)
    let (local bbb, local ddd) = III(bbb, ccc, ddd, eee, aaa, [x +  7], 7)
    let (local aaa, local ccc) = III(aaa, bbb, ccc, ddd, eee, [x +  0],12)
    let (local eee, local bbb) = III(eee, aaa, bbb, ccc, ddd, [x + 13], 8)
    let (local ddd, local aaa) = III(ddd, eee, aaa, bbb, ccc, [x +  5], 9)
    let (local ccc, local eee) = III(ccc, ddd, eee, aaa, bbb, [x + 10],11)
    let (local bbb, local ddd) = III(bbb, ccc, ddd, eee, aaa, [x + 14], 7)
    let (local aaa, local ccc) = III(aaa, bbb, ccc, ddd, eee, [x + 15], 7)
    let (local eee, local bbb) = III(eee, aaa, bbb, ccc, ddd, [x +  8],12)
    let (local ddd, local aaa) = III(ddd, eee, aaa, bbb, ccc, [x + 12], 7)
    let (local ccc, local eee) = III(ccc, ddd, eee, aaa, bbb, [x +  4], 6)
    let (local bbb, local ddd) = III(bbb, ccc, ddd, eee, aaa, [x +  9],15)
    let (local aaa, local ccc) = III(aaa, bbb, ccc, ddd, eee, [x +  1],13)
    let (local eee, local bbb) = III(eee, aaa, bbb, ccc, ddd, [x +  2],11)

    # parallel round 3
    let (local ddd, local aaa) = HHH(ddd, eee, aaa, bbb, ccc, [x + 15], 9)
    let (local ccc, local eee) = HHH(ccc, ddd, eee, aaa, bbb, [x +  5], 7)
    let (local bbb, local ddd) = HHH(bbb, ccc, ddd, eee, aaa, [x +  1],15)
    let (local aaa, local ccc) = HHH(aaa, bbb, ccc, ddd, eee, [x +  3],11)
    let (local eee, local bbb) = HHH(eee, aaa, bbb, ccc, ddd, [x +  7], 8)
    let (local ddd, local aaa) = HHH(ddd, eee, aaa, bbb, ccc, [x + 14], 6)
    let (local ccc, local eee) = HHH(ccc, ddd, eee, aaa, bbb, [x +  6], 6)
    let (local bbb, local ddd) = HHH(bbb, ccc, ddd, eee, aaa, [x +  9],14)
    let (local aaa, local ccc) = HHH(aaa, bbb, ccc, ddd, eee, [x + 11],12)
    let (local eee, local bbb) = HHH(eee, aaa, bbb, ccc, ddd, [x +  8],13)
    let (local ddd, local aaa) = HHH(ddd, eee, aaa, bbb, ccc, [x + 12], 5)
    let (local ccc, local eee) = HHH(ccc, ddd, eee, aaa, bbb, [x +  2],14)
    let (local bbb, local ddd) = HHH(bbb, ccc, ddd, eee, aaa, [x + 10],13)
    let (local aaa, local ccc) = HHH(aaa, bbb, ccc, ddd, eee, [x +  0],13)
    let (local eee, local bbb) = HHH(eee, aaa, bbb, ccc, ddd, [x +  4], 7)
    let (local ddd, local aaa) = HHH(ddd, eee, aaa, bbb, ccc, [x + 13], 5)

    # parallel round 4
    let (local ccc, local eee) = GGG(ccc, ddd, eee, aaa, bbb, [x +  8],15)
    let (local bbb, local ddd) = GGG(bbb, ccc, ddd, eee, aaa, [x +  6], 5)
    let (local aaa, local ccc) = GGG(aaa, bbb, ccc, ddd, eee, [x +  4], 8)
    let (local eee, local bbb) = GGG(eee, aaa, bbb, ccc, ddd, [x +  1],11)
    let (local ddd, local aaa) = GGG(ddd, eee, aaa, bbb, ccc, [x +  3],14)
    let (local ccc, local eee) = GGG(ccc, ddd, eee, aaa, bbb, [x + 11],14)
    let (local bbb, local ddd) = GGG(bbb, ccc, ddd, eee, aaa, [x + 15], 6)
    let (local aaa, local ccc) = GGG(aaa, bbb, ccc, ddd, eee, [x +  0],14)
    let (local eee, local bbb) = GGG(eee, aaa, bbb, ccc, ddd, [x +  5], 6)
    let (local ddd, local aaa) = GGG(ddd, eee, aaa, bbb, ccc, [x + 12], 9)
    let (local ccc, local eee) = GGG(ccc, ddd, eee, aaa, bbb, [x +  2],12)
    let (local bbb, local ddd) = GGG(bbb, ccc, ddd, eee, aaa, [x + 13], 9)
    let (local aaa, local ccc) = GGG(aaa, bbb, ccc, ddd, eee, [x +  9],12)
    let (local eee, local bbb) = GGG(eee, aaa, bbb, ccc, ddd, [x +  7], 5)
    let (local ddd, local aaa) = GGG(ddd, eee, aaa, bbb, ccc, [x + 10],15)
    let (local ccc, local eee) = GGG(ccc, ddd, eee, aaa, bbb, [x + 14], 8)

    # parallel round 5
    let (local bbb, local ddd) = FFF(bbb, ccc, ddd, eee, aaa, [x + 12], 8)
    let (local aaa, local ccc) = FFF(aaa, bbb, ccc, ddd, eee, [x + 15], 5)
    let (local eee, local bbb) = FFF(eee, aaa, bbb, ccc, ddd, [x + 10],12)
    let (local ddd, local aaa) = FFF(ddd, eee, aaa, bbb, ccc, [x +  4], 9)
    let (local ccc, local eee) = FFF(ccc, ddd, eee, aaa, bbb, [x +  1],12)
    let (local bbb, local ddd) = FFF(bbb, ccc, ddd, eee, aaa, [x +  5], 5)
    let (local aaa, local ccc) = FFF(aaa, bbb, ccc, ddd, eee, [x +  8],14)
    let (local eee, local bbb) = FFF(eee, aaa, bbb, ccc, ddd, [x +  7], 6)
    let (local ddd, local aaa) = FFF(ddd, eee, aaa, bbb, ccc, [x +  6], 8)
    let (local ccc, local eee) = FFF(ccc, ddd, eee, aaa, bbb, [x +  2],13)
    let (local bbb, local ddd) = FFF(bbb, ccc, ddd, eee, aaa, [x + 13], 6)
    let (local aaa, local ccc) = FFF(aaa, bbb, ccc, ddd, eee, [x + 14], 5)
    let (local eee, local bbb) = FFF(eee, aaa, bbb, ccc, ddd, [x +  0],15)
    let (local ddd, local aaa) = FFF(ddd, eee, aaa, bbb, ccc, [x +  3],13)
    let (local ccc, local eee) = FFF(ccc, ddd, eee, aaa, bbb, [x +  9],11)
    let (local bbb, local ddd) = FFF(bbb, ccc, ddd, eee, aaa, [x + 11],11)

    # combine results
    let (local res: felt*) = alloc()
    let (_, res0) = unsigned_div_rem([buf + 1] + cc + ddd, MAX_32_BIT)
    let (_, res1) = unsigned_div_rem([buf + 2] + dd + eee, MAX_32_BIT)
    let (_, res2) = unsigned_div_rem([buf + 3] + ee + aaa, MAX_32_BIT)
    let (_, res3) = unsigned_div_rem([buf + 4] + aa + bbb, MAX_32_BIT)
    let (_, res4) = unsigned_div_rem([buf + 0] + bb + ccc, MAX_32_BIT)
    assert res[0] = res0
    assert res[1] = res1
    assert res[2] = res2
    assert res[3] = res3
    assert res[4] = res4

    return (res=res, rsize=5)
end

# puts bytes from data into X and pad out; appends length 
# and finally, compresses the last block(s)
# note: length in bits == 8 * (dsize + 2^32 mswlen).
# note: there are (dsize mod 64) bytes left in data.
func finish{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(buf: felt*, bufsize: felt, data: felt*, dsize: felt, mswlen: felt) -> (res: felt*, rsize: felt):
    alloc_locals
    let (x) = default_dict_new(0)
    let start = x

    # put data into x.
    let (local len) = bitwise_and(dsize, 63)
    let (_, len) = unsigned_div_rem(len, MAX_32_BIT)
    absorb_data{dict_ptr=x}(data, len, 0)

    # append the bit m_n == 1.
    let (index_4, _) = unsigned_div_rem(dsize, 4)
    let (local index) = bitwise_and(index_4, 15)
    let (_, index) = unsigned_div_rem(index, MAX_32_BIT)
    let (old_val) = dict_read{dict_ptr=x}(index)
    let (local ba_3) = bitwise_and(dsize, 3)
    let (_, factor) = unsigned_div_rem(8 * ba_3 + 7, MAX_32_BIT)
    let (tmp) = pow2(factor)
    let (local val) = bitwise_xor(old_val, tmp)
    dict_write{dict_ptr=x}(index, val)

    # length goes to next block.
    let (_, val) = unsigned_div_rem(dsize * 8, MAX_32_BIT)
    let (pow2_29) = pow2(29)
    let (factor, _) = unsigned_div_rem(dsize, pow2_29)
    let len_8 = mswlen * 8
    let (val_15) = bitwise_or(factor, len_8)
    let (_, val_15) = unsigned_div_rem(val_15, MAX_32_BIT)

    let (next_block) = is_nn_le(55, len)
    if next_block == 1:
        let (local arr_x: felt*) = alloc()
        dict_to_array{dict_ptr=x}(arr_x, 16)
        let (buf, bufsize) = compress(buf, bufsize, arr_x, 16)
        # reset dict to all 0.
        let (x) = default_dict_new(0)

        dict_write{dict_ptr=x}(14, val)
        dict_write{dict_ptr=x}(15, val_15)

        let (local arr_x: felt*) = alloc()
        dict_to_array{dict_ptr=x}(arr_x, 16)
        let (_, _) = dict_squash{range_check_ptr=range_check_ptr}(start, x)
        let (res, rsize) = compress(buf, bufsize, arr_x, 16)
        return (res=res, rsize=rsize)
    else:
        dict_write{dict_ptr=x}(14, val)
        dict_write{dict_ptr=x}(15, val_15)

        let (local arr_x: felt*) = alloc()
        dict_to_array{dict_ptr=x}(arr_x, 16)
        let (_, _) = dict_squash{range_check_ptr=range_check_ptr}(start, x)
        let (res, rsize) = compress(buf, bufsize, arr_x, 16)
        return (res=res, rsize=rsize)
    end
end