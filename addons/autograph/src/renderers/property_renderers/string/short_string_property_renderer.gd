class_name ShortStringPropertyRenderer extends AutographPropertyRenderer

static func create(value, name='', options={}) -> Control:
  var scene = load("uid://dun6c1mdkb5u2")
  var instance = N.create_scene(scene, ui.editor)
  ui.editor.remove_child(instance)

  var label = N.get_child(instance, Label)
  label.text = name

  var text_field = N.get_child(instance, LineEdit)
  text_field.text = value

  return instance
