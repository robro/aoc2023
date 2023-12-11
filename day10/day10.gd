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
  var steps := 0
  
  func _init(character:String, location:Vector2):
    self.character = character
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
    return directions[self.character]
    
  func _to_string() -> String:
    return str(self.location)
    
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
  var loop_grid := []
  var row_string:String
  var is_inside = false
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
  var offset:Vector2
  
  for pipe in get_connecting_pipes(grid, start_pipe):
    offset = start_pipe.location - pipe.location
    starting_offsets.append(offset)
    
  var start_character = directions["".join(starting_offsets.map(func(x): return offsets[x]))]
  start_pipe.character = start_character
  
  var inside_total := 0
  for row in grid:
    row_string = ""
    is_inside = false
    
    for item in row:
      if item is Pipe && loop_pipes.has(str(item)):
        row_string += " "
        if "N" in item.get_pointing():
          is_inside = !is_inside
      else:
        if is_inside:
          row_string += "I"
          inside_total += 1
        else:
          row_string += "O"
          
    loop_grid.append(row_string)
    
  #loop_grid.map(func(x): print(x))
  print("Part Two: ", inside_total)
  
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
  
func get_loop_pipes(grid:Array[Array]) -> Dictionary:
  var current_pipe:Pipe
  var connecting_pipes:Array[Pipe]
  var pipes_traveled := {}
  var pipes_to_travel:Array[Pipe] = [get_start_pipe(grid)]
  
  while true:
    current_pipe = pipes_to_travel.pop_front()
    pipes_traveled[str(current_pipe)] = current_pipe
    connecting_pipes = get_connecting_pipes(grid, current_pipe).filter(
      func(x): return !pipes_traveled.has(str(x))
    )
    if connecting_pipes.size() == 0:
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
  for direction in pipe.get_pointing():
    check_offsets[direction] = offsets[direction]
    
  var check_loc:Vector2
  var check_pipe:Pipe
  
  for offset in check_offsets:
    check_loc = pipe.location + check_offsets[offset]
    check_pipe = grid[check_loc.y][check_loc.x]
    if check_pipe is Pipe:
      if connections[offset] in check_pipe.get_pointing():
        connecting_pipes.append(check_pipe)

  return connecting_pipes
