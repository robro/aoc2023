extends Node2D

#@onready var input_lines := FileAccess.open("res://day7/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day7/input.txt", FileAccess.READ).get_as_text().split("\n")

class Hand:
  var cards := ""
  var bid := 0
  var types := [[], [2], [2, 2], [3], [2, 3], [4], [5]]
  
  func _init(cards:String, bid:int):
    self.cards = cards
    self.bid = bid
    
  func get_strength() -> int:
    var counts := []
    var labels := []
    
    for label in self.cards:
      if label in labels:
        continue
      var count := self.cards.count(label)
      if count > 1:
        counts.append(count)
        labels.append(label)
      
    counts.sort()
    return self.types.find(counts)
    
  func get_strength_j() -> int:
    var counts := []
    var labels := []
    var jokers := 0
    
    for label in self.cards:
      if label in labels:
        continue
      var count := self.cards.count(label)
      if label == "J":
        jokers += count
        labels.append(label)
      elif count > 1:
        counts.append(count)
        labels.append(label)
      
    counts.sort()
    if counts == []:
      if jokers > 0:
        counts.append(min(5, jokers + 1))
    else:
      counts[-1] += jokers
    return self.types.find(counts)
    
  func _to_string() -> String:
    return "(Cards: {c}, Bid: {b})".format({"c": self.cards, "b": self.bid})

func _ready():
  print("Day 7")
  part_one(input_lines)
  part_two(input_lines)
  
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
  
func part_two(input_lines:PackedStringArray):
  var total := 0
  var regex := RegEx.new()
  regex.compile(r"(?<cards>\S+)\s+(?<bid>\S+)")
  var hands:Array[Hand] = []
  
  for line in Array(input_lines).filter(func(x): return x != ""):
    var search = regex.search(line)
    hands.append(Hand.new(search.get_string("cards"), int(search.get_string("bid"))))

  hands.sort_custom(sort_strength_j)
  for i in hands.size():
    total += hands[i].bid * (i + 1)
    
  print("Part Two: ", total)

func sort_strength(a:Hand, b:Hand) -> bool:
  var labels := ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
  var a_strength := a.get_strength()
  var b_strength := b.get_strength()
  
  if a_strength < b_strength:
    return true
  if a_strength > b_strength:
    return false
  if a_strength == b_strength:
    for i in a.cards.length():
      var a_label_strength := labels.find(a.cards[i])
      var b_label_strength := labels.find(b.cards[i])
      
      if a_label_strength < b_label_strength:
        return true
      if a_label_strength > b_label_strength:
        return false
        
  return true
  
func sort_strength_j(a:Hand, b:Hand) -> bool:
  var labels := ["J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"]
  var a_strength := a.get_strength_j()
  var b_strength := b.get_strength_j()
  
  if a_strength < b_strength:
    return true
  if a_strength > b_strength:
    return false
  if a_strength == b_strength:
    for i in a.cards.length():
      var a_label_strength := labels.find(a.cards[i])
      var b_label_strength := labels.find(b.cards[i])
      
      if a_label_strength < b_label_strength:
        return true
      if a_label_strength > b_label_strength:
        return false
        
  return true
