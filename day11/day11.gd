extends Node2D

#@onready var input_lines := FileAccess.open("res://day11/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day11/input.txt", FileAccess.READ).get_as_text().split("\n")

class Galaxy:
  var id:String
  var location:Vector2

  func _init(id:String, location:Vector2) -> void:
    self.id = id
    self.location = location

  func _to_string() -> String:
    return str(self.location)

func _ready():
  print("Day 11")
  part_one(input_lines)
  part_two(input_lines)

func part_one(input_lines:PackedStringArray) -> void:
  var lines := Array(input_lines).filter(func(x): return x != "")
  print("Part One: ", get_distances_sum(lines, 2))
  
func part_two(input_lines:PackedStringArray) -> void:
  var lines := Array(input_lines).filter(func(x): return x != "")
  print("Part Two: ", get_distances_sum(lines, 1000000))
  
func get_distances_sum(lines:Array, expansion:float) -> float:
  var expanded_rows := []
  var expanded_cols := []

  var i := 0
  while i < lines.size():
    if "#" not in lines[i]:
      expanded_rows.append(i)
    i += 1

  i = 0
  while i < lines[0].length():
    var empty := true
    for line in lines:
      if line[i] == "#":
        empty = false
        break
    if empty:
      expanded_cols.append(i)
    i += 1

  print("Finding galaxies...")
  var galaxies := {}
  var galaxy_id := 1

  for y in lines.size():
    for x in lines[y].length():
      if lines[y][x] != "#":
        continue
      var galaxy := Galaxy.new(str(galaxy_id), Vector2(
        x + (expansion - 1) * expanded_cols.filter(func(_x): return _x < x).size(), 
        y + (expansion - 1) * expanded_rows.filter(func(_y): return _y < y).size()
      ))
      galaxies[str(galaxy_id)] = galaxy
      galaxy_id += 1

  print("Found ", galaxies.size(), " galaxies!")
  print("Finding galaxy pairs...")
  var galaxy_pairs := {}

  for id_a in galaxies:
    for id_b in galaxies:
      if id_a == id_b:
        continue
      var pair := [id_a, id_b]
      pair.sort()
      var pair_id := "_".join(pair)
      if galaxy_pairs.has(pair_id):
        continue
      galaxy_pairs[pair_id] = [galaxies[id_a], galaxies[id_b]]

  print("Found ", galaxy_pairs.size(), " galaxy pairs!")
  print("Expanding empty space ", expansion, " times!")
  print("Calculating distances...")
  var distances_sum := 0
  
  for pair in galaxy_pairs.values():
    distances_sum += get_man_distance(pair[0].location, pair[1].location)
    
  return distances_sum
  
func get_man_distance(a:Vector2, b:Vector2) -> float:
  return abs(a.x - b.x) + abs(a.y - b.y)
