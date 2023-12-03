extends Node2D

#@onready var input := FileAccess.open("res://day1/example_1.txt", FileAccess.READ)
#@onready var input := FileAccess.open("res://day1/example_2.txt", FileAccess.READ)
#@onready var input := FileAccess.open("res://day1/example_3.txt", FileAccess.READ)
@onready var input := FileAccess.open("res://day1/input.txt", FileAccess.READ)
@onready var lines := input.get_as_text().split("\n")
@onready var regex := RegEx.new()

func _ready():
  part_one(lines, regex)
  part_two(lines, regex)
  
func part_one(li:PackedStringArray, re:RegEx):
  re.compile(r"\d")
  print("Part One: ", get_total(li, re))

func part_two(li:PackedStringArray, re:RegEx):
  re.compile(r"\d|one|two|three|four|five|six|seven|eight|nine")
  print("Part Two: ", get_total(li, re))
    
func get_total(li:PackedStringArray, re:RegEx) -> int:
  var result:RegExMatch
  var matches:Array
  var total := 0
  var value:int
  var map := {
    "1": "1",
    "2": "2",
    "3": "3",
    "4": "4",
    "5": "5",
    "6": "6",
    "7": "7",
    "8": "8",
    "9": "9",
    "one": "1",
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5",
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9"
  }
  
  for l in li:
    matches.clear()
    for i in range(l.length()):
      result = re.search(l, i)
      if result:
        matches.append(result.get_string())
    if matches.is_empty():
      continue
    value = int(map[matches[0]] + map[matches[-1]])
    total += value
    
  return total
