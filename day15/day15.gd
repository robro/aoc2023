extends Node2D

#@onready var input_string := FileAccess.open("res://day15/example_1.txt", FileAccess.READ).get_as_text().strip_edges()
@onready var input_string := FileAccess.open("res://day15/input.txt", FileAccess.READ).get_as_text().strip_edges()

# Called when the node enters the scene tree for the first time.
func _ready():
  print("Day 15")
  var sum := 0
  for seq in input_string.split(","):
    var hash_value := get_hash_value(seq)
    print(hash_value)
    sum += hash_value

  print("Part One: ", sum)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass

func get_hash_value(input:String) -> int:
  var hash_value := 0
  for c in input:
    hash_value += c.to_ascii_buffer()[0]
    hash_value *= 17
    hash_value %= 256
    
  return hash_value
