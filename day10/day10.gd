extends Node2D

#@onready var input_lines := FileAccess.open("res://day10/example_1.txt", FileAccess.READ).get_as_text().split("\n")
#@onready var input_lines := FileAccess.open("res://day10/example_2.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day10/input.txt", FileAccess.READ).get_as_text().split("\n")

class Pipe:
  var char := ""
  var location := Vector2.ZERO
  var steps := 0
  var map := {
    "|": "NS",
    "-": "EW",
    "L": "NE",
    "J": "NW",
    "7": "SW",
    "F": "SE",
    "S": "NSEW",
  }
  
  func _init(char:String, location:Vector2):
    self.char = char
    self.location = location
    
  func get_offsets():
    return self.map[self.char]

func _ready():
  print("Day 10")
  part_one(input_lines)
  
func part_one(input_lines:PackedStringArray):
  input_lines = Array(input_lines).filter(func(x): return x != "") as Array[String]
  var row:Array
  var char:String
  var pipe:Pipe
  var grid := []
  var start_pipe:Pipe
  
  for y in input_lines.size():
    row = []
    for x in input_lines[y].length():
      char = input_lines[y][x]
      if char == ".":
        row.append(null)
      else:
        pipe = Pipe.new(char, Vector2(x, y))
        if char == "S":
          start_pipe = pipe
        row.append(pipe)
        
    grid.append(row)
  
  var current_pipe:Pipe
  var connecting_pipes:Array[Pipe]
  var pipes_traveled:Array[Pipe] = []
  var pipes_to_travel:Array[Pipe] = [start_pipe]
  var steps := 0
  
  while true:
    current_pipe = pipes_to_travel.pop_front()
    pipes_traveled.append(current_pipe)
    connecting_pipes = get_connecting_pipes(grid, current_pipe).filter(
      func(x): return x not in pipes_traveled
    )
    if connecting_pipes.size() == 0:
      steps = current_pipe.steps
      break
    for connecting_pipe in connecting_pipes:
      connecting_pipe.steps = current_pipe.steps + 1
      pipes_to_travel.append(connecting_pipe)
    
  print("Part One: ", steps)
  
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
  for direction in pipe.get_offsets():
    check_offsets[direction] = offsets[direction]
    
  var check_loc:Vector2
  var check_pipe:Pipe
  
  for offset in check_offsets:
    check_loc = pipe.location + check_offsets[offset]
    check_pipe = grid[check_loc.y][check_loc.x]
    if check_pipe is Pipe:
      if connections[offset] in check_pipe.get_offsets():
        connecting_pipes.append(check_pipe)

  return connecting_pipes
