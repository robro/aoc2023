extends Node2D

#@onready var input_string := FileAccess.open("res://day15/example_1.txt", FileAccess.READ).get_as_text().strip_edges()
@onready var input_string := FileAccess.open("res://day15/input.txt", FileAccess.READ).get_as_text().strip_edges()

class Lens:
  var label := ""
  var focal_length := 0
  
  func _init(label:String, focal_length:int):
    self.label = label
    self.focal_length = focal_length
    
  func _to_string() -> String:
    return "[" + self.label + " " + str(self.focal_length) + "]"

# Called when the node enters the scene tree for the first time.
func _ready():
  print("Day 15")
  print(part_one())
  print(part_two())
  
func part_two() -> String:
  var sum := 0
  var regex := RegEx.new()
  regex.compile(r"(\w+)(=\d|-)")
  var boxes:Array[Array] = []
  for i in 256:
    boxes.append([])
  
  for step in input_string.split(","):
    var search := regex.search(step)
    var label := search.get_string(1)
    var op := search.get_string(2).lstrip("=")
    var box_i := get_hash_value(label)
    var label_i := boxes[box_i].map(func(x): return x.label).find(label)
    
    if int(op):
      var new_lens := Lens.new(label, int(op))
      if label_i == -1:
        boxes[box_i].append(new_lens)
      else:
        boxes[box_i][label_i] = new_lens
    elif label_i != -1:
      boxes[box_i].remove_at(label_i)
      
    #print("After \"", step, "\":")
    #for i in len(boxes):
      #if boxes[i].is_empty():
        #continue
      #print("Box ", i, ": ", " ".join(boxes[i]))
    #print()
    
  for i in len(boxes):
    var focusing_power := 0
    if boxes[i].is_empty():
      continue
    for j in len(boxes[i]):
      focusing_power = (i+1) * (j+1) * boxes[i][j].focal_length
      sum += focusing_power
      #print(focusing_power)
  
  return "Part Two: " + str(sum)

func part_one() -> String:
  var sum := 0
  for seq in input_string.split(","):
    var hash_value := get_hash_value(seq)
    #print(hash_value)
    sum += hash_value

  return "Part One: " + str(sum)

func get_hash_value(input:String) -> int:
  var hash_value := 0
  for c in input:
    hash_value += c.to_ascii_buffer()[0]
    hash_value *= 17
    hash_value %= 256
    
  return hash_value
