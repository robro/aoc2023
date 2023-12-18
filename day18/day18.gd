extends Node2D

#@onready var input_lines := FileAccess.open("res://day18/example_1.txt", FileAccess.READ).get_as_text().split("\n", false)
@onready var input_lines := FileAccess.open("res://day18/input.txt", FileAccess.READ).get_as_text().split("\n", false)

const directions: = {
  "D": Vector2.DOWN,
  "R": Vector2.RIGHT,
  "U": Vector2.UP,
  "L": Vector2.LEFT,
}

func _ready():
  print("Day 18")
  print("Part One: ", part_one())
  
func part_one() -> float:
  var cur_pos := Vector2.ZERO
  var dig_points:Array[Vector2] = []
  var perimeter_len := 0.
  dig_points.append(cur_pos)
  
  for line in input_lines:
    var elems = line.split(" ", false)
    cur_pos += directions[elems[0]] * int(elems[1])
    dig_points.append(cur_pos)
    perimeter_len += float(elems[1])
    
  perimeter_len += 1
  
  var sum1 = 0
  var sum2 = 0
  for i in len(dig_points)-1:
    sum1 += dig_points[i].x * dig_points[i+1].y
    sum2 += dig_points[i].y * dig_points[i+1].x
  
  return (sum1 - sum2) / 2 + ceil(perimeter_len / 2)
