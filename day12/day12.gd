extends Node2D

@onready var input_lines := FileAccess.open("res://day12/example_1.txt", FileAccess.READ).get_as_text().split("\n")
#@onready var input_lines := FileAccess.open("res://day12/input.txt", FileAccess.READ).get_as_text().split("\n")

class SpringRow:
  var record:String
  var counts:Array
  
  func _init(row_string:String) -> void:
    var split_string := row_string.split(" ", false)
    self.record = split_string[0]
    self.counts = split_string[1].split_floats(",", false)

func _ready():
  print("Day 12")
  #part_one(input_lines)
  part_two(input_lines)
  
func part_one(input_lines:PackedStringArray) -> void:
  var spring_rows:Array[SpringRow] = []
  for line in Array(input_lines).filter(func(x): return x != ""):
    spring_rows.append(SpringRow.new(line))

  print("Part One: ", get_sum_group_search(spring_rows))
  
func part_two(input_lines:PackedStringArray) -> void:
  var spring_rows:Array[SpringRow] = []
  var split_string:PackedStringArray
  var record:String
  var counts:String
  
  for line in Array(input_lines).filter(func(x): return x != ""):
    split_string = line.split(" ", false)
    record = (split_string[0] + "?").repeat(5).trim_suffix("?")
    counts = (split_string[1] + ",").repeat(5).trim_suffix(",")
    spring_rows.append(SpringRow.new(record + " " + counts))
    #print(record, " ", counts)

  print("Part Two: ", get_sum_group_search(spring_rows))
  
func get_sum_group_search(spring_rows:Array[SpringRow]) -> int:
  var sum_of_arrs := 0
  var row_num := 1
  var unknown_count:int
  var arr_count:int
  
  for row in spring_rows:
    #print(" ".join([row.record, row.counts]))
    var arrs_to_test := [[row.record, row.counts, 0, 0]]
    var tested_arrs := {}
    arr_count = 0
    
    while !arrs_to_test.is_empty():
      var arr = arrs_to_test.pop_front()
      var record:String = arr[0]
      var counts:Array = arr[1]
      var group_index:int = arr[2]
      var start_index:int = arr[3]
      #print("testing: ", record, " group: ", group_index, " start index: ", start_index)
      
      var group_size = counts[group_index]
      var group_count := counts.size()
      var total_damaged = counts.reduce(func(a, b): return a + b)
      var record_len := record.length()
      var test_record := ""
      
      for i in range(start_index, record_len - group_size + 1):
        if i > 0 && record[i - 1] == "#":
          #print("cont 1")
          continue
        if i + group_size < record_len && record[i + group_size] == "#":
          #print("cont 2")
          continue
        if "." in record.substr(i, group_size):
          continue
          
        test_record = record.substr(0, i).replace("?", ".") + "#".repeat(group_size)
        if test_record.length() < record_len:
          test_record += "."
        if test_record.length() < record_len:
          test_record += record.substr(i + group_size + 1)
          
        if group_index == group_count - 1:
          var test_counts := Array(test_record.replace("?", ".").split(".", false)).map(func(x): return x.length())
          #print(test_counts, " ", counts)
          if str(test_counts) == str(counts):
            test_record = test_record.replace("?", ".")
            #print(test_record)
            #print("...PASS...")
            tested_arrs[[test_record, counts]] = null
            arr_count += 1
            continue
        else:
          arrs_to_test.append([test_record, counts, group_index + 1, i + group_size + 1])
        
    print(arr_count)
    sum_of_arrs += arr_count
    
  return sum_of_arrs

func get_sum_brute_force(spring_rows:Array[SpringRow]) -> int:
  var sum_of_arrs := 0
  var row_num := 1
  var unknown_count:int
  var total_arrs:int
  var test_record:String
  var arr_count:int
  var arr:String
  var type:String
    
  for row in spring_rows:
    unknown_count = row.record.count("?")
    total_arrs = binary_to_int("1".repeat(unknown_count))
    test_record = ""
    arr_count = 0
    arr = ""
    #print(row.counts)
    for i in total_arrs+1:
      arr = int_to_binary(i).pad_zeros(unknown_count)
      test_record = str(row.record) # make a copy
      for a in arr:
        type = "#" if a == "1" else "."
        test_record[test_record.find("?")] = type
      if is_possible_record(test_record, row.counts):
        #print(test_record)
        arr_count += 1
      
    print(row_num, ": ", arr_count, " (", total_arrs, ")")
    sum_of_arrs += arr_count
    row_num += 1
    
  return sum_of_arrs
  
func int_to_binary(i:int) -> String:
  return int_to_binary(i/2) + str(i % 2) if i > 1 else str(i)
    
func binary_to_int(b:String) -> int:
  var n := 0
  for i in b.length():
    if b[-1 - i] == "1":
      n += 1<<i
  return n

func is_possible_record(record:String, counts:Array) -> bool:
  var record_counts := []
  for group in record.split(".", false):
    record_counts.append(group.count("#"))
    
  return str(record_counts) == str(counts)
  
