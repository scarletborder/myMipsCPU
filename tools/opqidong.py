def isop(c):
    if c == "0":
        return "~"
    else:
        return ""


if __name__ == "__main__":
    while True:
        op = input()
        print(len(op))
        if op == "e":
            exit()
        elif len(op) != 6:
            print("sb op")
        else:
            print(
                f"={isop(op[0])}opcode[5]&{isop(op[1])}opcode[4]& {isop(op[2])}opcode[3]&{isop(op[3])}opcode[2]&{isop(op[4])}opcode[1]&{isop(op[5])}opcode[0]"
            )
            print(
                f"={isop(op[0])}Funct[5]&{isop(op[1])}Funct[4]& {isop(op[2])}Funct[3]&{isop(op[3])}Funct[2]&{isop(op[4])}Funct[1]&{isop(op[5])}Funct[0]"
            )
