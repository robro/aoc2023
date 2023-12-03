extends Node2D

#@onready var input_lines := FileAccess.open("res://day2/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day2/input.txt", FileAccess.READ).get_as_text().split("\n")
@onready var regex := RegEx.new()

func _ready():
  print("Day 2")
  part_one(input_lines)
  part_two(input_lines)

func part_one(games:PackedStringArray):
  var id_sum := 0
  var limits := {
    "red": 12,
    "green": 13,
    "blue": 14
  }
  var re_array := [r"Game (?<game>\d+)"]
  for color in limits:
    re_array.append(r"(?<{c}>\d+) {c}".format({"c": color}))
  regex.compile(r"|".join(re_array))
  
  for game in games:
    var matches := regex.search_all(game)
    if matches.is_empty():
      continue
      
    var is_possible := true
    var game_id:int
    
    for m in matches:
      var id_str := m.get_string("game")
      if !id_str.is_empty():
        game_id = int(id_str)
      for limit in limits:
        var value := m.get_string(limit)
        if !value.is_empty() and int(value) > limits[limit]:
          is_possible = false
          break
          
    if is_possible:
      id_sum += game_id
      
  print("Part One: ", id_sum)
  
func part_two(games:PackedStringArray):
  var power_sum := 0
  var values := {"red": 0, "green": 0, "blue": 0}
  var re_array := []
  for color in values:
    re_array.append(r"(?<{c}>\d+) {c}".format({"c": color}))
  regex.compile(r"|".join(re_array))
  
  for game in games:
    for key in values:
      values[key] = 0
    var matches := regex.search_all(game)
    if matches.is_empty():
      continue
    
    for m in matches:
      for color in values:
        var value := m.get_string(color)
        if !value.is_empty() and int(value) > values[color]:
          values[color] = int(value)
          
    var power := 1
    for v in values.values():
      power *= v
    power_sum += power
    
  print("Part Two: ", power_sum)
