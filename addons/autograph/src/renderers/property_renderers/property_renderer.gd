class_name AutographPropertyRenderer

static var __ui
static var ui:
  get:
    if not __ui:
      __ui = EditorUI.new()
    return __ui

static func _static_init() -> void:
  __ui = EditorUI.new()

static func create(value, name='', options={}) -> Control:
  push_error('Renderer not implemented for property {n}={v}'.format({n=name, v=value}))
  print_stack()
  return null
