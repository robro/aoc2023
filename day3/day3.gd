extends Node2D

#@onready var input_lines := FileAccess.open("res://day3/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day3/input.txt", FileAccess.READ).get_as_text().split("\n")

func _ready():
  print("Day 3")
  part_one(Array(input_lines).filter(func(x): return x != ""))

func part_one(lines:Array):
  var regex := RegEx.new()
  var symbol_re := r"[^\d\.]"
  var number_re := r"\d+"
  var symbols := []
  var numbers := []
  var y := 0
  var sum := 0
  
  for line in lines:
    regex.compile(symbol_re)
    var match_symbols := regex.search_all(line)
    for m in match_symbols:
      symbols.append([m.get_string(), Vector2(m.get_start(), y)])
    regex.compile(number_re)
    var match_numbers := regex.search_all(line)
    for m in match_numbers:
      numbers.append([m.get_string(), Vector2(m.get_start(), y), m.get_end()-m.get_start()])
    y += 1
    
  for num in numbers:
    var num_value := int(num[0])
    if is_adjacent(num, symbols):
      sum += num_value
    
  print("Part One: ", sum)

func is_adjacent(num:Array, symbols:Array) -> bool:
  var num_coord:Vector2 = num[1]
  var num_len:int = num[2]
  
  for sym in symbols:
    var sym_coord:Vector2 = sym[1]
    for i in range(num_len):
      var distance = sym_coord.distance_to(num_coord + Vector2(i, 0))
      if distance < 2:
        return true
        
  return false
