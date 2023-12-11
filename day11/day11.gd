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

func part_one(input_lines:PackedStringArray) -> void:
  var lines := Array(input_lines).filter(func(x): return x != "")
  var distances_sum := 0
  var space:Array[Array] = []
  var galaxies := {}
  var galaxy_id := 1

  var i := 0
  while i < lines.size():
    if "#" not in lines[i]:
      lines.insert(i, lines[i])
      i += 1
    i += 1

  i = 0
  while i < lines[0].length():
    var empty := true
    for line in lines:
      if line[i] == "#":
        empty = false
        break
    if empty:
      for j in lines.size():
        lines[j] = lines[j].insert(i, lines[j][i])
      i += 1
    i += 1

  lines.map(func(x): print(x))

  for y in lines.size():
    for x in lines[y].length():
      if lines[y][x] != "#":
        continue
      var galaxy := Galaxy.new(str(galaxy_id), Vector2(x, y))
      galaxies[str(galaxy_id)] = galaxy
      galaxy_id += 1

  var galaxy_pairs := []

  for id_a in galaxies:
    for id_b in galaxies.keys().filter(func(x): return x != id_a):
      var pair := [id_a, id_b]
      pair.sort()
      if pair not in galaxy_pairs:
        galaxy_pairs.append(pair)

  for pair in galaxy_pairs:
    distances_sum += get_man_distance(galaxies[pair[0]].location, galaxies[pair[1]].location)

  print("Part One: ", distances_sum)
  
func get_man_distance(a:Vector2, b:Vector2) -> float:
  return abs(a.x - b.x) + abs(a.y - b.y)
