extends Node2D

class EnginePart extends Node2D:
  var _type := ""
  var _value := ""
  var _location := Vector2()
  var _size := 0
  
  func _init(type:String, value:String, location:Vector2, size:int):
    _type = type
    _value = value
    _location = location
    _size = size

#@onready var input_lines := FileAccess.open("res://day3/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day3/input.txt", FileAccess.READ).get_as_text().split("\n")

func _ready():
  print("Day 3")
  var parts := get_engine_parts(input_lines)
  var symbols := parts.filter(func(x): return x._type == "symbol")
  var numbers := parts.filter(func(x): return x._type == "number")
  part_one(numbers, symbols)
  part_two(numbers, symbols)

func part_one(numbers:Array[EnginePart], symbols:Array[EnginePart]):
  var sum := 0
  
  for num in numbers:
    if is_adjacent(num, symbols):
      sum += int(num._value)
    
  print("Part One: ", sum)
  
func part_two(numbers:Array[EnginePart], symbols:Array[EnginePart]):
  var sum := 0
  var adjacent_nums:Array[EnginePart]
  var gear_ratio:int
  
  for sym in symbols:
    if sym._value != "*":
      continue
    adjacent_nums = get_adjacent_nums(sym, numbers)
    if adjacent_nums.size() != 2:
      continue
    gear_ratio = 1
    for num in adjacent_nums:
      gear_ratio *= int(num._value)
    sum += gear_ratio
      
  print("Part Two: ", sum)
  
func get_engine_parts(lines:Array) -> Array[EnginePart]:
  var regex := RegEx.new()
  var num_re := r"\d+"
  var sym_re := r"[^\d\.]"
  var parts:Array[EnginePart] = []
  var y := 0
  
  for line in lines:
    parts.append_array(get_parts_in_line(line, regex, num_re, "number", y))
    parts.append_array(get_parts_in_line(line, regex, sym_re, "symbol", y))
    y += 1
    
  return parts
  
func get_parts_in_line(line:String, regex:RegEx, re_str:String, type:String, y:int) -> Array[EnginePart]:
  var parts:Array[EnginePart] = []
  regex.compile(re_str)
  var matches = regex.search_all(line)
  for m in matches:
    parts.append(EnginePart.new(
      type, 
      m.get_string(), 
      Vector2(m.get_start(), y), 
      m.get_end()-m.get_start()
    ))
    
  return parts

func is_adjacent(num:EnginePart, symbols:Array[EnginePart]) -> bool:  
  for sym in symbols:
    for i in range(num._size):
      if sym._location.distance_to(num._location + Vector2(i, 0)) < 2:
        return true
        
  return false
  
func get_adjacent_nums(sym:EnginePart, numbers:Array[EnginePart]) -> Array[EnginePart]:
  var adjacent_nums:Array[EnginePart] = []
  
  for num in numbers:
    for i in range(num._size):
      if sym._location.distance_to(num._location + Vector2(i, 0)) < 2:
        adjacent_nums.append(num)
        break
  
  return adjacent_nums
