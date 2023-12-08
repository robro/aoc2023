extends Node2D

#@onready var input_lines := FileAccess.open("res://day8/example_1.txt", FileAccess.READ).get_as_text().split("\n")
#@onready var input_lines := FileAccess.open("res://day8/example_2.txt", FileAccess.READ).get_as_text().split("\n")
#@onready var input_lines := FileAccess.open("res://day8/example_3.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day8/input.txt", FileAccess.READ).get_as_text().split("\n")

func _ready():
  print("Day 8")
  part_one(input_lines)
  part_two(input_lines)
  
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
  
func part_two(input_lines:PackedStringArray):
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
    
  var starting_node_ids := nodes.keys().filter(func(x): return x[-1] == "A")
  var loop_lens := []
  
  for id in starting_node_ids:
    loop_lens.append(get_steps(nodes, id, "Z", instructions))
    
  print("Part Two: ", loop_lens.reduce(lcm))
  
func gcd(a, b):
  var c
  var d
  while b:
    c = b    
    d = a % b
    a = c
    b = d
  return a
  
func lcm(a, b):
  return a * b / gcd(a, b)

func get_steps(nodes:Dictionary, from:String, to:String, instructions:String) -> int:
  var map := {"L": 0, "R": 1}
  var step_count := 0
  var current_id = from
  var i := 0
  
  while !current_id.ends_with(to):
    current_id = nodes[current_id][map[instructions[i]]]
    i += 1
    i %= instructions.length()
    step_count += 1
    
  return step_count
