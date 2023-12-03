extends Node2D

#@onready var input_lines := FileAccess.open("res://day2/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day2/input.txt", FileAccess.READ).get_as_text().split("\n")

func _ready():
  print("Day 2")
  part_one(input_lines)
  part_two(input_lines)

func part_one(lines:PackedStringArray):
  var id_sum := 0
  var limits := {"red": 12, "green": 13, "blue": 14}
  var line_num := 1
  
  for line in Array(lines).filter(func(x): return x != ""):
    var max_values := get_max_values(line, limits.keys())
    var is_possible := true

    for color in limits:
      if max_values[color] > limits[color]:
        is_possible = false
        break
    if is_possible:
      id_sum += line_num
    
    line_num += 1
      
  print("Part One: ", id_sum)
  
func part_two(lines:PackedStringArray):
  var power_sum := 0
  var colors := ["red", "green", "blue"]
  
  for line in Array(lines).filter(func(x): return x != ""):
    var max_values := get_max_values(line, colors)
    var power := 1
    for v in max_values.values():
      power *= v
    power_sum += power
    
  print("Part Two: ", power_sum)
  
func get_max_values(line:String, colors:Array) -> Dictionary:
  var regex := RegEx.new()
  var re_array := []
  for color in colors:
    re_array.append(r"(?<{c}>\d+) {c}".format({"c": color}))
  regex.compile(r"|".join(re_array))
  
  var max_values := {}
  for color in colors:
    max_values[color] = 0
  var matches := regex.search_all(line)
  if matches.is_empty():
    return max_values
      
  for m in matches:
    for color in colors:
      var value := m.get_string(color)
      if !value.is_empty() and int(value) > max_values[color]:
        max_values[color] = int(value)

  return max_values
