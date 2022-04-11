from utils import FF, GG, HH, II, JJ, FFF, GGG, HHH, III, JJJ

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
func compress{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(buf: felt*, bufsize: felt, x: felt*, xsize: felt, res: felt*, rsize: felt):
    if bufsize != 5:
        return ()
    end

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

    # round 1
    let (aa, cc) = FF(aa, bb, cc, dd, ee, [x + 0], 11)
    let (ee, bb) = FF(ee, aa, bb, cc, dd, [x + 1], 14)
    let (dd, aa) = FF(dd, ee, aa, bb, cc, [x + 2], 15)
    let (cc, ee) = FF(cc, dd, ee, aa, bb, [x + 3], 12)
    let (bb, dd) = FF(bb, cc, dd, ee, aa, [x + 4],  5)
    let (aa, cc) = FF(aa, bb, cc, dd, ee, [x + 5],  8)
    let (ee, bb) = FF(ee, aa, bb, cc, dd, [x + 6],  7)
    let (dd, aa) = FF(dd, ee, aa, bb, cc, [x + 7],  9)
    let (cc, ee) = FF(cc, dd, ee, aa, bb, [x + 8], 11)
    let (bb, dd) = FF(bb, cc, dd, ee, aa, [x + 9], 13)
    let (aa, cc) = FF(aa, bb, cc, dd, ee, [x +10], 14)
    let (ee, bb) = FF(ee, aa, bb, cc, dd, [x +11], 15)
    let (dd, aa) = FF(dd, ee, aa, bb, cc, [x +12],  6)
    let (cc, ee) = FF(cc, dd, ee, aa, bb, [x +13],  7)
    let (bb, dd) = FF(bb, cc, dd, ee, aa, [x +14],  9)
    let (aa, cc) = FF(aa, bb, cc, dd, ee, [x +15],  8)

    # round 2
    let (ee, bb) = GG(ee, aa, bb, cc, dd, [x + 7],  7)
    let (dd, aa) = GG(dd, ee, aa, bb, cc, [x + 4],  6)
    let (cc, ee) = GG(cc, dd, ee, aa, bb, [x +13],  8)
    let (bb, dd) = GG(bb, cc, dd, ee, aa, [x + 1], 13)
    let (aa, cc) = GG(aa, bb, cc, dd, ee, [x +10], 11)
    let (ee, bb) = GG(ee, aa, bb, cc, dd, [x + 6],  9)
    let (dd, aa) = GG(dd, ee, aa, bb, cc, [x +15],  7)
    let (cc, ee) = GG(cc, dd, ee, aa, bb, [x + 3], 15)
    let (bb, dd) = GG(bb, cc, dd, ee, aa, [x +12],  7)
    let (aa, cc) = GG(aa, bb, cc, dd, ee, [x + 0], 12)
    let (ee, bb) = GG(ee, aa, bb, cc, dd, [x + 9], 15)
    let (dd, aa) = GG(dd, ee, aa, bb, cc, [x + 5],  9)
    let (cc, ee) = GG(cc, dd, ee, aa, bb, [x + 2], 11)
    let (bb, dd) = GG(bb, cc, dd, ee, aa, [x +14],  7)
    let (aa, cc) = GG(aa, bb, cc, dd, ee, [x +11], 13)
    let (ee, bb) = GG(ee, aa, bb, cc, dd, [x + 8], 12)

    # round 3
    let (dd, aa) = HH(dd, ee, aa, bb, cc, [x + 3], 11)
    let (cc, ee) = HH(cc, dd, ee, aa, bb, [x +10], 13)
    let (bb, dd) = HH(bb, cc, dd, ee, aa, [x +14],  6)
    let (aa, cc) = HH(aa, bb, cc, dd, ee, [x + 4],  7)
    let (ee, bb) = HH(ee, aa, bb, cc, dd, [x + 9], 14)
    let (dd, aa) = HH(dd, ee, aa, bb, cc, [x +15],  9)
    let (cc, ee) = HH(cc, dd, ee, aa, bb, [x + 8], 13)
    let (bb, dd) = HH(bb, cc, dd, ee, aa, [x + 1], 15)
    let (aa, cc) = HH(aa, bb, cc, dd, ee, [x + 2], 14)
    let (ee, bb) = HH(ee, aa, bb, cc, dd, [x + 7],  8)
    let (dd, aa) = HH(dd, ee, aa, bb, cc, [x + 0], 13)
    let (cc, ee) = HH(cc, dd, ee, aa, bb, [x + 6],  6)
    let (bb, dd) = HH(bb, cc, dd, ee, aa, [x +13],  5)
    let (aa, cc) = HH(aa, bb, cc, dd, ee, [x +11], 12)
    let (ee, bb) = HH(ee, aa, bb, cc, dd, [x + 5],  7)
    let (dd, aa) = HH(dd, ee, aa, bb, cc, [x +12],  5)

    # round 4
    let (cc, ee) = II(cc, dd, ee, aa, bb, [x + 1], 11)
    let (bb, dd) = II(bb, cc, dd, ee, aa, [x + 9], 12)
    let (aa, cc) = II(aa, bb, cc, dd, ee, [x +11], 14)
    let (ee, bb) = II(ee, aa, bb, cc, dd, [x +10], 15)
    let (dd, aa) = II(dd, ee, aa, bb, cc, [x + 0], 14)
    let (cc, ee) = II(cc, dd, ee, aa, bb, [x + 8], 15)
    let (bb, dd) = II(bb, cc, dd, ee, aa, [x +12],  9)
    let (aa, cc) = II(aa, bb, cc, dd, ee, [x + 4],  8)
    let (ee, bb) = II(ee, aa, bb, cc, dd, [x +13],  9)
    let (dd, aa) = II(dd, ee, aa, bb, cc, [x + 3], 14)
    let (cc, ee) = II(cc, dd, ee, aa, bb, [x + 7],  5)
    let (bb, dd) = II(bb, cc, dd, ee, aa, [x +15],  6)
    let (aa, cc) = II(aa, bb, cc, dd, ee, [x +14],  8)
    let (ee, bb) = II(ee, aa, bb, cc, dd, [x + 5],  6)
    let (dd, aa) = II(dd, ee, aa, bb, cc, [x + 6],  5)
    let (cc, ee) = II(cc, dd, ee, aa, bb, [x + 2], 12)

    # round 5
    let (bb, dd) = JJ(bb, cc, dd, ee, aa, [x + 4],  9)
    let (aa, cc) = JJ(aa, bb, cc, dd, ee, [x + 0], 15)
    let (ee, bb) = JJ(ee, aa, bb, cc, dd, [x + 5],  5)
    let (dd, aa) = JJ(dd, ee, aa, bb, cc, [x + 9], 11)
    let (cc, ee) = JJ(cc, dd, ee, aa, bb, [x + 7],  6)
    let (bb, dd) = JJ(bb, cc, dd, ee, aa, [x +12],  8)
    let (aa, cc) = JJ(aa, bb, cc, dd, ee, [x + 2], 13)
    let (ee, bb) = JJ(ee, aa, bb, cc, dd, [x +10], 12)
    let (dd, aa) = JJ(dd, ee, aa, bb, cc, [x +14],  5)
    let (cc, ee) = JJ(cc, dd, ee, aa, bb, [x + 1], 12)
    let (bb, dd) = JJ(bb, cc, dd, ee, aa, [x + 3], 13)
    let (aa, cc) = JJ(aa, bb, cc, dd, ee, [x + 8], 14)
    let (ee, bb) = JJ(ee, aa, bb, cc, dd, [x +11], 11)
    let (dd, aa) = JJ(dd, ee, aa, bb, cc, [x + 6],  8)
    let (cc, ee) = JJ(cc, dd, ee, aa, bb, [x +15],  5)
    let (bb, dd) = JJ(bb, cc, dd, ee, aa, [x +13],  6)

    # parallel round 1
    let (aaa, ccc) = JJJ(aaa, bbb, ccc, ddd, eee, [x + 5],  8)
    let (eee, bbb) = JJJ(eee, aaa, bbb, ccc, ddd, [x +14],  9)
    let (ddd, aaa) = JJJ(ddd, eee, aaa, bbb, ccc, [x + 7],  9)
    let (ccc, eee) = JJJ(ccc, ddd, eee, aaa, bbb, [x + 0], 11)
    let (bbb, eee) = JJJ(bbb, ccc, ddd, eee, aaa, [x + 9], 13)
    let (aaa, ccc) = JJJ(aaa, bbb, ccc, ddd, eee, [x + 2], 15)
    let (eee, bbb) = JJJ(eee, aaa, bbb, ccc, ddd, [x +11], 15)
    let (ddd, aaa) = JJJ(ddd, eee, aaa, bbb, ccc, [x + 4],  5)
    let (ccc, eee) = JJJ(ccc, ddd, eee, aaa, bbb, [x +13],  7)
    let (bbb, ddd) = JJJ(bbb, ccc, ddd, eee, aaa, [x + 6],  7)
    let (aaa, ccc) = JJJ(aaa, bbb, ccc, ddd, eee, [x +15],  8)
    let (eee, bbb) = JJJ(eee, aaa, bbb, ccc, ddd, [x + 8], 11)
    let (ddd, aaa) = JJJ(ddd, eee, aaa, bbb, ccc, [x + 1], 14)
    let (ccc, eee) = JJJ(ccc, ddd, eee, aaa, bbb, [x +10], 14)
    let (bbb, ddd) = JJJ(bbb, ccc, ddd, eee, aaa, [x + 3], 12)
    let (aaa, ccc) = JJJ(aaa, bbb, ccc, ddd, eee, [x +12],  6)

    # parallel round 2
    let (eee, bbb) = III(eee, aaa, bbb, ccc, ddd, [x + 6],  9)
    let (ddd, aaa) = III(ddd, eee, aaa, bbb, ccc, [x +11], 13)
    let (ccc, eee) = III(ccc, ddd, eee, aaa, bbb, [x + 3], 15)
    let (bbb, ddd) = III(bbb, ccc, ddd, eee, aaa, [x + 7],  7)
    let (aaa, ccc) = III(aaa, bbb, ccc, ddd, eee, [x + 0], 12)
    let (eee, bbb) = III(eee, aaa, bbb, ccc, ddd, [x +13],  8)
    let (ddd, aaa) = III(ddd, eee, aaa, bbb, ccc, [x + 5],  9)
    let (ccc, eee) = III(ccc, ddd, eee, aaa, bbb, [x +10], 11)
    let (bbb, ddd) = III(bbb, ccc, ddd, eee, aaa, [x +14],  7)
    let (aaa, ccc) = III(aaa, bbb, ccc, ddd, eee, [x +15],  7)
    let (eee, bbb) = III(eee, aaa, bbb, ccc, ddd, [x + 8], 12)
    let (ddd, aaa) = III(ddd, eee, aaa, bbb, ccc, [x +12],  7)
    let (ccc, eee) = III(ccc, ddd, eee, aaa, bbb, [x + 4],  6)
    let (bbb, ddd) = III(bbb, ccc, ddd, eee, aaa, [x + 9], 15)
    let (aaa, ccc) = III(aaa, bbb, ccc, ddd, eee, [x + 1], 13)
    let (eee, bbb) = III(eee, aaa, bbb, ccc, ddd, [x + 2], 11)

    # parallel round 3
    let (ddd, aaa) = HHH(ddd, eee, aaa, bbb, ccc, [x +15],  9)
    let (ccc, eee) = HHH(ccc, ddd, eee, aaa, bbb, [x + 5],  7)
    let (bbb, ddd) = HHH(bbb, ccc, ddd, eee, aaa, [x + 1], 15)
    let (aaa, ccc) = HHH(aaa, bbb, ccc, ddd, eee, [x + 3], 11)
    let (eee, bbb) = HHH(eee, aaa, bbb, ccc, ddd, [x + 7],  8)
    let (ddd, aaa) = HHH(ddd, eee, aaa, bbb, ccc, [x +14],  6)
    let (ccc, eee) = HHH(ccc, ddd, eee, aaa, bbb, [x + 6],  6)
    let (bbb, ddd) = HHH(bbb, ccc, ddd, eee, aaa, [x + 9], 14)
    let (aaa, ccc) = HHH(aaa, bbb, ccc, ddd, eee, [x +11], 12)
    let (eee, bbb) = HHH(eee, aaa, bbb, ccc, ddd, [x + 8], 13)
    let (ddd, aaa) = HHH(ddd, eee, aaa, bbb, ccc, [x +12],  5)
    let (ccc, eee) = HHH(ccc, ddd, eee, aaa, bbb, [x + 2], 14)
    let (bbb, ddd) = HHH(bbb, ccc, ddd, eee, aaa, [x +10], 13)
    let (aaa, ccc) = HHH(aaa, bbb, ccc, ddd, eee, [x + 0], 13)
    let (eee, bbb) = HHH(eee, aaa, bbb, ccc, ddd, [x + 4],  7)
    let (ddd, aaa) = HHH(ddd, eee, aaa, bbb, ccc, [x +13],  5)

    # parallel round 4
    let (ccc, eee) = GGG(ccc, ddd, eee, aaa, bbb, [x + 8], 15)
    let (bbb, ddd) = GGG(bbb, ccc, ddd, eee, aaa, [x + 6],  5)
    let (aaa, ccc) = GGG(aaa, bbb, ccc, ddd, eee, [x + 4],  8)
    let (eee, bbb) = GGG(eee, aaa, bbb, ccc, ddd, [x + 1], 11)
    let (ddd, aaa) = GGG(ddd, eee, aaa, bbb, ccc, [x + 3], 14)
    let (ccc, eee) = GGG(ccc, ddd, eee, aaa, bbb, [x +11], 14)
    let (bbb, ddd) = GGG(bbb, ccc, ddd, eee, aaa, [x +15],  6)
    let (aaa, ccc) = GGG(aaa, bbb, ccc, ddd, eee, [x + 0], 14)
    let (eee, bbb) = GGG(eee, aaa, bbb, ccc, ddd, [x + 5],  6)
    let (ddd, aaa) = GGG(ddd, eee, aaa, bbb, ccc, [x +12],  9)
    let (ccc, eee) = GGG(ccc, ddd, eee, aaa, bbb, [x + 2], 12)
    let (bbb, ddd) = GGG(bbb, ccc, ddd, eee, aaa, [x +13],  9)
    let (aaa, ccc) = GGG(aaa, bbb, ccc, ddd, eee, [x + 9], 12)
    let (eee, bbb) = GGG(eee, aaa, bbb, ccc, ddd, [x + 7],  5)
    let (ddd, aaa) = GGG(ddd, eee, aaa, bbb, ccc, [x +10], 15)
    let (ccc, eee) = GGG(ccc, ddd, eee, aaa, bbb, [x +14],  8)

    # parallel round 5
    let (bbb, ddd) = FFF(bbb, ccc, ddd, eee, aaa, [x +12],  8)
    let (aaa, ccc) = FFF(aaa, bbb, ccc, ddd, eee, [x +15],  5)
    let (eee, bbb) = FFF(eee, aaa, bbb, ccc, ddd, [x +10], 12)
    let (ddd, aaa) = FFF(ddd, eee, aaa, bbb, ccc, [x + 4],  9)
    let (ccc, eee) = FFF(ccc, ddd, eee, aaa, bbb, [x + 1], 12)
    let (bbb, ddd) = FFF(bbb, ccc, ddd, eee, aaa, [x + 5],  5)
    let (aaa, ccc) = FFF(aaa, bbb, ccc, ddd, eee, [x + 8], 14)
    let (eee, bbb) = FFF(eee, aaa, bbb, ccc, ddd, [x + 7],  6)
    let (ddd, aaa) = FFF(ddd, eee, aaa, bbb, ccc, [x + 6],  8)
    let (ccc, eee) = FFF(ccc, ddd, eee, aaa, bbb, [x + 2], 13)
    let (bbb, ddd) = FFF(bbb, ccc, ddd, eee, aaa, [x +13],  6)
    let (aaa, ccc) = FFF(aaa, bbb, ccc, ddd, eee, [x +14],  5)
    let (eee, bbb) = FFF(eee, aaa, bbb, ccc, ddd, [x + 0], 15)
    let (ddd, aaa) = FFF(ddd, eee, aaa, bbb, ccc, [x + 3], 13)
    let (ccc, eee) = FFF(ccc, ddd, eee, aaa, bbb, [x + 9], 11)
    let (bbb, ddd) = FFF(bbb, ccc, ddd, eee, aaa, [x +11], 11)

    # combine results
    let ddd = ddd + cc + [buf + 1]
    assert [res] = ddd
    assert [res + 1] = [buf + 2] + dd + eee
    assert [res + 2] = [buf + 3] + ee + aaa
    assert [res + 3] = [buf + 4] + aa + bbb
    assert [res + 4] = [buf] + bb + ccc

    return ()
end

# puts bytes from strptr into X and pad out; appends length 
# and finally, compresses the last block(s)
# note: length in bits == 8 * (lswlen + 2^32 mswlen).
# note: there are (lswlen mod 64) bytes left in strptr.
func finish{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(buf: felt*, bufsize: felt, strptr: felt*, lswlen: felt, mswlen: felt):
end
