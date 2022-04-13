from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_nn_le
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor, bitwise_or
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.dict import dict_new, dict_read, dict_write, dict_squash
from utils import FF, GG, HH, II, JJ, FFF, GGG, HHH, III, JJJ
from pow2 import pow2

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
func compress{bitwise_ptr : BitwiseBuiltin*, range_check_ptr, dict_ptr: DictAccess*}(buf: felt*, bufsize: felt) -> (res: felt*, rsize: felt):
    alloc_locals
    local res: felt*

    assert bufsize = 5

    let aa = [buf]
    let bb = [buf + 1]
    let cc = [buf + 2]
    let dd = [buf + 3]
    let ee = [buf + 4]
    let aaa = aa
    let bbb = bb
    let ccc = cc
    let ddd = dd
    let eee = ee
    let (x0) = dict_read{dict_ptr=dict_ptr}(0)
    let (x1) = dict_read{dict_ptr=dict_ptr}(1)
    let (x2) = dict_read{dict_ptr=dict_ptr}(2)
    let (x3) = dict_read{dict_ptr=dict_ptr}(3)
    let (x4) = dict_read{dict_ptr=dict_ptr}(4)
    let (x5) = dict_read{dict_ptr=dict_ptr}(5)
    let (x6) = dict_read{dict_ptr=dict_ptr}(6)
    let (x7) = dict_read{dict_ptr=dict_ptr}(7)
    let (x8) = dict_read{dict_ptr=dict_ptr}(8)
    let (x9) = dict_read{dict_ptr=dict_ptr}(9)
    let (x10) = dict_read{dict_ptr=dict_ptr}(10)
    let (x11) = dict_read{dict_ptr=dict_ptr}(11)
    let (x12) = dict_read{dict_ptr=dict_ptr}(12)
    let (x13) = dict_read{dict_ptr=dict_ptr}(13)
    let (x14) = dict_read{dict_ptr=dict_ptr}(14)
    let (x15) = dict_read{dict_ptr=dict_ptr}(15)

    # round 1
    let (aa, cc) = FF(aa, bb, cc, dd, ee, x0, 11)
    let (ee, bb) = FF(ee, aa, bb, cc, dd, x1, 14)
    let (dd, aa) = FF(dd, ee, aa, bb, cc, x2, 15)
    let (cc, ee) = FF(cc, dd, ee, aa, bb, x3, 12)
    let (bb, dd) = FF(bb, cc, dd, ee, aa, x4,  5)
    let (aa, cc) = FF(aa, bb, cc, dd, ee, x5,  8)
    let (ee, bb) = FF(ee, aa, bb, cc, dd, x6,  7)
    let (dd, aa) = FF(dd, ee, aa, bb, cc, x7,  9)
    let (cc, ee) = FF(cc, dd, ee, aa, bb, x8, 11)
    let (bb, dd) = FF(bb, cc, dd, ee, aa, x9, 13)
    let (aa, cc) = FF(aa, bb, cc, dd, ee, x10,14)
    let (ee, bb) = FF(ee, aa, bb, cc, dd, x11,15)
    let (dd, aa) = FF(dd, ee, aa, bb, cc, x12, 6)
    let (cc, ee) = FF(cc, dd, ee, aa, bb, x13, 7)
    let (bb, dd) = FF(bb, cc, dd, ee, aa, x14, 9)
    let (aa, cc) = FF(aa, bb, cc, dd, ee, x15, 8)

    # round 2
    let (ee, bb) = GG(ee, aa, bb, cc, dd, x7,  7)
    let (dd, aa) = GG(dd, ee, aa, bb, cc, x4,  6)
    let (cc, ee) = GG(cc, dd, ee, aa, bb, x13, 8)
    let (bb, dd) = GG(bb, cc, dd, ee, aa, x1, 13)
    let (aa, cc) = GG(aa, bb, cc, dd, ee, x10,11)
    let (ee, bb) = GG(ee, aa, bb, cc, dd, x6,  9)
    let (dd, aa) = GG(dd, ee, aa, bb, cc, x15, 7)
    let (cc, ee) = GG(cc, dd, ee, aa, bb, x3, 15)
    let (bb, dd) = GG(bb, cc, dd, ee, aa, x12, 7)
    let (aa, cc) = GG(aa, bb, cc, dd, ee, x0, 12)
    let (ee, bb) = GG(ee, aa, bb, cc, dd, x9, 15)
    let (dd, aa) = GG(dd, ee, aa, bb, cc, x5,  9)
    let (cc, ee) = GG(cc, dd, ee, aa, bb, x2, 11)
    let (bb, dd) = GG(bb, cc, dd, ee, aa, x14, 7)
    let (aa, cc) = GG(aa, bb, cc, dd, ee, x11,13)
    let (ee, bb) = GG(ee, aa, bb, cc, dd, x8, 12)

    # round 3
    let (dd, aa) = HH(dd, ee, aa, bb, cc, x3, 11)
    let (cc, ee) = HH(cc, dd, ee, aa, bb, x10,13)
    let (bb, dd) = HH(bb, cc, dd, ee, aa, x14, 6)
    let (aa, cc) = HH(aa, bb, cc, dd, ee, x4,  7)
    let (ee, bb) = HH(ee, aa, bb, cc, dd, x9, 14)
    let (dd, aa) = HH(dd, ee, aa, bb, cc, x15, 9)
    let (cc, ee) = HH(cc, dd, ee, aa, bb, x8, 13)
    let (bb, dd) = HH(bb, cc, dd, ee, aa, x1, 15)
    let (aa, cc) = HH(aa, bb, cc, dd, ee, x2, 14)
    let (ee, bb) = HH(ee, aa, bb, cc, dd, x7,  8)
    let (dd, aa) = HH(dd, ee, aa, bb, cc, x0, 13)
    let (cc, ee) = HH(cc, dd, ee, aa, bb, x6,  6)
    let (bb, dd) = HH(bb, cc, dd, ee, aa, x13, 5)
    let (aa, cc) = HH(aa, bb, cc, dd, ee, x11,12)
    let (ee, bb) = HH(ee, aa, bb, cc, dd, x5,  7)
    let (dd, aa) = HH(dd, ee, aa, bb, cc, x12, 5)

    # round 4
    let (cc, ee) = II(cc, dd, ee, aa, bb, x1, 11)
    let (bb, dd) = II(bb, cc, dd, ee, aa, x9, 12)
    let (aa, cc) = II(aa, bb, cc, dd, ee, x11,14)
    let (ee, bb) = II(ee, aa, bb, cc, dd, x10,15)
    let (dd, aa) = II(dd, ee, aa, bb, cc, x0, 14)
    let (cc, ee) = II(cc, dd, ee, aa, bb, x8, 15)
    let (bb, dd) = II(bb, cc, dd, ee, aa, x12, 9)
    let (aa, cc) = II(aa, bb, cc, dd, ee, x4,  8)
    let (ee, bb) = II(ee, aa, bb, cc, dd, x13, 9)
    let (dd, aa) = II(dd, ee, aa, bb, cc, x3, 14)
    let (cc, ee) = II(cc, dd, ee, aa, bb, x7,  5)
    let (bb, dd) = II(bb, cc, dd, ee, aa, x15, 6)
    let (aa, cc) = II(aa, bb, cc, dd, ee, x14, 8)
    let (ee, bb) = II(ee, aa, bb, cc, dd, x5,  6)
    let (dd, aa) = II(dd, ee, aa, bb, cc, x6,  5)
    let (cc, ee) = II(cc, dd, ee, aa, bb, x2, 12)

    # round 5
    let (bb, dd) = JJ(bb, cc, dd, ee, aa, x4,  9)
    let (aa, cc) = JJ(aa, bb, cc, dd, ee, x0, 15)
    let (ee, bb) = JJ(ee, aa, bb, cc, dd, x5,  5)
    let (dd, aa) = JJ(dd, ee, aa, bb, cc, x9, 11)
    let (cc, ee) = JJ(cc, dd, ee, aa, bb, x7,  6)
    let (bb, dd) = JJ(bb, cc, dd, ee, aa, x12, 8)
    let (aa, cc) = JJ(aa, bb, cc, dd, ee, x2, 13)
    let (ee, bb) = JJ(ee, aa, bb, cc, dd, x10,12)
    let (dd, aa) = JJ(dd, ee, aa, bb, cc, x14, 5)
    let (cc, ee) = JJ(cc, dd, ee, aa, bb, x1, 12)
    let (bb, dd) = JJ(bb, cc, dd, ee, aa, x3, 13)
    let (aa, cc) = JJ(aa, bb, cc, dd, ee, x8, 14)
    let (ee, bb) = JJ(ee, aa, bb, cc, dd, x11,11)
    let (dd, aa) = JJ(dd, ee, aa, bb, cc, x6,  8)
    let (cc, ee) = JJ(cc, dd, ee, aa, bb, x15, 5)
    let (bb, dd) = JJ(bb, cc, dd, ee, aa, x13, 6)

    # parallel round 1
    let (aaa, ccc) = JJJ(aaa, bbb, ccc, ddd, eee, x5,  8)
    let (eee, bbb) = JJJ(eee, aaa, bbb, ccc, ddd, x14, 9)
    let (ddd, aaa) = JJJ(ddd, eee, aaa, bbb, ccc, x7,  9)
    let (ccc, eee) = JJJ(ccc, ddd, eee, aaa, bbb, x0, 11)
    let (bbb, eee) = JJJ(bbb, ccc, ddd, eee, aaa, x9, 13)
    let (aaa, ccc) = JJJ(aaa, bbb, ccc, ddd, eee, x2, 15)
    let (eee, bbb) = JJJ(eee, aaa, bbb, ccc, ddd, x11,15)
    let (ddd, aaa) = JJJ(ddd, eee, aaa, bbb, ccc, x4,  5)
    let (ccc, eee) = JJJ(ccc, ddd, eee, aaa, bbb, x13, 7)
    let (bbb, ddd) = JJJ(bbb, ccc, ddd, eee, aaa, x6,  7)
    let (aaa, ccc) = JJJ(aaa, bbb, ccc, ddd, eee, x15, 8)
    let (eee, bbb) = JJJ(eee, aaa, bbb, ccc, ddd, x8, 11)
    let (ddd, aaa) = JJJ(ddd, eee, aaa, bbb, ccc, x1, 14)
    let (ccc, eee) = JJJ(ccc, ddd, eee, aaa, bbb, x10,14)
    let (bbb, ddd) = JJJ(bbb, ccc, ddd, eee, aaa, x3, 12)
    let (aaa, ccc) = JJJ(aaa, bbb, ccc, ddd, eee, x12, 6)

    # parallel round 2
    let (eee, bbb) = III(eee, aaa, bbb, ccc, ddd, x6,  9)
    let (ddd, aaa) = III(ddd, eee, aaa, bbb, ccc, x11,13)
    let (ccc, eee) = III(ccc, ddd, eee, aaa, bbb, x3, 15)
    let (bbb, ddd) = III(bbb, ccc, ddd, eee, aaa, x7,  7)
    let (aaa, ccc) = III(aaa, bbb, ccc, ddd, eee, x0, 12)
    let (eee, bbb) = III(eee, aaa, bbb, ccc, ddd, x13, 8)
    let (ddd, aaa) = III(ddd, eee, aaa, bbb, ccc, x5,  9)
    let (ccc, eee) = III(ccc, ddd, eee, aaa, bbb, x10,11)
    let (bbb, ddd) = III(bbb, ccc, ddd, eee, aaa, x14, 7)
    let (aaa, ccc) = III(aaa, bbb, ccc, ddd, eee, x15, 7)
    let (eee, bbb) = III(eee, aaa, bbb, ccc, ddd, x8, 12)
    let (ddd, aaa) = III(ddd, eee, aaa, bbb, ccc, x12, 7)
    let (ccc, eee) = III(ccc, ddd, eee, aaa, bbb, x4,  6)
    let (bbb, ddd) = III(bbb, ccc, ddd, eee, aaa, x9, 15)
    let (aaa, ccc) = III(aaa, bbb, ccc, ddd, eee, x1, 13)
    let (eee, bbb) = III(eee, aaa, bbb, ccc, ddd, x2, 11)

    # parallel round 3
    let (ddd, aaa) = HHH(ddd, eee, aaa, bbb, ccc, x15, 9)
    let (ccc, eee) = HHH(ccc, ddd, eee, aaa, bbb, x5,  7)
    let (bbb, ddd) = HHH(bbb, ccc, ddd, eee, aaa, x1, 15)
    let (aaa, ccc) = HHH(aaa, bbb, ccc, ddd, eee, x3, 11)
    let (eee, bbb) = HHH(eee, aaa, bbb, ccc, ddd, x7,  8)
    let (ddd, aaa) = HHH(ddd, eee, aaa, bbb, ccc, x14, 6)
    let (ccc, eee) = HHH(ccc, ddd, eee, aaa, bbb, x6,  6)
    let (bbb, ddd) = HHH(bbb, ccc, ddd, eee, aaa, x9, 14)
    let (aaa, ccc) = HHH(aaa, bbb, ccc, ddd, eee, x11,12)
    let (eee, bbb) = HHH(eee, aaa, bbb, ccc, ddd, x8, 13)
    let (ddd, aaa) = HHH(ddd, eee, aaa, bbb, ccc, x12, 5)
    let (ccc, eee) = HHH(ccc, ddd, eee, aaa, bbb, x2, 14)
    let (bbb, ddd) = HHH(bbb, ccc, ddd, eee, aaa, x10,13)
    let (aaa, ccc) = HHH(aaa, bbb, ccc, ddd, eee, x0, 13)
    let (eee, bbb) = HHH(eee, aaa, bbb, ccc, ddd, x4,  7)
    let (ddd, aaa) = HHH(ddd, eee, aaa, bbb, ccc, x13, 5)

    # parallel round 4
    let (ccc, eee) = GGG(ccc, ddd, eee, aaa, bbb, x8, 15)
    let (bbb, ddd) = GGG(bbb, ccc, ddd, eee, aaa, x6,  5)
    let (aaa, ccc) = GGG(aaa, bbb, ccc, ddd, eee, x4,  8)
    let (eee, bbb) = GGG(eee, aaa, bbb, ccc, ddd, x1, 11)
    let (ddd, aaa) = GGG(ddd, eee, aaa, bbb, ccc, x3, 14)
    let (ccc, eee) = GGG(ccc, ddd, eee, aaa, bbb, x11,14)
    let (bbb, ddd) = GGG(bbb, ccc, ddd, eee, aaa, x15, 6)
    let (aaa, ccc) = GGG(aaa, bbb, ccc, ddd, eee, x0, 14)
    let (eee, bbb) = GGG(eee, aaa, bbb, ccc, ddd, x5,  6)
    let (ddd, aaa) = GGG(ddd, eee, aaa, bbb, ccc, x12, 9)
    let (ccc, eee) = GGG(ccc, ddd, eee, aaa, bbb, x2, 12)
    let (bbb, ddd) = GGG(bbb, ccc, ddd, eee, aaa, x13, 9)
    let (aaa, ccc) = GGG(aaa, bbb, ccc, ddd, eee, x9, 12)
    let (eee, bbb) = GGG(eee, aaa, bbb, ccc, ddd, x7,  5)
    let (ddd, aaa) = GGG(ddd, eee, aaa, bbb, ccc, x10,15)
    let (ccc, eee) = GGG(ccc, ddd, eee, aaa, bbb, x14, 8)

    # parallel round 5
    let (bbb, ddd) = FFF(bbb, ccc, ddd, eee, aaa, x12, 8)
    let (aaa, ccc) = FFF(aaa, bbb, ccc, ddd, eee, x15, 5)
    let (eee, bbb) = FFF(eee, aaa, bbb, ccc, ddd, x10,12)
    let (ddd, aaa) = FFF(ddd, eee, aaa, bbb, ccc, x4,  9)
    let (ccc, eee) = FFF(ccc, ddd, eee, aaa, bbb, x1, 12)
    let (bbb, ddd) = FFF(bbb, ccc, ddd, eee, aaa, x5,  5)
    let (aaa, ccc) = FFF(aaa, bbb, ccc, ddd, eee, x8, 14)
    let (eee, bbb) = FFF(eee, aaa, bbb, ccc, ddd, x7,  6)
    let (ddd, aaa) = FFF(ddd, eee, aaa, bbb, ccc, x6,  8)
    let (ccc, eee) = FFF(ccc, ddd, eee, aaa, bbb, x2, 13)
    let (bbb, ddd) = FFF(bbb, ccc, ddd, eee, aaa, x13, 6)
    let (aaa, ccc) = FFF(aaa, bbb, ccc, ddd, eee, x14, 5)
    let (eee, bbb) = FFF(eee, aaa, bbb, ccc, ddd, x0, 15)
    let (ddd, aaa) = FFF(ddd, eee, aaa, bbb, ccc, x3, 13)
    let (ccc, eee) = FFF(ccc, ddd, eee, aaa, bbb, x9, 11)
    let (bbb, ddd) = FFF(bbb, ccc, ddd, eee, aaa, x11,11)

    # combine results
    let ddd = ddd + cc + [buf + 1]
    
    assert res[0] = ddd
    assert res[1] = [buf + 2] + dd + eee
    assert res[2] = [buf + 3] + ee + aaa
    assert res[3] = [buf + 4] + aa + bbb
    assert res[4] = [buf] + bb + ccc

    return (res=res, rsize=5)
