class_name LongStringPropertyRenderer extends AutographPropertyRenderer

static func create(value, name='', options={}) -> Control:
  var scene = load("uid://xl8um86m7wt7")
  var instance = N.create_scene(scene, ui.editor)
  ui.editor.remove_child(instance)

  var label = N.get_child(instance, Label)
  label.text = name

  var text_field = N.get_child(instance, TextEdit)
  text_field.text = value

  return instance
