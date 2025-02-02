@tool
class_name AutographGridRenderer extends Control

## Draw a thin line every X pixels
var __tick_dist: int = 64;

## Draw a minor every <__minors_every> ticks, and majors every <__minors_every>**2 ticks
var __minors_every = 4

## variables for handling middle mouse dragging
var __drag_last_position = Vector2.ZERO
var __dragging: bool = false

const THICKNESS_THRESHOLD = 0.1

## The color of grid lines
@export var zoom_speed = .1

var __auto: AutographUtils = AutographUtils.new()
var __color_util = EditorColorUtils.new()
var __line_color: Color

func _ready() -> void:
  # move the origin away from the top left corner.
  if __auto.main_screen:
    var graph = __auto.graph
    graph.watch_zoom(__offset_origin_by_mouse)
    graph.watch_zoom(func(_cur, _prev): queue_redraw())
    graph.watch_origin(func(_cur, _prev): queue_redraw())

    if graph.origin == Vector2.ZERO:
      graph.origin = -__auto.main_screen.size

  __auto.window.mouse_input_received.connect(handle_input)
  __color_util.add_color_change_observer(__recolor)
  __recolor()

func handle_input(event: InputEvent) -> void:
  if event is InputEventMouseButton:
    var mouseEvent = event as InputEventMouseButton
    if mouseEvent.pressed && __auto.is_mouse_in_window():
      match mouseEvent.button_index:
        MOUSE_BUTTON_WHEEL_UP: __zoom_in();
        MOUSE_BUTTON_WHEEL_DOWN: __zoom_out();
        MOUSE_BUTTON_MIDDLE: __start_drag();
    elif mouseEvent.is_released():
      match event.button_index:
        MOUSE_BUTTON_MIDDLE: __end_drag();
  elif event is InputEventMouseMotion:
    __update_drag()

func _draw() -> void:
  if __auto.main_screen:
    var graph = __auto.graph
    var tick_dist = __tick_dist*graph.zoom
    var screen = __auto.main_screen
    __render_horizontal_lines(graph.origin.y, tick_dist, screen.size.y, screen.size.x, __line_color)
    __render_vertical_lines(graph.origin.x, tick_dist, screen.size.y, screen.size.x, __line_color)

func __render_horizontal_lines(origin_y, tick_dist, window_height, window_width, color):
  var index_offset = int(-origin_y/tick_dist)
  var pos_y = __get_render_starting_position(origin_y, tick_dist)
  var i = 0
  while pos_y < window_height:
    pos_y += tick_dist
    __render_graph_line(Vector2(0, pos_y), Vector2(window_width, pos_y), __get_thickness(i+index_offset), color)
    i+=1

func __render_vertical_lines(origin_x, tick_dist, window_height, window_width, color):
  var index_offset = int(-origin_x/tick_dist)
  var pos_x = __get_render_starting_position(origin_x, tick_dist)
  var i = 0
  while pos_x < window_width:
    pos_x += tick_dist
    __render_graph_line(Vector2(pos_x, 0), Vector2(pos_x, window_height), __get_thickness(i+index_offset), color)
    i+= 1

func __get_render_starting_position(origin_dim, tick_dist):
  # Determines the position of first line in the window.
  # 
  # The remainder culls all lines between the origin and the start of the window
  # the tick_dist offset accounts for whether the origin is before the window or
  # after.
  var remainder = __remainder(abs(origin_dim), tick_dist)
  return sign(origin_dim)*(remainder + tick_dist/2) + (tick_dist/2)

func __render_graph_line(beg, end, thickness, color):
  if thickness < THICKNESS_THRESHOLD:
    return

  if thickness < 1:
    color.a = thickness
    thickness = 1

  draw_line(beg, end, color, thickness, true)

func __get_thickness(i):
  var zoom = __auto.graph.zoom
  if i % __minors_every**5 == 0:
    return 64*zoom
  if i % __minors_every**4 == 0:
    return 16*zoom
  if i % __minors_every**3 == 0:
    return 4*zoom
  elif i % __minors_every**2 == 0:
    return 1*zoom
  elif i % __minors_every == 0:
    return .25*zoom
  return .0625*zoom

func __zoom_in():
  __auto.graph.zoom *= (1+zoom_speed)

func __zoom_out():
  __auto.graph.zoom *= (1-zoom_speed)

func __start_drag():
  __dragging = true
  __drag_last_position = __auto.get_mouse_position_in_window()
  get_parent().mouse_default_cursor_shape = Control.CURSOR_DRAG

func __end_drag():
  __dragging = false
  __drag_last_position = Vector2.ZERO
  get_parent().mouse_default_cursor_shape = Control.CURSOR_ARROW

func __offset_origin_by_mouse(next_zoom, previous_zoom):
  var delta_zoom = next_zoom/previous_zoom
  var mouse_window_pos = __auto.get_mouse_position_in_window()
  var origin_rel_to_mouse = __auto.graph.origin - mouse_window_pos
  var scaled_origin_rel_to_mouse = delta_zoom*origin_rel_to_mouse
  __auto.graph.origin = mouse_window_pos + scaled_origin_rel_to_mouse

func __update_drag():
  if __dragging:
    var cur_pos = __auto.get_mouse_position_in_window()
    var delta = cur_pos - __drag_last_position
    __drag_last_position = cur_pos
    __auto.graph.origin += delta

func __remainder(num:float, divisor:float):
  return num - int(num/divisor)*divisor


func __recolor():
  __line_color = __color_util.primary_color
