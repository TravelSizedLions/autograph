class_name ColorPropertyRenderer extends AutographPropertyRenderer

static func create(value, name='', options={}):
  var scene = load('uid://dkqilio1mgvgi')
  var instance = N.create_scene(scene, ui.editor) 
  ui.editor.remove_child(instance)

  var color_picker: ColorPickerButton = N.get_child(instance, ColorPickerButton)
  color_picker.color = value

  var name_label: Label = N.get_child(instance, Label, 'name')
  name_label.text = name

  var update_hex = func():
    var val: Color = color_picker.color
    var label = N.get_child(instance, Label, 'hex')
    label.text = '#{c}'.format({c=val.to_html(val.a < 1)})

  update_hex.call()
  color_picker.popup_closed.connect(update_hex)

  return instance
