extends Node2D

#@onready var input_lines := FileAccess.open("res://day4/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day4/input.txt", FileAccess.READ).get_as_text().split("\n")

class Scratchcard:
  var match_count := 0
  
  func _init(winning_nums:Array, your_nums:Array):
    for y_num in your_nums:
      for w_num in winning_nums:
        if y_num == w_num:
          self.match_count += 1
    
  func get_point_value():
    return 0 if self.match_count == 0 else pow(2, self.match_count-1)
    
func get_cards(lines:Array) -> Array[Scratchcard]:
  var cards:Array[Scratchcard] = []
  var regex := RegEx.new()
  regex.compile(r"Card \s*(?<num>\d+): (?<win>.+) \| (?<you>.+)$")
  
  for line in lines:
    var numbers := regex.search(line)
    cards.append(Scratchcard.new(
      numbers.get_string("win").split(" ", false),
      numbers.get_string("you").split(" ", false)
    ))
    
  return cards

func _ready():
  print("Day 4")
  var cards := get_cards(Array(input_lines).filter(func(x): return x != ""))
  part_one(cards)
  part_two(cards)

func part_one(cards:Array[Scratchcard]):
  var total_points := 0
  for card in cards:
    total_points += card.get_point_value()
    
  print("Part One: ", total_points)

func part_two(cards:Array[Scratchcard]):
  var card_count := cards.size()
  var total := 0
  var totals := {}
  for i in range(card_count):
    totals[i] = 1
    
  for i in range(card_count):
    for j in range(i+1, i+cards[i].match_count+1):
      if j >= card_count:
        break
      totals[j] += totals[i]
      
    total += totals[i]
    
  print("Part Two: ", total)
