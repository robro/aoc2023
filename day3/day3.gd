extends Node2D

#@onready var input_lines := FileAccess.open("res://day3/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day3/input.txt", FileAccess.READ).get_as_text().split("\n")

func _ready():
  print("Day 3")
  part_one(Array(input_lines).filter(func(x): return x != ""))
  part_two(Array(input_lines).filter(func(x): return x != ""))

func part_one(lines:Array):
  var sum := 0
  var nums_and_syms := get_nums_and_syms(lines)
  var numbers = nums_and_syms[0]
  var symbols = nums_and_syms[1]

  for num in numbers:
    var num_value := int(num[0])
    if is_adjacent(num, symbols):
      sum += num_value
    
  print("Part One: ", sum)
  
func part_two(lines:Array):
  var sum := 0
  var nums_and_syms := get_nums_and_syms(lines)
  var numbers = nums_and_syms[0]
  var symbols = nums_and_syms[1]
  
  for sym in symbols:
    var sym_type:String = sym[0]
    if sym_type != "*":
      continue
    var adjacent_nums := get_adjacent_nums(sym, numbers)
    if adjacent_nums.size() == 2:
      var gear_ratio := 1
      for num in adjacent_nums:
        gear_ratio *= num
      sum += gear_ratio
      
  print("Part Two: ", sum)
  
func get_nums_and_syms(lines:Array) -> Array:
  var regex := RegEx.new()
  var symbol_re := r"[^\d\.]"
  var number_re := r"\d+"
  var symbols := []
  var numbers := []
  var y := 0
  
  for line in lines:
    regex.compile(symbol_re)
    var match_symbols := regex.search_all(line)
    for m in match_symbols:
      symbols.append([m.get_string(), Vector2(m.get_start(), y)])
    regex.compile(number_re)
    var match_numbers := regex.search_all(line)
    for m in match_numbers:
      numbers.append([m.get_string(), Vector2(m.get_start(), y), m.get_end()-m.get_start()])
    y += 1
    
  return [numbers, symbols]

func is_adjacent(num:Array, symbols:Array) -> bool:
  var num_coord:Vector2 = num[1]
  var num_len:int = num[2]
  
  for sym in symbols:
    var sym_coord:Vector2 = sym[1]
    for i in range(num_len):
      var distance = sym_coord.distance_to(num_coord + Vector2(i, 0))
      if distance < 2:
        return true
        
  return false
  
func get_adjacent_nums(sym:Array, numbers:Array) -> Array:
  var adjacent_nums := []
  var sym_type:String = sym[0]
  var sym_coord:Vector2 = sym[1]
  var adjacent_count := 0
  
  for num in numbers:
    var num_value := int(num[0])
    var num_coord:Vector2 = num[1]
    var num_len:int = num[2]
    
    for i in range(num_len):
      var distance = sym_coord.distance_to(num_coord + Vector2(i, 0))
      if distance < 2:
        adjacent_nums.append(num_value)
        break
  
  return adjacent_nums
