extends Node2D

#@onready var input_lines := FileAccess.open("res://day6/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day6/input.txt", FileAccess.READ).get_as_text().split("\n")

class Race:
  var time:float
  var dist:float
  
  func _init(time:float, dist:float):
    self.time = time
    self.dist = dist
    
  func _to_string():
    return "(Time: {t}, Distance: {d})".format({"t": self.time, "d": self.dist})
    
  func get_distance(held_time:float) -> float:
    return (self.time - held_time) * held_time

func _ready():
  print("Day 6")
  part_one(input_lines)
  
func part_one(input_lines:PackedStringArray):
  var input_str := "\n".join(input_lines)
  var regex := RegEx.new()
  var time_re := r"(?<=Time:)[^\n]*"
  var dist_re := r"(?<=Distance:)[^\n]*"
  var races:Array[Race] = []

  regex.compile(time_re)
  var search := regex.search(input_str)
  var times := search.get_string().split_floats(" ", false)
  regex.compile(dist_re)
  search = regex.search(input_str)
  var distances := search.get_string().split_floats(" ", false)
  
  for i in times.size():
    races.append(Race.new(times[i], distances[i]))
    
  var total := 1
  for race in races:
    var records := 0
    for i in race.time:
      var distance := race.get_distance(i)
      if distance > race.dist:
        records += 1
        
    total *= records
    
  print("Part One: ", total)
