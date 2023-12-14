extends Node2D

#@onready var input_lines := FileAccess.open("res://day14/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day14/input.txt", FileAccess.READ).get_as_text().split("\n")

func _ready():
  print("Day 14")
  part_one(input_lines)
  
func part_one(input_lines:PackedStringArray) -> void:
  var total_load := 0
  var platform := Array(input_lines).filter(func(x): return x != "")
  var stopped_rocks := []
  var mobile_rocks := true
  
  while mobile_rocks:
    mobile_rocks = false
    for y in platform.size():
      if y == 0:
        continue
      for x in platform[y].length():
        if platform[y][x] == "O" && platform[y-1][x] == ".":
          platform[y-1][x] = "O"
          platform[y][x] = "."
          mobile_rocks = true
          
  for i in platform.size():
    total_load += platform[i].count("O") * (platform.size() - i)
    
  platform.map(func(x): print(x))
        
  print("Part One: ", total_load)
