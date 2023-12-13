extends Node2D

#@onready var input_lines := FileAccess.open("res://day13/example_1.txt", FileAccess.READ).get_as_text().split("\n")
@onready var input_lines := FileAccess.open("res://day13/input.txt", FileAccess.READ).get_as_text().split("\n")

func _ready():
  print("Day 12")
  part_one(input_lines)

func part_one(input_lines:PackedStringArray) -> void:
  var summary := 0
  var patterns:Array[Array] = []
  var pattern:Array[String] = []

  for line in input_lines:
    if line == "":
      patterns.append(pattern)
      pattern = []
    else:
      pattern.append(line)

  for pat_rows in patterns:
    var pat_cols:Array[String] = []
    for i in pat_rows[0].length():
      var column := ""
      for l in pat_rows:
        column += l[i]
      pat_cols.append(column)

    var rows = get_reflection_index(pat_rows)
    if rows == -1:
      #print("no row found")
      rows = 0
    else:
      rows += 1
    var columns = get_reflection_index(pat_cols)
    if columns == -1:
      #print("no column found")
      columns = 0
    else:
      columns += 1
      
    #print("rows: ", rows, " columns: ", columns)
    summary += columns + (100 * rows)

  print("Part One: ", summary)
  # 27921 too high

func get_reflection_index(grid:Array[String]) -> int:
  var reflect_indices := {}
  var reflect_index := -1

  for i in grid.size()-1:
    if grid[i] == grid[i+1]:
      reflect_index = i
      var match_count := 1
      
      for j in i + 1:
        if i + j + 1 == grid.size():
          break
        if grid[i - j] != grid[i + j + 1]:
          reflect_index = -1
          break
        match_count += 1
        
      if reflect_index > -1:
        reflect_indices[match_count] = reflect_index

  if reflect_indices.is_empty():
    return -1
    
  var best_match = reflect_indices.keys()
  best_match.sort()
  best_match = best_match[-1]
  
  return reflect_indices.get(best_match, -1)
