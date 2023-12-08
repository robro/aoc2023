extends Node2D

#@onready var input_lines := FileAccess.open("res://day8/example_1.txt", FileAccess.READ).get_as_text().split("\n")
#@onready var input_lines := FileAccess.open("res://day8/example_2.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day8/input.txt", FileAccess.READ).get_as_text().split("\n")

func _ready():
  print("Day 8")
  part_one(input_lines)
  
func part_one(input_lines:PackedStringArray):
  var regex := RegEx.new()
  var node_re := r"(?<id>\w+)\W+(?<left>\w+)\W+(?<right>\w+)"
  regex.compile(node_re)
  var instructions := input_lines[0]
  var nodes := {}
  
  for line in input_lines.slice(2):
    var search := regex.search(line)
    if search == null:
      continue
    nodes[search.get_string("id")] = [search.get_string("left"), search.get_string("right")]
    
  print("Part One: ", get_steps(nodes, "AAA", "ZZZ", instructions))

func get_steps(nodes:Dictionary, from:String, to:String, instructions:String) -> int:
  var step_count := 0
  var current_node = from
  var i := 0
  
  while current_node != to:
    var instruction = 0 if instructions[i] == "L" else 1
    current_node = nodes[current_node][instruction]
    i += 1
    i %= instructions.length()
    step_count += 1
    
  return step_count
