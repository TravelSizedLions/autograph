@tool
class_name AutographDock extends EditorPlugin

var PLUGIN_NAME = "Autograph"

var WINDOW_SCENE = preload("uid://bql7y4dbkrttw")

var __window: AutographWindow

func _has_main_screen(): return true
func _get_plugin_name(): return PLUGIN_NAME
func _get_plugin_icon(): return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")

func _make_visible(visible: bool) -> void:
  if __window:
   __window.visible = visible

func _enter_tree() -> void:
  __window = N.create_scene(WINDOW_SCENE, EditorInterface.get_editor_main_screen())
  _make_visible(false)

func _exit_tree() -> void:
  if __window:
    __window.queue_free()
