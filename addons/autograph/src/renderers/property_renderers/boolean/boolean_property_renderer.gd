class_name BooleanPropertyRenderer extends AutographPropertyRenderer

static func create(value, name='', options={}) -> Control:
  var ui = EditorUI.new()

  var scene = load("uid://cqpytsgw8mdwp")
  var instance = N.create_scene(scene, ui.editor)
  ui.editor.remove_child(instance)

  var toggle = N.get_child(instance, Button)
  var label = N.get_child(instance, Label)

  toggle.button_pressed = value
  label.text = name
  var state = {hovering=false}
  instance.mouse_entered.connect(func(): 
    state.hovering = true
    var stylebox: StyleBox = instance.get_theme_stylebox("panel").duplicate()
    stylebox.bg_color = Color(1, 1, 1, .125)
    instance.add_theme_stylebox_override("panel", stylebox)
  )

  instance.mouse_exited.connect(func(): 
    state.hovering = false
    var stylebox: StyleBox = instance.get_theme_stylebox("panel").duplicate()
    stylebox.bg_color = Color(1, 1, 1, 0)
    instance.add_theme_stylebox_override("panel", stylebox)
  )
  var handle_gui_event = (func(event: InputEvent):
    if state.hovering \
      and (event is InputEventMouseButton) \
      and event.pressed \
      and event.button_index == MOUSE_BUTTON_LEFT:
      
      toggle.button_pressed = !toggle.button_pressed
  )

  InputListener.on_editor_input.connect(handle_gui_event)

  return instance
