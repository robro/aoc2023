extends Node2D

#@onready var input_lines := FileAccess.open("res://day10/example_1.txt", FileAccess.READ).get_as_text().split("\n")
#@onready var input_lines := FileAccess.open("res://day10/example_2.txt", FileAccess.READ).get_as_text().split("\n")
#@onready var input_lines := FileAccess.open("res://day10/example_3.txt", FileAccess.READ).get_as_text().split("\n")
#@onready var input_lines := FileAccess.open("res://day10/example_4.txt", FileAccess.READ).get_as_text().split("\n")
#@onready var input_lines := FileAccess.open("res://day10/example_5.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day10/input.txt", FileAccess.READ).get_as_text().split("\n")

class Pipe:
  var type := ""
  var location := Vector2.ZERO
  var steps := 0
  
  func _init(type:String, location:Vector2):
    self.type = type
    self.location = location
    
  func get_pointing() -> String:
    var directions := {
      "|": "NS",
      "-": "EW",
      "L": "NE",
      "J": "NW",
      "7": "SW",
      "F": "SE",
      "S": "NSEW",
    }
    return directions[self.type]
    
func _ready():
  print("Day 10")
  part_one(input_lines)
  part_two(input_lines)
  
func part_one(input_lines:PackedStringArray):
  var grid := get_grid(Array(input_lines).filter(func(x): return x != ""))
  var loop_pipes := get_loop_pipes(grid)
  var steps := 0
  
  for pipe in loop_pipes.values():
    steps = max(steps, pipe.steps)
    
  print("Part One: ", steps)
  
func part_two(input_lines:PackedStringArray):
  var grid := get_grid(Array(input_lines).filter(func(x): return x != ""))
  var loop_pipes := get_loop_pipes(grid)
  var start_pipe := get_start_pipe(grid)
  start_pipe.type = get_pipe_type(grid, start_pipe)
  var is_inside = false
  var inside_total := 0
  
  for row in grid:
    is_inside = false
    for item in row:
      if loop_pipes.has(item):
        if "N" in item.get_pointing():
          is_inside = !is_inside
      elif is_inside:
        inside_total += 1
    
  print("Part Two: ", inside_total)
  
func get_pipe_type(grid:Array[Array], pipe:Pipe) -> String:
  var characters := {
    "NS": "|",
    "EW": "-",
    "NE": "L",
    "NW": "J",
    "SW": "7",
    "SE": "F",
  }
  var directions := {
    Vector2(0, -1): "S",
    Vector2(0, 1): "N",
    Vector2(1, 0): "W",
    Vector2(-1, 0): "E",
  }
  var offsets := []
  for connecting_pipe in get_connecting_pipes(grid, pipe):
    offsets.append(pipe.location - connecting_pipe.location)
    
  return characters["".join(offsets.map(func(x): return directions[x]))]
  
func get_grid(input_lines:Array) -> Array[Array]:
  var grid:Array[Array] = []
  var row:Array
  var type:String
  
  for y in input_lines.size():
    row = []
    for x in input_lines[y].length():
      type = input_lines[y][x]
      if type == ".":
        row.append(null)
      else:
        row.append(Pipe.new(type, Vector2(x, y)))
        
    grid.append(row)
    
  return grid
  
func get_loop_pipes(grid:Array[Array]) -> Dictionary:
  var current_pipe:Pipe
  var connecting_pipes:Array[Pipe]
  var pipes_traveled := {}
  var pipes_to_travel:Array[Pipe] = [get_start_pipe(grid)]
  
  while true:
    current_pipe = pipes_to_travel.pop_front()
    pipes_traveled[current_pipe] = current_pipe
    connecting_pipes = get_connecting_pipes(grid, current_pipe).filter(
      func(x): return !pipes_traveled.has(x)
    )
    if connecting_pipes.is_empty():
      break
    for pipe in connecting_pipes:
      pipe.steps = current_pipe.steps + 1
      pipes_to_travel.append(pipe)
      
  return pipes_traveled
  
func get_start_pipe(grid:Array[Array]) -> Pipe:
  var start_pipe:Pipe
  
  for row in grid:
    for item in row:
      if !(item is Pipe):
        continue
      if item.type == "S":
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
  var inversions := {
    "N": "S",
    "S": "N",
    "E": "W",
    "W": "E"
  }
  var check_offsets := {}
  for direction in pipe.get_pointing():
    check_offsets[direction] = offsets[direction]
    
  var check_loc:Vector2
  var check_pipe:Pipe
  
  for direction in check_offsets:
    check_loc = pipe.location + check_offsets[direction]
    check_pipe = grid[check_loc.y][check_loc.x]
    if !(check_pipe is Pipe):
      continue
    if inversions[direction] in check_pipe.get_pointing():
      connecting_pipes.append(check_pipe)

  return connecting_pipes
