extends Node2D

#@onready var input_lines := FileAccess.open("res://day10/example_1.txt", FileAccess.READ).get_as_text().split("\n")
#@onready var input_lines := FileAccess.open("res://day10/example_2.txt", FileAccess.READ).get_as_text().split("\n")
#@onready var input_lines := FileAccess.open("res://day10/example_3.txt", FileAccess.READ).get_as_text().split("\n")
#@onready var input_lines := FileAccess.open("res://day10/example_4.txt", FileAccess.READ).get_as_text().split("\n")
#@onready var input_lines := FileAccess.open("res://day10/example_5.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day10/input.txt", FileAccess.READ).get_as_text().split("\n")

class Pipe:
  var character := ""
  var location := Vector2.ZERO
  var offsets := ""
  var steps := 0
  
  func _init(character:String, location:Vector2):
    self.character = character
    self.location = location
    var directions := {
      "|": "NS",
      "-": "EW",
      "L": "NE",
      "J": "NW",
      "7": "SW",
      "F": "SE",
      "S": "NSEW",
    }
    self.offsets = directions[character]
    
  func get_shape() -> Array[String]:
    var shapes = {
      "N": Vector2(1, 0),
      "S": Vector2(1, 2),
      "E": Vector2(2, 1),
      "W": Vector2(0, 1),
    }
    var shape:Array[String] = ["...", ".+.", "..."]
    for offset in self.offsets:
      var location = shapes[offset]
      shape[location.y][location.x] = "+"
      
    return shape
    
func _ready():
  print("Day 10")
  part_one(input_lines)
  part_two(input_lines)
  
func part_one(input_lines:PackedStringArray):
  var grid := get_grid(Array(input_lines).filter(func(x): return x != ""))
  var steps := 0
  
  for pipe in get_loop_pipes(grid):
    steps = max(steps, pipe.steps)
    
  print("Part One: ", steps)
  
func part_two(input_lines:PackedStringArray):
  var grid := get_grid(Array(input_lines).filter(func(x): return x != ""))
  var loop_pipes := get_loop_pipes(grid)
  var big_grid := get_big_grid(grid)
  var start_pipe := get_start_pipe(grid)
  var starting_offsets := []
  var directions := {
    "NS": "|",
    "EW": "-",
    "NE": "L",
    "NW": "J",
    "SW": "7",
    "SE": "F",
  }
  var offsets := {
    Vector2(0, -1): "S",
    Vector2(0, 1): "N",
    Vector2(1, 0): "W",
    Vector2(-1, 0): "E",
  }
  for pipe in get_connecting_pipes(grid, start_pipe):
    var offset := start_pipe.location - pipe.location
    starting_offsets.append(offset)
    
  var start_character = directions["".join(starting_offsets.map(func(x): return offsets[x]))]
  loop_pipes[0] = Pipe.new(start_character, start_pipe.location)
  
  for pipe in loop_pipes:
    var new_location := pipe.location * 3
    var shape := pipe.get_shape()
    for shape_y in shape.size():
      for shape_x in shape[0].length():
        big_grid[new_location.y + shape_y][new_location.x + shape_x] = shape[shape_y][shape_x]
  
  var locations_to_check:Array[Vector2] = [Vector2.ZERO]
  var checked_locations:Array[Vector2] = []
  var next_locations:Array[Vector2]
  var current_location:Vector2
  
  while true:
    current_location = locations_to_check.pop_back()
    checked_locations.append(current_location)
    big_grid[current_location.y][current_location.x] = "O"
    next_locations = get_adjacent_nonloops(big_grid, current_location).filter(
      func(x): return x not in checked_locations
    )
    if next_locations.size() == 0 && locations_to_check.size() == 0:
      break
    locations_to_check.append_array(next_locations)
    
  #print_grid(big_grid)     
  var inside_total := 0
  
  for y in range(0, big_grid.size(), 3):
    for x in range(0, big_grid[0].size(), 3):
      var characters := ""
      for i in 3:
        for j in 3:
          characters += big_grid[y+i][x+j]
      if characters == ".........":
        inside_total += 1
    
  print("Part Two: ", inside_total)
  
func print_grid(grid:Array[Array]) -> void:
  for row in grid:
    print("".join(row))
  
func get_all_locations(grid:Array[Array]) -> Array[Vector2]:
  var all_locations:Array[Vector2] = []
  
  for y in grid.size():
    for x in grid[y].size():
      all_locations.append(Vector2(x, y))
      
  return all_locations
  
func get_adjacent_nonloops(grid:Array[Array], location:Vector2) -> Array[Vector2]:
  var nonloops:Array[Vector2] = []
  var check_location:Vector2
  var offsets := [
    Vector2(0, -1),
    Vector2(0, 1),
    Vector2(1, 0),
    Vector2(-1, 0),
    Vector2(-1, -1),
    Vector2(-1, 1),
    Vector2(1, -1),
    Vector2(1, 1),
  ]
  for offset in offsets:
    check_location = location + offset
    if check_location.y < 0 || check_location.y >= grid.size():
      continue
    if check_location.x < 0 || check_location.x >= grid[0].size():
      continue
    if grid[check_location.y][check_location.x] == ".":
      nonloops.append(check_location)
    
  return nonloops
  
func get_grid(input_lines:Array) -> Array[Array]:
  var grid:Array[Array] = []
  var row:Array
  var character:String
  
  for y in input_lines.size():
    row = []
    for x in input_lines[y].length():
      character = input_lines[y][x]
      if character == ".":
        row.append(null)
      else:
        row.append(Pipe.new(character, Vector2(x, y)))
        
    grid.append(row)
    
  return grid
  
func get_big_grid(grid:Array[Array]) -> Array[Array]:
  var big_grid:Array[Array] = []
  for i in grid.size() * 3:
    var row := []
    row.resize(grid[0].size() * 3)
    row.fill(".")
    big_grid.append(row)
  
  return big_grid
  
func get_loop_pipes(grid:Array[Array]) -> Array[Pipe]:
  var current_pipe:Pipe
  var connecting_pipes:Array[Pipe]
  var pipes_traveled:Array[Pipe] = []
  var pipes_to_travel:Array[Pipe] = [get_start_pipe(grid)]
  
  while true:
    current_pipe = pipes_to_travel.pop_front()
    pipes_traveled.append(current_pipe)
    connecting_pipes = get_connecting_pipes(grid, current_pipe).filter(
      func(x): return x not in pipes_traveled
    )
    if connecting_pipes.size() == 0:
      break
    for connecting_pipe in connecting_pipes:
      connecting_pipe.steps = current_pipe.steps + 1
      pipes_to_travel.append(connecting_pipe)
      
  return pipes_traveled
  
func get_start_pipe(grid:Array[Array]) -> Pipe:
  var start_pipe:Pipe
  
  for row in grid:
    for item in row:
      if !(item is Pipe):
        continue
      if item.character == "S":
        start_pipe = item
        return start_pipe
        
  return start_pipe
  
func get_connecting_pipes(grid:Array, pipe:Pipe) -> Array[Pipe]:
  var connecting_pipes:Array[Pipe] = []
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
  for direction in pipe.offsets:
    check_offsets[direction] = offsets[direction]
    
  var check_loc:Vector2
  var check_pipe:Pipe
  
  for offset in check_offsets:
    check_loc = pipe.location + check_offsets[offset]
    check_pipe = grid[check_loc.y][check_loc.x]
    if check_pipe is Pipe:
      if connections[offset] in check_pipe.offsets:
        connecting_pipes.append(check_pipe)

  return connecting_pipes
