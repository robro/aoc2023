class_name Rock
extends Node2D

@onready var hitbox:Area2D = $Hitbox
@onready var platform = get_parent() as Platform

func move(offset:Vector2) -> bool:
  var new_position := position + offset
  if new_position.y < 0 || new_position.y >= platform.platform_size:
    return false
  if new_position.x < 0 || new_position.x >= platform.platform_size:
    return false
  if offset in hitbox.get_overlapping_areas().map(
    func(x): return x.global_position - position
  ):
    return false
  position = new_position
  return true
