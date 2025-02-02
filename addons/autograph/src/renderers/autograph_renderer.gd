@tool
class_name AutographRenderer extends Control

var __nodes: Dictionary = {}

func _ready() -> void:
  var auto = AutographUtils.new()
  auto.graph.on_node_added.connect(__add_node)
  auto.graph.on_origin_changed.connect(__update_position)
  auto.graph.on_zoom_changed.connect(__update_scale)
  self.position = auto.graph.origin
  self.scale = Vector2(auto.graph.zoom, auto.graph.zoom)

func __update_scale(scale: float, _previous: float):
  self.scale = Vector2(scale, scale)

func __update_position(pos: Vector2, _previous: Vector2):
  position = pos

func __add_node(node: AutographNode):
  var control = N.create_native(AutographNodeRenderer, self)
  control.position = node.position
  control.resource = node
  var rid = node.get_rid()
  __nodes[rid] = {
    resource = node,
    control = control
  }
