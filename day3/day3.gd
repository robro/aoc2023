extends Node2D

class EnginePart extends Node2D:
  var _value := ""
  var _location := Vector2()
  var _size := 0
  
  func _init(value:String, location:Vector2, size:int):
    _value = value
    _location = location
    _size = size

#@onready var input_lines := FileAccess.open("res://day3/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day3/input.txt", FileAccess.READ).get_as_text().split("\n")

func _ready():
  print("Day 3")
  var parts := get_engine_parts(input_lines)
  part_one(parts)
  part_two(parts)

func part_one(parts:Dictionary):
  var sum := 0
  
  for num in parts["numbers"]:
    if is_adjacent(num, parts["symbols"]):
      sum += int(num._value)
    
  print("Part One: ", sum)
  
func part_two(parts:Dictionary):
  var sum := 0
  var adjacent_nums:Array[EnginePart]
  var gear_ratio:int
  
  for sym in parts["symbols"]:
    if sym._value != "*":
      continue
    adjacent_nums = get_adjacent_nums(sym, parts["numbers"])
    if adjacent_nums.size() != 2:
      continue
    gear_ratio = 1
    for num in adjacent_nums:
      gear_ratio *= int(num._value)
    sum += gear_ratio
      
  print("Part Two: ", sum)
  
func get_engine_parts(lines:Array) -> Dictionary:
  var regex := RegEx.new()
  var num_re := r"\d+"
  var sym_re := r"[^\d\.]"
  var parts := {"numbers": [], "symbols": []}
  var y := 0
  
  for line in lines:
    parts["numbers"].append_array(get_parts_in_line(line, regex, num_re, y))
    parts["symbols"].append_array(get_parts_in_line(line, regex, sym_re, y))
    y += 1
    
  return parts
  
func get_parts_in_line(line:String, regex:RegEx, re_str:String, y:int) -> Array[EnginePart]:
  var parts:Array[EnginePart] = []
  regex.compile(re_str)
  var matches = regex.search_all(line)
  for m in matches:
    parts.append(EnginePart.new(
      m.get_string(), 
      Vector2(m.get_start(), y), 
      m.get_end()-m.get_start()
    ))
    
  return parts

func is_adjacent(num:EnginePart, symbols:Array) -> bool:  
  for sym in symbols:
    for i in range(num._size):
      if sym._location.distance_to(num._location + Vector2(i, 0)) < 2:
        return true
        
  return false
  
func get_adjacent_nums(sym:EnginePart, numbers:Array) -> Array[EnginePart]:
  var adjacent_nums:Array[EnginePart] = []
  
  for num in numbers:
    for i in range(num._size):
      if sym._location.distance_to(num._location + Vector2(i, 0)) < 2:
        adjacent_nums.append(num)
        break
  
  return adjacent_nums
