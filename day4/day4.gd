extends Node2D

#@onready var input_lines := FileAccess.open("res://day4/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day4/input.txt", FileAccess.READ).get_as_text().split("\n")

class Scratchcard:
  var winning_nums := []
  var your_nums := []
  
  func _init(winning_nums:Array, your_nums:Array):
    for num in winning_nums:
      self.winning_nums.append(int(num))
    for num in your_nums:
      self.your_nums.append(int(num))
    
  func get_point_value():
    var matches := 0
    for y_num in self.your_nums:
      for w_num in self.winning_nums:
        if y_num == w_num:
          matches += 1
          
    return 0 if matches == 0 else pow(2, matches-1)

func _ready():
  print("Day 4")
  part_one(Array(input_lines).filter(func(x): return x != ""))

func part_one(lines:Array):
  var total_points := 0
  var cards:Array[Scratchcard] = []
  var regex := RegEx.new()
  regex.compile(r": (?<win>.+) \| (?<you>.+)$")
  
  for line in lines:
    var numbers := regex.search(line)
    cards.append(Scratchcard.new(
      numbers.get_string("win").split(" ", false),
      numbers.get_string("you").split(" ", false)
    ))
    
  for card in cards:
    total_points += card.get_point_value()
    
  print("Part One: ", total_points)
