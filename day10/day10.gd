extends Node2D

#@onready var input_lines := FileAccess.open("res://day10/example_1.txt", FileAccess.READ).get_as_text().split("\n")
#@onready var input_lines := FileAccess.open("res://day10/example_2.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day10/input.txt", FileAccess.READ).get_as_text().split("\n")

class Pipe:
  var char := ""
  var map := {
    "|": "NS",
    "-": "EW",
    "L": "NE",
    "J": "NW",
    "7": "SW",
    "F": "SE"
  }
  
  func _init(char:String):
    self.char = char
    
  func get_offsets():
    return self.map[self.char]

func _ready():
  print("Day 10")
  part_one(input_lines)
  
func part_one(input_lines:PackedStringArray):
  input_lines = Array(input_lines).filter(func(x): return x != "") as Array[String]
  var grid := []
  var start_location := Vector2.ZERO
  
  for y in input_lines.size():
    var row := []
    for x in input_lines[y].length():
      var char = input_lines[y][x]
      if char == "S":
        start_location = Vector2(x, y)
        row.append(char)
      elif char == ".":
        row.append(char)
      else:
        row.append(Pipe.new(char))
        
    grid.append(row)
    
  var locations_traveled := []
  var locations_to_travel := [{"location": start_location, "steps": 0}]
  var steps := 0
  
  while true:
    var next_location = locations_to_travel.pop_front()
    locations_traveled.append(next_location["location"])
    var connecting_locs := get_connecting(grid, next_location["location"]).filter(
      func(x): return x not in locations_traveled
    )
    if connecting_locs.size() == 0:
      steps = next_location["steps"]
      break
    for loc in connecting_locs:
      locations_to_travel.append({"location": loc, "steps": next_location["steps"] + 1})
    
  print("Part One: ", steps)
  
func get_connecting(grid:Array, location:Vector2) -> Array[Vector2]:
  var connecting:Array[Vector2] = []
  var offsets := {
    "N": Vector2(0, -1),
    "S": Vector2(0, 1),
    "E": Vector2(1, 0),
    "W": Vector2(-1, 0)
  }
  var connections := {
    "N": "S",
    "S": "N",
    "E": "W",
    "W": "E"
  }
  var check_offsets := {}
  var value = grid[location.y][location.x]
  
  if value is Pipe:
    for direction in value.get_offsets():
      check_offsets[direction] = offsets[direction]
  else:
    check_offsets = offsets

  for offset in check_offsets:
    var check_loc:Vector2 = location + offsets[offset]
    if check_loc < Vector2.ZERO:
      continue
    if check_loc.x >= grid[0].size() || check_loc.y >= grid.size():
      continue
    var check_val = grid[check_loc.y][check_loc.x]
    if check_val is Pipe:
      if connections[offset] in check_val.get_offsets():
        connecting.append(check_loc)

  return connecting
