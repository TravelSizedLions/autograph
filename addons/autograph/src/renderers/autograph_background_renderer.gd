@tool
class_name AutographBackgroundRenderer extends Control

var __color_util = EditorColorUtils.new()

func _draw() -> void:
  if modulate != __color_util.primary_color_darkened(6):
    modulate = __color_util.primary_color_darkened(6)
