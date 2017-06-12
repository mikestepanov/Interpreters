def interpret(code)
	code = code.split("\n")
	print code.each{|line| puts line}; puts
	stack = []
	loc = [0, 0]
	skip = false
	str_mode = false
	direction = "right"
	output = []
	until code[loc[0]][loc[1]] == "@"
		if skip == true
			skip = false
			loc = charge!(loc, direction)
			next
		end
		if str_mode == true && code[loc[0]][loc[1]] != "\""
			stack << code[loc[0]][loc[1]].ord
			loc = charge!(loc, direction)
			next
		end
		case code[loc[0]][loc[1]]
			when  /[[:digit:]]/
				stack << code[loc[0]][loc[1]].to_i
			when "+"
				stack << (stack.pop + stack.pop)
			when "-"
				a = stack.pop
				b = stack.pop
				stack << (b - a)
			when "*"
				stack << (stack.pop * stack.pop)
			when "/"
				a = stack.pop
				b = stack.pop
				a != 0 ? stack << (b / a) : stack << 0
			when "%"
				a = stack.pop
				b = stack.pop
				a != 0 ? stack << (b % a) : stack << 0
			when "!"
				stack.pop == 0 ? stack << 1 : stack << 0
			when "`"
				a = stack.pop
				b = stack.pop
				b > a ? stack << 1 : stack << 0
			when ">"
				direction = "right"
			when "<"
				direction = "left"
			when "^"
				direction = "up"
			when "v"
				direction = "down"
			when "?"
				direction = ["right", "left", "up", "down"][rand(4)]
				loc = charge!(loc, direction)
				next
			when "_"
				val = stack.pop
				val == 0 ? direction = "right" : direction = "left"
			when "|"
				val = stack.pop
				val == 0 ? direction = "down" : direction = "up"
			when "\""
				if str_mode == true
					str_mode = false
				else
					str_mode = true
				end
			when "\\"
				stack[1] = 0 if stack[1].nil? 
				stack[-1], stack[-2] = stack[-2], stack[-1]
			when "$"
				stack.pop
			when ":"
				if stack.empty?
					stack << 0
				else
					stack << stack[-1]
				end
			when "."
				if !stack.nil?
					output << stack.pop
				end
			when ","
				output << stack.pop.chr
			when "#"
				skip = true
			when "g"
				y = stack.pop
				x = stack.pop
				stack << code[y][x].ord
			when "p"
				y = stack.pop
				x = stack.pop	
				value = stack.pop
				code[y][x] = value.chr
		end
		loc = charge!(loc, direction)
	end
	output.join
end

def charge!(loc, direction)
	case direction
		when "up"
			loc[0] -= 1
		when "down"
			loc[0] += 1
		when "left"
			loc[1] -= 1
		when "right"
			loc[1] += 1
	end
	loc
end