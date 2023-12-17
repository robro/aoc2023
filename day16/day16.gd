extends Node2D

#@onready var input_lines := FileAccess.open("res://day16/example_1.txt", FileAccess.READ).get_as_text().split("\n", false)
#@onready var input_lines := FileAccess.open("res://day16/example_2.txt", FileAccess.READ).get_as_text().split("\n", false)
@onready var input_lines := FileAccess.open("res://day16/input.txt", FileAccess.READ).get_as_text().split("\n", false)

const rotations := {
  "RIGHT": PI/2,
  "LEFT": -PI/2
}

const directions := [
  Vector2.UP,
  Vector2.DOWN,
  Vector2.LEFT,
  Vector2.RIGHT,
]

class LightBeam:
  var position:Vector2
  var direction:Vector2

  func _init(pos:Vector2, dir:Vector2):
    self.position = pos
    self.direction = dir

  func get_next_pos() -> Vector2:
    return self.position + self.direction

  func _to_string() -> String:
    return "[{pos}, {dir}]".format({"pos": self.position, "dir": self.direction})

func _ready():
  print("Day 16")
  print("Part One: ", part_one())
  print("Part Two: ", part_two())

func part_one() -> int:
  return get_energized_count(LightBeam.new(Vector2(-1, 0), Vector2.RIGHT))
  
func part_two() -> int:
  var energized_count := 0
  var starting_beams:Array[LightBeam] = []
  var start_position:Vector2
  
  for d in directions:
    for i in len(input_lines):
      if d.x == 0:
        start_position = Vector2(i, 0) - d
      elif d.y == 0:
        start_position = Vector2(0, i) - d
      starting_beams.append(LightBeam.new(start_position, d))

  for beam in starting_beams:
    energized_count = max(energized_count, get_energized_count(beam))
    
  return energized_count
  
func get_energized_count(start_beam:LightBeam) -> int:
  var beams := {}
  var current_beam:LightBeam
  var beams_to_test:Array[LightBeam] = [start_beam]
  var next_position:Vector2
  var next_char:String
  var next_rotations:Array[float]

  while !beams_to_test.is_empty():
    current_beam = beams_to_test.pop_front()
    if beams.has(current_beam.position):
      if current_beam.direction in beams[current_beam.position]:
        continue
      else:
        beams[current_beam.position].append(current_beam.direction)
    else:
      beams[current_beam.position] = [current_beam.direction]
    next_position = current_beam.get_next_pos()
    if next_position.x < 0 || next_position.x >= len(input_lines[0]):
      continue
    if next_position.y < 0 || next_position.y >= len(input_lines):
      continue

    next_char = input_lines[next_position.y][next_position.x]
    next_rotations = []
    if next_char == "/":
      if abs(current_beam.direction) == Vector2.DOWN:
        next_rotations.append(rotations.RIGHT)
      else:
        next_rotations.append(rotations.LEFT)
    elif next_char == "\\":
      if abs(current_beam.direction) == Vector2.RIGHT:
        next_rotations.append(rotations.RIGHT)
      else:
        next_rotations.append(rotations.LEFT)
    elif (next_char == "|" && abs(current_beam.direction) == Vector2.RIGHT) || (next_char == "-" && abs(current_beam.direction) == Vector2.DOWN):
      next_rotations.append_array([rotations.RIGHT, rotations.LEFT])
    else:
      next_rotations.append(0)

    for r in next_rotations:
      beams_to_test.append(LightBeam.new(next_position, current_beam.direction.rotated(r).round()))

  #var beam_chars := {
    #Vector2.UP: "^",
    #Vector2.DOWN: "v",
    #Vector2.LEFT: "<",
    #Vector2.RIGHT: ">",
  #}
  #var row_string := ""
  #var curr_char := ""
  #var curr_beam_count := 0
  #var curr_pos:Vector2
#
  #for y in len(input_lines):
    #row_string = ""
    #for x in len(input_lines[y]):
      #curr_char = input_lines[y][x]
      #curr_pos = Vector2(x, y)
      #if curr_char != ".":
        #row_string += curr_char
        #continue
      #if !beams.has(curr_pos):
        #row_string += curr_char
        #continue
      #curr_beam_count = len(beams[curr_pos])
      ##print(curr_beam_count)
      #if curr_beam_count == 1:
        #row_string += beam_chars[beams[curr_pos][0]]
      #else:
        #row_string += str(curr_beam_count)
    #print(row_string)

  #print()
  beams.erase(start_beam.position)
  return len(beams)
