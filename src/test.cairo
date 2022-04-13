%builtins range_check bitwise

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.dict import dict_new, dict_write
from rmd160 import init, compress, finish
from utils import BYTES_TO_WORD

func RMD{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(msg: felt*, msglen: felt) -> (hash: felt*):
    alloc_locals
    local buf: felt*
    init(buf, 5)

    let (x) = dict_new()
    let (res, rsize) = compress_data{dict_ptr=x}(buf, 5, msg, msglen)
    let (res, rsize) = finish{dict_ptr=x}(res, rsize, msg, msglen, 0)
    return (hash=res)
end

func parse_msg{dict_ptr: DictAccess*}(msg: felt*, index: felt):
    if index - 16 == 0:
        return ()
    end

    let (val) = BYTES_TO_WORD(msg)
    dict_write{dict_ptr=dict_ptr}(index, val)
    parse_msg{dict_ptr=dict_ptr}(msg=msg+4, index=index+1)
    return ()
end

func compress_data{dict_ptr: DictAccess*}(buf: felt*, bufsize: felt, msg: felt*, msglen: felt) -> (res: felt*, rsize: felt):
    if msglen - 63 == 0:
        return ()
    end

    parse_msg{dict_ptr=dict_ptr}(msg, 0)
    let (res, rsize) = compress{dict_ptr=dict_ptr}(buf, bufsize)
    let (res, rsize) = compress_data{dict_ptr=dict_ptr}(res, rsize, msg+64, msglen-64)
    return (res=res, rsize=rsize)
end

func main{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}():
    # test vectors:
    # message: "a"
    # hashcode: 508a6ccc545b32641fe7311048defe7cf599ada3
    alloc_locals
    local msg : felt*
    assert msg[0] = 97
    let (hash) = RMD(msg, 1)

    return ()
end