extends Node2D

#@onready var input_lines := FileAccess.open("res://day14/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day14/input.txt", FileAccess.READ).get_as_text().split("\n")

func _ready():
  print("Day 14")
  part_one(input_lines)
  part_two(input_lines)

func part_one(input_lines:PackedStringArray) -> void:
  var total_load := 0
  var platform := Array(input_lines).filter(func(x): return x != "")

  roll_rocks(platform)

  for i in platform.size():
    total_load += platform[i].count("O") * (platform.size() - i)

  #platform.map(func(x): print(x))
  print("Part One: ", total_load)

func part_two(input_lines:PackedStringArray) -> void:
  var total_load := 0
  var platform := Array(input_lines).filter(func(x): return x != "")
  var platform_states := {}
  var cycle := 1

  while true:
    for i in 4:
      roll_rocks(platform)
      rotate90_CW(platform)

    if platform_states.has(platform):
      break
    platform_states[platform.duplicate(true)] = cycle
    cycle += 1

  var total_cycles := 1000000000
  var loop_start = platform_states[platform]
  var loop_length = cycle - platform_states[platform]
  var final_platform = platform_states.find_key((total_cycles - loop_start) % loop_length + loop_start)

  for i in len(final_platform):
    total_load += final_platform[i].count("O") * (len(final_platform) - i)

  #final_platform.map(func(x): print(x))
  #print("loop start: ", loop_start, " loop length: ", loop_length)
  print("Part Two: ", total_load)

func rotate90_CW(A:Array) -> void:
  var N = len(A[0])
  for i in N / 2:
    for j in range(i, N - i - 1):
      var temp = A[i][j]
      A[i][j] = A[N - 1 - j][i]
      A[N - 1 - j][i] = A[N - 1 - i][N - 1 - j]
      A[N - 1 - i][N - 1 - j] = A[j][N - 1 - i]
      A[j][N - 1 - i] = temp

func roll_rocks(platform:Array) -> void:
  var mobile_rocks := true

  while mobile_rocks:
    mobile_rocks = false
    for y in len(platform):
      if y == 0:
        continue
      for x in len(platform[y]):
        if platform[y][x] == "O" && platform[y-1][x] == ".":
          platform[y-1][x] = "O"
          platform[y][x] = "."
          mobile_rocks = true
