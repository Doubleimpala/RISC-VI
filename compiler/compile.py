import numpy

opcodes = {
    "halt"  :   "0000000",
    "add"   :   "0000001",
    "sub"   :   "0000001",
    "mult"  :   "0000001",
    "div"   :   "0000001",
    "or"    :   "0000001",
    "and"   :   "0000001",
}

f = open('program.asm','r')

fout = open('program.bin', 'w')