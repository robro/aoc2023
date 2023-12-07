extends Node2D

#@onready var input_lines := FileAccess.open("res://day7/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day7/input.txt", FileAccess.READ).get_as_text().split("\n")

class Hand:
  var cards := ""
  var bid := 0
  var labels := ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
  
  func _init(cards:String, bid:int):
    self.cards = cards
    self.bid = bid
    
  func get_strength() -> int:
    var types := [[], [2], [2, 2], [3], [2, 3], [4], [5]]
    var counts := []
    
    for label in self.labels:
      var count := self.cards.count(label)
      if count > 1:
        counts.append(count)
      
    counts.sort()
    return types.find(counts)
    
  func _to_string() -> String:
    return "(Cards: {c}, Bid: {b})".format({"c": self.cards, "b": self.bid})

func _ready():
  print("Day 7")
  part_one(input_lines)
  
func part_one(input_lines:PackedStringArray):
  var total := 0
  var regex := RegEx.new()
  regex.compile(r"(?<cards>\S+)\s+(?<bid>\S+)")
  var hands:Array[Hand] = []
  
  for line in Array(input_lines).filter(func(x): return x != ""):
    var search = regex.search(line)
    hands.append(Hand.new(search.get_string("cards"), int(search.get_string("bid"))))

  hands.sort_custom(sort_strength)
  for i in hands.size():
    total += hands[i].bid * (i + 1)
    
  print("Part One: ", total)

func sort_strength(a:Hand, b:Hand) -> bool:
  var a_strength := a.get_strength()
  var b_strength := b.get_strength()
  
  if a_strength < b_strength:
    return true
  if a_strength > b_strength:
    return false
  if a_strength == b_strength:
    for i in a.cards.length():
      var a_label_strength := a.labels.find(a.cards[i])
      var b_label_strength := b.labels.find(b.cards[i])
      
      if a_label_strength < b_label_strength:
        return true
      if a_label_strength > b_label_strength:
        return false
        
  return true