end

# puts bytes from data into X and pad out; appends length 
# and finally, compresses the last block(s)
# note: length in bits == 8 * (dsize + 2^32 mswlen).
# note: there are (dsize mod 64) bytes left in data.
func finish{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(buf: felt*, bufsize: felt, data: felt*, dsize: felt, mswlen: felt) -> (res: felt*, rsize: felt):
    let (x) = dict_new()
    memset_dict{dict_ptr=x}(0)

    # put data into x.
    let (len) = bitwise_and(dsize, 63)
    absorb_data{dict_ptr=x}(data, len, 0)

    # append the bit m_n == 1.
    let (index_4, _) = unsigned_div_rem(dsize, 4)
    let (index) = bitwise_and(index_4, 15)
    let (old_val) = dict_read{dict_ptr=x}(index)
    let (factor) = 8 * bitwise_and(dsize, 3) + 7
    let (tmp) = pow2(factor)
    let (val) = bitwise_xor(old_val, tmp)
    dict_write{dict_ptr=x}(index, val)

    # length goes to next block.
    let (next_block) = is_nn_le(55, len)
    if next_block == 1:
        let (buf, bufsize) = compress{dict_ptr=x}(buf, bufsize)
        memset_dict{dict_ptr=x}(0)
    end

    dict_write{dict_ptr=x}(14, dsize * pow2(3))
    let (val_15) = bitwise_or(dsize/pow2(29), mswlen * pow2(3))
    dict_write{dict_ptr=x}(15, val_15)

    let (res, rsize) = compress{dict_ptr=x}(buf, bufsize)
    return (res=res, rsize=rsize)
end

func absorb_data{dict_ptr : DictAccess*}(data: felt*, len: felt, index: felt):
    if index - len == 0:
        return ()
    end

    let (index_4, _) = unsigned_div_rem(index, 4)
    let (index_and_3) = bitwise_and(index, 3)
    let (factor) = 8 * index_and_3
    let (tmp) = [data] * pow2(factor)
    let (old_val) = dict_read{dict_ptr=dict_ptr}(index_4)
    let (val) = bitwise_xor(old_val, tmp)
    dict_write{dict_ptr=dict_ptr}(index_4, val)
    
    absorb_data{dict_ptr=dict_ptr}(data+1, len, index+1)
    return ()
end

func memset_dict{dict_ptr : DictAccess*}(key: felt):
    if key == 16:
        return ()
    end

    memset_dict{dict_ptr=dict_ptr}(key+1)
    dict_write{dict_ptr=dict_ptr}(key, 0)
    return ()
end