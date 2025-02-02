class_name AutographUtils

var __editor = EditorUI.new()

var __main_screen
var main_screen: VBoxContainer:
  get:
    if not __main_screen:
      __main_screen = __editor.main_screen
    return __main_screen
    
var __graph: Autograph
var graph: Autograph:
  get: 
    if not __graph:
      __graph = window.graph
    return __graph
  set(val): 
    __graph = val
    window.graph = val

var __editor_base_control: Control
var editor: Control:
  get:
    if not __editor_base_control:
      __editor_base_control = __editor.editor
    return __editor_base_control


var __window: AutographWindow
var window: AutographWindow:
  get:
    if not __window:
      __window = N.get_child(editor, AutographWindow)
    return __window

var mouse_position: Vector2:
  get: return editor.get_viewport().get_mouse_position()

func get_mouse_position_in_window():
  var abs_mouse_pos = main_screen.get_viewport().get_mouse_position()
  return abs_mouse_pos - main_screen.global_position

func is_mouse_in_window():
  var pos = get_mouse_position_in_window()
  var w_pos = main_screen.global_position
  var w_size = main_screen.size
  return pos.x >= 0 && pos.x <= w_size.x && pos.y >= 0 && pos.y <= w_size.y

func happened_inside(event: InputEvent, control: Control):
  return is_inside(event.global_position, control)

func is_inside(position: Vector2, node: Node):
  var rel_pos = position - node.global_position
  return (rel_pos.x >= 0
    and rel_pos.y >= 0
    and rel_pos.x <= node.size.x
    and rel_pos.y <= node.size.y)

func is_graph_open():
  var ag_control = N.get_child(main_screen, AutographWindow)
  return ag_control.visible

func get_all_node_types() -> Array:
  return FS.get_scripts_with_property('__AUTOGRAPH_NODE__')
