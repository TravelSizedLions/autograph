class_name AutographPropertyRendererTests extends TDTest

func test_drive():
  before_each(func():
    var MockEditorInterface =  mock(EditorInterface)
    AutographPropertyRenderer.__ui.__editor = MockEditorInterface.new()
    AutographPropertyRenderer.__ui.__editor_base_control = autofree(N.create_native(VBoxContainer))
  )

  group('string (short)', func():
    test('names and default values are respected', func():
      var val = "This is a string"
      var name = "My string"
      var prop = autofree(ShortStringPropertyRenderer.create(val, name))

      assert_equal(N.get_child(prop, Label).text, name)
      assert_equal(N.get_child(prop, LineEdit).text, val)	
    )	
  )

  group('string (long)', func():
    test('names and default values are respected', func():
      var val = "This is a string"
      var name = "My string"
      var prop = autofree(LongStringPropertyRenderer.create(val, name))

      assert_equal(N.get_child(prop, Label).text, name)
      assert_equal(N.get_child(prop, TextEdit).text, val)	
    )
  )

  group('integer', func():
    test('names and default values are respected', func():
      var val = -129
      var name = "My integer"
      var prop = autofree(IntegerPropertyRenderer.create(val, name))

      assert_equal(N.get_child(prop, Label).text, name)
      assert_true(N.get_child(prop, LineEdit).text.is_valid_int())
      assert_equal(int(N.get_child(prop, LineEdit).text), val)
    )

    test('incrementing incements by exactly one', func():
      var ref = {value=0}
      var prop = autofree(
        IntegerPropertyRenderer.create(ref.value, "value", {
          on_increment=func(text): ref.value = text
        })
      )

      var field = N.get_child(prop, LineEdit)

      assert_equal(int(N.get_child(prop, LineEdit).text), 0)

      var increment = N.get_child(prop, Button, "up")
      increment.button_down.emit()
      
      assert_equal(int(ref.value), 1)
    )

    test('decrementing decrements by exactly one', func():
      var ref = {value=1}
      var on_decrement = func(text): ref.value = text
      var prop = autofree(
        IntegerPropertyRenderer.create(ref.value, "value", {
          on_decrement=func(text): ref.value = text
        })
      )

      prop.set_process(true)
      var field = N.get_child(prop, LineEdit)

      assert_equal(int(N.get_child(prop, LineEdit).text), 1)

      var decrement = N.get_child(prop, Button, "down")
      decrement.button_down.emit()

      assert_equal(int(ref.value), 0)
    )
  )

  group('float', func():
    test('names and default values are respected', func():
      var val = -129.2095
      var name = "My float"
      var prop = autofree(FloatPropertyRenderer.create(val, name))

      assert_equal(N.get_child(prop, Label).text, name)
      assert_true(N.get_child(prop, LineEdit).text.is_valid_float())
      assert_equal(float(N.get_child(prop, LineEdit).text), val)
    )

    test('incrementing incements by exactly one', func():
      var ref = {value=0.5}
      var prop = autofree(
        FloatPropertyRenderer.create(ref.value, "value", {
          on_increment=func(text): ref.value = text
        })
      )

      var field = N.get_child(prop, LineEdit)

      assert_equal(float(N.get_child(prop, LineEdit).text), 0.5)

      var increment = N.get_child(prop, Button, "up")
      increment.button_down.emit()
      
      assert_equal(float(ref.value), 1.5)
    )

    test('decrementing decrements by exactly one', func():
      var ref = {value=-1.5}
      var on_decrement = func(text): ref.value = text
      var prop = autofree(
        FloatPropertyRenderer.create(ref.value, "value", {
          on_decrement=func(text): ref.value = text
        })
      )

      prop.set_process(true)
      var field = N.get_child(prop, LineEdit)

      assert_equal(float(N.get_child(prop, LineEdit).text), -1.5)

      var decrement = N.get_child(prop, Button, "down")
      decrement.button_down.emit()

      assert_equal(float(ref.value), -2.5)
    )
  )

  group('color', func():
    test('names and default values are respected', func():
      var val = Color('deadbeef')
      var name = 'unalive cow'

      var prop = autofree(ColorPropertyRenderer.create(val, name))
      assert_equal(N.get_child(prop, Label, 'name').text, name)
      assert_equal(N.get_child(prop, ColorPickerButton).color, val)
      assert_equal(N.get_child(prop, Label, 'hex').text, '#' + val.to_html(true))
    )	

    test('hex value display only shows alpha if the color is not solid', func():
      var val_a = Color('ffffff')
      var val_b = Color('ffffff00')
      var prop = autofree(ColorPropertyRenderer.create(val_a))
      assert_equal(N.get_child(prop, Label, 'hex').text, '#ffffff')

      N.get_child(prop, ColorPickerButton).color = val_b
      N.get_child(prop, ColorPickerButton).popup_closed.emit()

      assert_equal(N.get_child(prop, Label, 'hex').text, '#ffffff00')

      N.get_child(prop, ColorPickerButton).color = val_a
      N.get_child(prop, ColorPickerButton).popup_closed.emit()
      assert_equal(N.get_child(prop, Label, 'hex').text, '#ffffff')
    )
  )
