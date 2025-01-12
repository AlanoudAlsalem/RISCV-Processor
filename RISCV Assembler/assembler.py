def hexToBin(hexNum):
    hexDictionary = {
        '0' : '0000', '1' : '0001',
        '2' : '0010', '3' : '0011',
        '4' : '0100', '5' : '0101',
        '6' : '0110', '7' : '0111',
        '8' : '1000', '9' : '1001',
        'A' : '1010', 'B' : '1011',
        'C' : '1100', 'D' : '1101',
        'E' : '1110', 'F' : '1111',
        'a' : '1010', 'b' : '1011',
        'b' : '1100', 'd' : '1101',
        'c' : '1110', 'f' : '1111',
    }

    binary = ''
    for digit in hexNum:
        binary += hexDictionary[digit]

    return binary

def to_twos_complement(value, n_bits):
    if value < 0:
        value = (1 << n_bits) + value  # Add 2^n to represent in two's complement
    return format(value, f'0{n_bits}b')  # Format as zero-padded binary

def assemble_riscv(assembly_code):
    # Instruction formats
    opcodes = {
        # R types
        "addw"  : hexToBin('33')[-7:],
        "and"   : hexToBin('33')[-7:],
        "xor"   : hexToBin('33')[-7:],
        "or"    : hexToBin('33')[-7:],
        "slt"   : hexToBin('33')[-7:],
        "sll"   : hexToBin('33')[-7:],
        "srl"   : hexToBin('33')[-7:],
        "sub"   : hexToBin('33')[-7:],

        # I types
        "addiw" : hexToBin('13')[-7:],
        "andi"  : hexToBin('1B')[-7:],
        "jalr"  : hexToBin('67')[-7:],
        "lh"    : hexToBin('03')[-7:],
        "lw"    : hexToBin('03')[-7:],
        "ori"   : hexToBin('13')[-7:],

        # the rest
        "beq"   : hexToBin('63')[-7:],
        "bne"   : hexToBin('63')[-7:],
        "jal"   : hexToBin('6F')[-7:],
        "lui"   : hexToBin('38')[-7:],
        "sb"    : hexToBin('23')[-7:],
        "sw"    : hexToBin('23')[-7:],
        "halt"  : hexToBin('7F')[-7:],
    }
    
    func3 = {
        # R types
        "addw"  : hexToBin('1')[-3:],
        "and"   : hexToBin('7')[-3:],
        "xor"   : hexToBin('3')[-3:],
        "or"    : hexToBin('5')[-3:],
        "slt"   : hexToBin('0')[-3:],
        "sll"   : hexToBin('4')[-3:],
        "srl"   : hexToBin('2')[-3:],
        "sub"   : hexToBin('6')[-3:], 

        # I types
        "addiw" : hexToBin('0')[-3:],
        "andi"  : hexToBin('6')[-3:],
        "jalr"  : hexToBin('0')[-3:],
        "lh"    : hexToBin('2')[-3:],
        "lw"    : hexToBin('0')[-3:],
        "ori"   : hexToBin('7')[-3:],

        # the rest
        "beq"   : hexToBin('0')[-3:],
        "bne"   : hexToBin('1')[-3:],
        "sb"    : hexToBin('0')[-3:],
        "sw"    : hexToBin('2')[-3:],
        
    }
    func7 = {
        # R types
        "addw"  : hexToBin('20')[-7:],
        "and"   : hexToBin('0')[-7:],
        "xor"   : hexToBin('0')[-7:],
        "or"    : hexToBin('0')[-7:],
        "slt"   : hexToBin('0')[-7:],
        "sll"   : hexToBin('0')[-7:],
        "srl"   : hexToBin('0')[-7:],
        "sub"   : hexToBin('0')[-7:], 
    }
    
    # Registers dictionary
    registers = {
        "x0": "00000", "x1": "00001", "x2": "00010", "x3": "00011", "x4": "00100",
        "x5": "00101", "x6": "00110", "x7": "00111", "x8": "01000", "x9": "01001",
        "x10": "01010", "x11": "01011", "x12": "01100", "x13": "01101", "x14": "01110",
        "x15": "01111", "x16": "10000", "x17": "10001", "x18": "10010", "x19": "10011",
        "x20": "10100", "x21": "10101", "x22": "10110", "x23": "10111", "x24": "11000",
        "x25": "11001", "x26": "11010", "x27": "11011", "x28": "11100", "x29": "11101",
        "x30": "11110", "x31": "11111",
    }

    Rtype   = ["addw", "and", "xor", "or" , "slt", "sll", "srl", "sub"]
    Itype   = ["addiw", "andi", "jalr", "lh", "lw", "ori"]
    SBtype  = ["beq", "bne"]
    UJtype  = ["jal"]
    Utype   = ["lui"]
    Stype   = ["sb", "sw"]

    machine_code = []

    # Process each line of assembly code
    for line in assembly_code.strip().split("\n"):
        parts = line.split()
        instruction = parts[0]
        
        if instruction in Rtype:
            rd = registers[parts[1]]
            rs1 = registers[parts[2]]
            rs2 = registers[parts[3]]
            opcode = opcodes[instruction]
            funct3 = func3[instruction]
            funct7 = func7[instruction]
            binary = f"{funct7}{rs2}{rs1}{funct3}{rd}{opcode}"

        elif instruction in ["lw", "lh"]:
            rd = registers[parts[1]]
            offset, rs1 = parts[2].split("(")
            rs1 = rs1.rstrip(")")
            rs1_bin = registers[rs1]
            imm = to_twos_complement(int(offset), 12)
            opcode = opcodes[instruction]
            funct3 = func3[instruction]
            binary = f"{imm}{rs1_bin}{funct3}{rd}{opcode}"

        elif instruction == "jalr":
            rd = registers[parts[1]]
            offset, rs1 = parts[2].split("(")
            rs1 = rs1.rstrip(")")
            rs1_bin = registers[rs1]
            imm = to_twos_complement(int(offset), 12)
            opcode = opcodes[instruction]
            funct3 = func3[instruction]
            binary = f"{imm}{rs1_bin}{funct3}{rd}{opcode}"
        
        elif instruction in Itype:
            rd = registers[parts[1]]
            rs1 = parts[2]
            rs1_bin = registers[rs1]
            imm = to_twos_complement(int(parts[3]), 12)
            opcode = opcodes[instruction]
            funct3 = func3[instruction]
            binary = f"{imm}{rs1_bin}{funct3}{rd}{opcode}"

        elif instruction in Stype:
            rs2 = registers[parts[1]]
            offset, rs1 = parts[2].split("(")
            rs1 = rs1.rstrip(")")
            rs1_bin = registers[rs1]
            imm = to_twos_complement(int(offset), 12)
            imm_high = imm[:7]
            imm_low = imm[7:]
            opcode = opcodes[instruction]
            funct3 = func3[instruction]
            binary = f"{imm_high}{rs2}{rs1_bin}{funct3}{imm_low}{opcode}"

        # beq x1 x2 10 (L10)
        elif instruction in SBtype:
            rs1 = registers[parts[1]]
            rs2 = registers[parts[2]]
            imm = to_twos_complement(int(parts[3]), 12)
            imm_high = imm[:7]
            imm_low = imm[7:]
            opcode = opcodes[instruction]
            funct3 = func3[instruction]
            binary = f"{imm_high}{rs2}{rs1}{funct3}{imm_low}{opcode}"
        
        elif instruction in Utype:
            rd = registers[parts[1]]
            imm = to_twos_complement(int(parts[2]), 20)
            opcode = opcodes[instruction]
            binary = f"{imm}{rd}{opcode}"

        elif instruction in UJtype:
            rd = registers[parts[1]]
            imm = to_twos_complement(int(parts[2]), 20)
            opcode = opcodes[instruction]
            binary = f"{imm}{rd}{opcode}"

        elif instruction == "halt":
            allOnes = hexToBin("FFFFFFFF")
            binary = f"{allOnes}"

        else:
            raise ValueError(f"Unsupported instruction: {instruction}")

        machine_code.append(f"{binary}")

    return machine_code

