%builtins range_check bitwise

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.default_dict import default_dict_new
from starkware.cairo.common.dict import dict_new, dict_write, dict_squash
from rmd160 import init, compress, finish, dict_to_array
from utils import BYTES_TO_WORD

func RMD{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}(msg: felt*, msglen: felt) -> (hash: felt*):
    alloc_locals
    let (local buf: felt*) = alloc()
    init(buf, 5)

    let (x) = default_dict_new(0)
    let start = x
    let (res, rsize) = compress_data{dict_ptr=x, bitwise_ptr=bitwise_ptr}(buf, 5, msg, msglen)
    let (_, _) = dict_squash{range_check_ptr=range_check_ptr}(start, x)
    let (res, _) = finish(res, rsize, msg, msglen, 0)
    return (hash=res)
end

func parse_msg{dict_ptr: DictAccess*, bitwise_ptr: BitwiseBuiltin*}(msg: felt*, index: felt):
    if index - 16 == 0:
        return ()
    end

    let (val) = BYTES_TO_WORD{bitwise_ptr=bitwise_ptr}(msg)
    dict_write{dict_ptr=dict_ptr}(index, val)
    parse_msg{dict_ptr=dict_ptr, bitwise_ptr=bitwise_ptr}(msg=msg+4, index=index+1)
    return ()
end

func compress_data{dict_ptr: DictAccess*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(buf: felt*, bufsize: felt, msg: felt*, msglen: felt) -> (res: felt*, rsize: felt):
    alloc_locals
    if msglen - 63 == 0:
        return (buf, bufsize)
    end

    parse_msg{dict_ptr=dict_ptr}(msg, 0)
    let (local arr_x) = dict_to_array{dict_ptr=dict_ptr}()
    local dict_ptr : DictAccess* = dict_ptr
    let (res, rsize) = compress(buf, bufsize, arr_x, 16)
    let (res, rsize) = compress_data{dict_ptr=dict_ptr, bitwise_ptr=bitwise_ptr}(res, rsize, msg+64, msglen-64)
    return (res=res, rsize=rsize)
end

func main{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}():
    # test vectors:
    # message: "a"
    # hashcode: 508a6ccc545b32641fe7311048defe7cf599ada3
    alloc_locals
    # local msg : felt*
    tempvar msg : felt* = new (97)
    # assert [msg] = 97
    let (hash) = RMD(msg, 1)

    return ()
end