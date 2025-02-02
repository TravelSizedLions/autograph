class_name FloatPropertyRenderer extends AutographPropertyRenderer

static func create(value, name='', options={}) -> Control:
  var on_text_change = func(prev_text, next_text):
    if next_text.is_valid_float() or not next_text:
      return next_text

    if next_text == '-' or next_text == '+':
      return next_text

    return prev_text

  var on_focus_exit = func(text):
    if not text:
      return str(0)

    return str(float(text))

  return NumberPropertyRenderer.create(value, name, {
    increment=func(text): return str(float(text)+1),
    decrement=func(text): return str(float(text)-1),
    on_increment=Funk.option(options, 'on_increment', func(_t): pass),
    on_decrement=Funk.option(options, 'on_decrement', func(_t): pass),
    on_text_change=on_text_change,
    on_focus_exit=on_focus_exit
  })
