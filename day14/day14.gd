class_name Platform
extends Node2D

const OFFSETS := [
  Vector2(0, -1),
  Vector2(-1, 0),
  Vector2(0,  1),
  Vector2(1,  0),
]

const TOTAL_CYCLES := 1000000000

#@onready var input_lines := Array(FileAccess.open("res://day14/example_1.txt", FileAccess.READ).get_as_text().split("\n")).filter(func(x): return x != "")
@onready var input_lines := Array(FileAccess.open("res://day14/input.txt", FileAccess.READ).get_as_text().split("\n")).filter(func(x): return x != "")
@onready var platform:Polygon2D = $Platform
@onready var platform_size := len(input_lines)
@onready var rock_scene := preload("res://day14/Rock.tscn")
@onready var block_scene := preload("res://day14/Block.tscn")
@onready var rocks:Array[Rock] = []
@onready var blocks:Array[Block] = []
@onready var tilt = null
@onready var tilt_num := 0
@onready var cycle_num := 0
@onready var cycle_state := []
@onready var cycle_states := {}
@onready var loop_start = null
@onready var loop_length = null

func _ready():
  print("Day 14")
  var platform_points := PackedVector2Array([
    Vector2(0, 0),
    Vector2(platform_size, 0),
    Vector2(platform_size, platform_size),
    Vector2(0, platform_size),
  ])
  platform.set_polygon(platform_points)

  var rock_instance:Rock
  var block_instance:Block

  for y in len(input_lines):
    for x in len(input_lines[y]):
      if input_lines[y][x] == "O":
        rock_instance = rock_scene.instantiate()
        rock_instance.set_position(Vector2(x, y))
        rocks.append(rock_instance)
        add_child(rock_instance)

      elif input_lines[y][x] == "#":
        block_instance = block_scene.instantiate()
        block_instance.set_position(Vector2(x, y))
        blocks.append(block_instance)
        add_child(block_instance)

func _process(delta):
  if !tilt:
    tilt = OFFSETS[tilt_num]
    tilt_num += 1
    tilt_num %= len(OFFSETS)

func _physics_process(delta):
  if tilt != null:
    if rocks.map(func(r): return r.move(tilt)).any(func(x): return x):
      return
    tilt = null
    if tilt_num == 1 && cycle_num == 0:
      print(part_one())
    elif tilt_num != 0:
      return
    cycle_state = rocks.map(func(r): return r.position)
    cycle_state.sort()

    if cycle_states.has(cycle_state):
      if !loop_length:
        loop_start = cycle_states[cycle_state]
        loop_length = cycle_num - cycle_states[cycle_state]
        print(part_two())
    else:
      cycle_states[cycle_state] = cycle_num

    cycle_num += 1

func part_one() -> String:
  var total_load := 0

  for i in platform_size:
    total_load += len(rocks.filter(func(r): return r.position.y == i)) * (platform_size - i)

  return "Part One: " + str(total_load)

func part_two() -> String:
  var total_load := 0
  var final_state = cycle_states.find_key((TOTAL_CYCLES - loop_start) % loop_length + loop_start)

  for i in platform_size:
    total_load += len(final_state.filter(func(v): return v.y == i)) * (platform_size - i)

  return "Part Two: " + str(total_load)
