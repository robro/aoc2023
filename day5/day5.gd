extends Node2D

#@onready var input_lines := FileAccess.open("res://day5/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day5/input.txt", FileAccess.READ).get_as_text().split("\n")

func _ready():
  print("Day 5")
  part_one(Array(input_lines).filter(func(x): return x != ""))

func part_one(lines:Array):
  var map_re := r"\w+:([\d\s]+)"
  var maps := get_match_groups("\n".join(lines), map_re)
  var maps_values := []

  for map in maps:
    var map_rows := map.split("\n", false)
    var map_values := []

    for row in map_rows:
      map_values.append(row.split_floats(" ", false))

    maps_values.append(map_values)

  var seed_values = maps_values.pop_front()[0]
  var lowest_value = INF

  for value in seed_values:
    for map in maps_values:
      for row in map:
        if value < row[1]:
          continue
        if value > row[1] + row[2]:
          continue
        value = row[0] + (value - row[1])
        break

    if value < lowest_value:
      lowest_value = value

  print("Part One: ", lowest_value)

func get_match_groups(input_str:String, re_str:String) -> Array[String]:
  var regex := RegEx.new()
  regex.compile(re_str)
  var matches := regex.search_all(input_str)
  var groups:Array[String] = []

  for m in matches:
    groups.append(m.get_string(1))

  return groups
