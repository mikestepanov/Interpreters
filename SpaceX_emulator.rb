def cpuEmulator(subroutine)
    registers = label_registers
    idx = 0
    while idx < subroutine.size
        answer = move(registers, subroutine[idx])
        if answer.size == 2
            registers = answer.last
            idx = answer.first
            next
        end
        idx += 1
    end
    registers["R42"].to_s
end

def label_registers
    registers = {}
    (0...43).each do |num|
        if num < 10
            registers["R0" + num.to_s] = 0
        else
            registers["R" + num.to_s] = 0
        end
    end
    registers
end

def move(registers, command)
    command = command.split(" ")
    jump = nil
    case command.first
        when "MOV"
            loc = command.last.split(",")
            if registers.include?(loc.first)
                registers[loc[1]] = registers[loc[0]]
            else
                registers[loc[1]] = loc[0].to_i
            end
        when "ADD"
            loc = command.last.split(",")
            sum = (registers[loc[1]] + registers[loc[0]]) % (2 ** 32)
            registers[loc[0]] = sum
        when "DEC"
            loc = command.last
            if registers[loc] > 0
                registers[loc] -= 1
            else
                registers[loc] = (2 ** 32) - 1
            end
        when "INC"
            loc = command.last
            if registers[loc] == (2 ** 32) - 1
                registers[loc] = 0
            else
                registers[loc] += 1
            end
        when "INV"
            loc = command.last
            if registers[loc].zero?
                registers[loc] = (2 ** 32) - 1
            else
                registers[loc] = ~ registers[loc]
            end
        when "JMP"
            loc = command.last
            jump = loc.to_i
        when "JZ"
            loc = command.last
            jump = loc.to_i if registers["R00"].zero?
        when "NOP"
            #does nothing
    end
    jump.nil? ? registers : [jump - 1, registers]
end
