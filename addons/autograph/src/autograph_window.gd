@tool
class_name AutographWindow extends Control

var __auto: AutographUtils = AutographUtils.new()
var __context_menu: ContextMenu = ContextMenu.new({
  item_provider=self.get_context_menu_items,
  open_condition=__auto.is_mouse_in_window
})

var __graph: Autograph = Autograph.new()
var graph: Autograph:
  get:
    return __graph

var open: bool

signal mouse_input_received

func _input(event: InputEvent) -> void:
  if visible && (event is InputEventMouseButton or event is InputEventMouseMotion):
    mouse_input_received.emit(event as InputEventMouse)

func get_context_menu_items() -> Dictionary:
  var node_types = __auto.get_all_node_types()
  var relevant_node_types = node_types.filter(func (node_type): return node_type._belongs_to(graph))

  var entries = relevant_node_types.reduce((func(acc, node):
    acc[node._context_menu_path()] = (func():
      graph.add_node(node, __auto.get_mouse_position_in_window())
    )
    return acc
  ), {})

  return ContextMenu.entrees_to_tree(entries)
