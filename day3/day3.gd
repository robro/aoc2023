extends Node2D

#@onready var input_lines := FileAccess.open("res://day3/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day3/input.txt", FileAccess.READ).get_as_text().split("\n")

class EnginePart:
  var value := ""
  var position := Vector2()
  var size := 0

  func _init(value:String, position:Vector2, size:int):
    self.value = value
    self.position = position
    self.size = size

  func is_adjacent(part:EnginePart) -> bool:
    if abs(self.position.y - part.position.y) > 1:
      return false
    for i in range(self.size):
      for j in range(part.size):
        if (self.position + Vector2(i, 0)).distance_to(part.position + Vector2(j, 0)) < 2:
          return true

    return false

  func get_adjacent_parts(parts:Array[EnginePart]) -> Array[EnginePart]:
    var adjacent_parts:Array[EnginePart] = []

    for part in parts:
      if is_adjacent(part):
        adjacent_parts.append(part)

    return adjacent_parts

class EngineParts:
  var numbers:Array[EnginePart] = []
  var symbols:Array[EnginePart] = []

  func _init(lines:Array):
    var num_re := r"\d+"
    var sym_re := r"[^\d\.]"
    var y := 0
    for line in lines:
      numbers.append_array(get_parts_in_line(line, num_re, y))
      symbols.append_array(get_parts_in_line(line, sym_re, y))
      y += 1

  func get_parts_in_line(line:String, re_str:String, y:int) -> Array[EnginePart]:
    var parts:Array[EnginePart] = []
    var regex := RegEx.new()
    regex.compile(re_str)
    var matches = regex.search_all(line)
    for m in matches:
      parts.append(EnginePart.new(
        m.get_string(),
        Vector2(m.get_start(), y),
        m.get_end()-m.get_start()
      ))

    return parts

func _ready():
  var parts := EngineParts.new(input_lines)
  print("Day 3")
  part_one(parts)
  part_two(parts)

func part_one(parts:EngineParts):
  var sum := 0

  for num in parts.numbers:
    for sym in parts.symbols:
      if num.is_adjacent(sym):
        sum += int(num.value)
        break

  print("Part One: ", sum)

func part_two(parts:EngineParts):
  var sum := 0
  var adjacent_nums:Array[EnginePart]
  var gear_ratio:int

  for sym in parts.symbols:
    if sym.value != "*":
      continue
    adjacent_nums = sym.get_adjacent_parts(parts.numbers)
    if adjacent_nums.size() != 2:
      continue
    gear_ratio = 1
    for num in adjacent_nums:
      gear_ratio *= int(num.value)
    sum += gear_ratio

  print("Part Two: ", sum)
