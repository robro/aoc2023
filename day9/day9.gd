extends Node2D

#@onready var input_lines := FileAccess.open("res://day9/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day9/input.txt", FileAccess.READ).get_as_text().split("\n")

func _ready():
  print("Day 9")
  part_one(input_lines)

func part_one(input_lines:PackedStringArray):
  var sum := 0
  for line in Array(input_lines).filter(func(x): return x != ""):
    sum += get_next_value(line)

  print("Part One: ", sum)

func get_next_value(line:String):
  var vals := Array(line.split_floats(" ", false))
  if vals.size() == 0:
    return null

  var sequences := [vals]
  var new_vals = []
  var diff = 0

  while !sequences[-1].all(func(x): return x == 0):
    vals = sequences[-1]
    new_vals = []

    for i in vals.size()-1:
      diff = vals[i+1] - vals[i]
      new_vals.append(diff)

    sequences.append(new_vals)

  sequences.reverse()
  var add_val := 0
  
  for i in sequences.size():
    if i == 0:
      continue
    add_val = sequences[i-1][-1]
    sequences[i].append(sequences[i][-1] + add_val)

  return sequences[-1][-1]
