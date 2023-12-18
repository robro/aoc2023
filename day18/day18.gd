extends Node2D

#@onready var input_lines := FileAccess.open("res://day18/example_1.txt", FileAccess.READ).get_as_text().split("\n", false)
@onready var input_lines := FileAccess.open("res://day18/input.txt", FileAccess.READ).get_as_text().split("\n", false)
@onready var dig_shape := $DigShape as Polygon2D

const rotations := {
  "RIGHT": PI/2,
  "LEFT": -PI/2,
}

func _ready():
  print("Day 18")
  print("Part One: ", part_one())
  print("Part Two: ", part_two())
  
func hex_to_int(hex_value:String) -> int:
  var letter_values := {
    "a": 10,
    "b": 11,
    "c": 12,
    "d": 13,
    "e": 14,
    "f": 15,
  }
  var int_value := 0
  for i in len(hex_value):
    var value = letter_values[hex_value[i]] if hex_value[i] in letter_values else int(hex_value[i])
    int_value += value * pow(16, len(hex_value)-1-i)
    
  return int_value
  
func part_two() -> float:
  const directions := {
    "0": Vector2.RIGHT,
    "1": Vector2.DOWN,
    "2": Vector2.LEFT,
    "3": Vector2.UP,
  }
  var cur_pos := Vector2.ZERO
  var dig_points:Array[Vector2] = []
  dig_points.append(cur_pos)
  
  for line in input_lines:
    var elems = line.split(" ", false)
    var direction = directions[elems[2][7]]
    var length := hex_to_int(elems[2].substr(2, 5))
    cur_pos += direction * length
    dig_points.append(cur_pos)
    
  if dig_points[-1] == dig_points[0]:
    dig_points.resize(len(dig_points)-1)
    
  var dig_points_expanded = get_expanded_points(dig_points, 0.5)
  dig_shape.polygon = PackedVector2Array(dig_points_expanded)
  dig_shape.scale = Vector2(0.03, 0.03)
  return get_shape_volume(dig_points_expanded)
  # 194033955967852 too low
  # 194033951277300
  
func part_one() -> float:
  const directions: = {
    "R": Vector2.RIGHT,
    "D": Vector2.DOWN,
    "L": Vector2.LEFT,
    "U": Vector2.UP,
  }
  var cur_pos := Vector2.ZERO
  var dig_points:Array[Vector2] = []
  dig_points.append(cur_pos)
  
  for line in input_lines:
    var elems = line.split(" ", false)
    cur_pos += directions[elems[0]] * int(elems[1])
    dig_points.append(cur_pos)
    
  if dig_points[-1] == dig_points[0]:
    dig_points.resize(len(dig_points)-1)
    
  var dig_points_expanded = get_expanded_points(dig_points, 0.5)
  dig_shape.polygon = PackedVector2Array(dig_points)
  return get_shape_volume(dig_points_expanded)
  
func get_expanded_points(points:Array[Vector2], expansion:float) -> Array[Vector2]:
  var points_expanded:Array[Vector2] = []
  
  for i in len(points):
    var exp_point:Vector2
    var prev_dir = (points[i-1] - points[i]).normalized()
    var next_dir = (points[(i+1) % len(points)] - points[i]).normalized()
    
    if (-prev_dir).rotated(rotations.RIGHT).round() == next_dir:
      exp_point = (points[i] - (prev_dir + next_dir) * expansion).ceil()
    elif (-prev_dir).rotated(rotations.LEFT).round() == next_dir:
      exp_point = (points[i] + (prev_dir + next_dir) * expansion).ceil()
    else:
      print("wtf")
      
    points_expanded.append(exp_point)
      
  return points_expanded
  
func get_shape_volume(points:Array[Vector2]) -> float:
  var sum1 = 0
  var sum2 = 0
  
  for i in len(points):
    sum1 += points[i].x * points[(i+1) % len(points)].y
    sum2 += points[i].y * points[(i+1) % len(points)].x
  
  return (sum1 - sum2) / 2.
