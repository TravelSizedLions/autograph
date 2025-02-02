@tool
class_name AutographNodeRenderer extends Control

var __node_scene: PackedScene
var __instance: Control

var color: Color:
  get:
    if not __instance:
      return Color.WHITE
    
    return __instance.get_theme_stylebox("panel").bg_color

var resource:
  get: return resource
  set(val):
    resource = val
    rebuild()

func _init():
  __node_scene = load('uid://7hjrc8tl3ur1')

func _notification(what: int) -> void:
  if what == NOTIFICATION_PREDELETE:
    __node_scene = null
    __instance.free()

func rebuild():
  if __instance:
    __instance.free()

  __instance = __build()
  recolor()
  rename()

  # [test-drive] - make it possible to mock getter/setter props...
  var final_position = -((__instance.size*__instance.scale)/2)
  __instance.scale = Vector2.ZERO

  var tween = __instance.create_tween()
  tween.set_parallel()
  tween.tween_property(__instance, 'scale', Vector2.ONE, .75)\
    .set_ease(Tween.EASE_OUT)\
    .set_trans(Tween.TRANS_ELASTIC)
  tween.tween_property(__instance, 'position', final_position, .75)\
    .set_ease(Tween.EASE_OUT)\
    .set_trans(Tween.TRANS_ELASTIC)

func __build():
  var instance = N.create_scene(__node_scene, self)
  if not resource:
    return instance

  for name in resource.variables:
    var info = resource.variables[name]
    var renderer = info.renderer if info.renderer else __get_property_renderer_for(info.type_)
    var container = N.get_child(instance, VBoxContainer)

    container.add_child(renderer.create(info.value, name))

  return instance

func recolor():
  var orig_styles: StyleBox = __instance.get_theme_stylebox("panel")
  if resource && orig_styles.bg_color != resource.background_color:
    var override_styles: StyleBox = orig_styles.duplicate()
    override_styles.bg_color = resource.background_color
    override_styles.border_color *= resource.background_color
    __instance.add_theme_stylebox_override("panel", override_styles)

func rename():
  var name: Label = N.get_child(__instance, Label, "__ag_node_name")
  if resource && resource._name() != name.text:
    name.text = resource._name()

func __get_property_renderer_for(type_hint):
  match type_hint:
    TYPE_BOOL: return BooleanPropertyRenderer
    TYPE_INT: return IntegerPropertyRenderer
    TYPE_FLOAT: return FloatPropertyRenderer
    TYPE_STRING: return ShortStringPropertyRenderer
    TYPE_COLOR: return ColorPropertyRenderer
    _: return AutographPropertyRenderer
