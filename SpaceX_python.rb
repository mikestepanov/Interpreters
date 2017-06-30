def cpuEmulator(subroutine):

    Regs = [0]*43

    i = 0
    pc = 0
    while pc < len(subroutine) and i < 5*pow(10,4):

        inst = subroutine[pc]
        pc = runInstruction(Regs, inst, pc) + 1
        i += 1

    return str(Regs[42])


# parses the instruction
# runs the instruction
# returns the pc after the instruction is executed (either unchanged or altered due to a jump)
def runInstruction(Regs, inst, pc):

    instruction = inst.split(' ')
    if instruction[0] != 'NOP':
        args = instruction[1]

    if instruction[0] == 'MOV':
        if args[0] == 'R':
            parsedArgs = args.split(',')
            MOV1(Regs, parseRegister(parsedArgs[0]), parseRegister(parsedArgs[1]))
        else:
            parsedArgs = args.split(',')
            MOV2(Regs, int(parsedArgs[0]), parseRegister(parsedArgs[1]))

    elif instruction[0] == 'ADD':
        parsedArgs = args.split(',')
        ADD(Regs, parseRegister(parsedArgs[0]), parseRegister(parsedArgs[1]))

    elif instruction[0] == 'DEC':
        DEC(Regs, parseRegister(instruction[1]))

    elif instruction[0] == 'INC':
        INC(Regs, parseRegister(instruction[1]))

    elif instruction[0] == 'INV':
        INV(Regs, parseRegister(instruction[1]))

    elif instruction[0] == 'JMP':
        pc = int(instruction[1]) - 2

    elif instruction[0] == 'JZ':
        if Regs[0] == 0:
            pc = int(instruction[1]) - 2

    return pc



# returns number of register (reg comes in as R##)
def parseRegister(reg):
    if reg[1] == '0':
        return int(reg[2])
    else:
        return int(reg[1:])


# xx and yy are integers representing indices of Regs
def MOV1(Regs, xx, yy):
    Regs[yy] = Regs[xx]

def MOV2(Regs, d, xx):
    Regs[xx] = d

def ADD(Regs, xx, yy):
    Regs[xx] = (Regs[xx]+Regs[yy])%(pow(2,32))

def DEC(Regs, xx):
    if Regs[xx] == 0:
        Regs[xx] = pow(2,32)-1
    else:
        Regs[xx] -= 1

def INC(Regs, xx):
    if Regs[xx] == pow(2,32)-1:
        Regs[xx] = 0
    else:
        Regs[xx] += 1

def INV(Regs, xx):
    Regs[xx] = ~Regs[xx] + pow(2,32)