benchmark1 = """
addiw x1 x0 20      
addiw x2 x0 15      
addw x3 x1 x2       
sub x4 x3 x1        
andi x5 x1 15     
xor x6 x2 x1        
or x7 x5 x6         
ori x8 x7 255      
halt
"""

benchmark2 = """
addiw x2 x0 10   
addiw x3 x0 20   
addiw x5 x0 30   
addw x1 x2 x3    
addw x4 x1 x5    
addw x6 x1 x4    
halt
"""

benchmark3 = """
addiw x1 x0 0         
addiw x2 x0 10        
addiw x3 x0 0          
addw x3 x3 x1       
addiw x1 x1 1       
bne x1 x2 -4      
halt
"""

benchmark4 = """
addiw x1 x0 32   
addiw x2 x0 100  
addiw x3 x0 200  
sw x2 0(x1)      
sw x3 4(x1)      
lw x4 0(x1)      
lw x5 4(x1)   
halt   
"""

benchmark5 = """
addiw x1 x0 15      
addiw x2 x0 10      
slt x3 x1 x2        
beq x3 x0 8        
addiw x4 x0 1       
beq x0 x0 4      
addiw x4 x0 0  
addiw x5 x0 42 
halt
"""

benchmark6 = """
addiw x1 x0 32
addiw x2 x0 -8
addw x3 x1 x2 
addw x4 x3 x3 
sub x5 x4 x3  
sw x5 -4(x5)  
lw x6 -4(x3)  
sw x6 -20(x6) 
lw x7 8(x6)  
addw x8 x7 x3 
addw x8 x4 x3 
addw x9 x8 x0 
addw x0 x9 x8 
halt
"""

testing = """ 
addiw x1 x0 4
jalr x2 8(x1)
addiw x5 x0 1
halt
"""
weirdInstrucitons = """
addiw x1 x0 4
lh x3 0(x1)
addiw x5 x0 36
sb x1 0(x5)
lw x10 0(x5)
halt
"""

machine_code = assemble_riscv(weirdInstrucitons)
memAdd = 0
for line in machine_code:
    hexString = format(int(line, 2), '08x')

    print(f"memory[{memAdd}]\t<= 8'h{hexString[-2:]};")
    print(f"memory[{memAdd + 1}]\t<= 8'h{hexString[-4:-2]};")
    print(f"memory[{memAdd + 2}]\t<= 8'h{hexString[-6:-4]};")
    print(f"memory[{memAdd + 3}]\t<= 8'h{hexString[-8:-6]};\n")
    memAdd = memAdd + 4