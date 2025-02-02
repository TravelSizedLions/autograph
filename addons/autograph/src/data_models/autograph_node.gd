class_name AutographNode extends Resource

var __color_util = EditorColorUtils.new()

var position: Vector2
var background_color: Color = __color_util.primary_color_lightened(3)
var variables: Dictionary = {}
var __AUTOGRAPH_NODE__ = true

func _init(position: Vector2) -> void:
  self.position = position
  _build()

func _build() -> void:
  pass

"""
add_property()

arguments:
  - name (String):
    The label of the property
  - default_val (Variant):
    The default value for the property. If type_hint isn't defined, the type of the default value
    is used.

  options:
  - renderer (AutographPropertyRenderer):
    The specific property renderer to use. If none is provided, autograph will infer one based on the 
    type of the specific
"""
func add_property(name: String, default_val, options={}):
  if name in variables:
    push_error('variable with name "{0} ({1}) already exists"'.format([name, variables[name].type]))
    return

  var type_hint = Funk.option(options, 'type_hint', -1)
  variables[name] = {
    value = default_val,
    type_ = typeof(default_val),
    renderer = Funk.option(options, 'renderer', null)
  }


static func _belongs_to(_graph: Autograph) -> bool:
  return false

static func _context_menu_path() -> String:
  return "Autograph Node"

static func _name() -> String:
  return "Autograph Node"
