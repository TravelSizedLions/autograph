class_name NumberPropertyRenderer extends AutographPropertyRenderer

static func create(value, name='', options={}) -> Control:
  var scene = load("uid://kr8ufhcdyrcq")
  var instance = N.create_scene(scene, ui.editor)
  ui.editor.remove_child(instance)

  var label = N.get_child(instance, Label)
  label.text = name

  var field: LineEdit = N.get_child(instance, LineEdit)
  field.text = str(value)

  var increment: Button = N.get_child(instance, Button, "up")
  var decrement: Button = N.get_child(instance, Button, "down")

  var on_text_change = Funk.option(options, 'on_text_change', func(_val): pass)
  var on_focus_exit = Funk.option(options, 'on_focus_exit', func(_val): pass)

  var state = {
    prev_text=field.text,
    up_pressed=false,
    down_pressed=false,
    timer=N.create_native(Timer, ui.editor),
    repeat_initial_wait=.3,
    repeat_freq=0.1,
    increment=Funk.option(options, 'increment', func(_p, _v): pass),
    decrement=Funk.option(options, 'decrement', func(_p, _v): pass),
    on_increment=Funk.option(options, 'on_increment', func(_t): pass),
    on_decrement=Funk.option(options, 'on_decrement', func(_t): pass)
  }

  var start_repeat_timer = func(fn):
    state.timer.start(state.repeat_initial_wait)
    state.timer.timeout.connect(func():
      fn.call()
      state.timer.start(state.repeat_freq)
    )

  var stop_repeat_timer = func():
    state.timer.stop()
    for conn in Array(state.timer.timeout.get_connections()):
      state.timer.timeout.disconnect(conn.callable)

  increment.button_down.connect(func():
    field.text = state.increment.call(field.text)
    state.on_increment.call(field.text)
    if not state.up_pressed:	
      start_repeat_timer.call(func():
        field.text = state.increment.call(field.text)
        state.on_increment.call(field.text)
      )			
    state.up_pressed = true
  )

  increment.button_up.connect(func():
    if state.up_pressed:
      stop_repeat_timer.call()
      state.up_pressed = false
  )

  decrement.button_down.connect(func():
    field.text = state.decrement.call(field.text)
    state.on_decrement.call(field.text)
    if not state.down_pressed:
      start_repeat_timer.call(func():
        field.text = state.decrement.call(field.text)
        state.on_decrement.call(field.text)	
      )	
    state.down_pressed = true
  )

  decrement.button_up.connect(func():
    if state.down_pressed:
      stop_repeat_timer.call()
      state.down_pressed = false
  )

  field.text_changed.connect(func(text):
    var delta_text = on_text_change.call(state.prev_text, text)
    if delta_text != field.text:
      field.text = delta_text
      field.caret_column = field.text.length()		

    state.prev_text = delta_text
  )

  field.focus_exited.connect(func():
    field.text = on_focus_exit.call(field.text)		
  )

  return instance
