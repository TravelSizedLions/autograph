class_name Autograph extends Resource

const ZOOM_PRECISION = 4
const MIN_ZOOM = 0.0001
const MAX_ZOOM = 1

var __nodes: Array[AutographNode] = []

signal on_zoom_changed
signal on_origin_changed
signal on_node_added

var origin: Vector2 = Vector2.ZERO:
  set(val):
    var prev = origin
    origin = val
    if origin != prev:
      on_origin_changed.emit(origin, prev)

var zoom: float = 0.25:
  set(val):
    var prev = zoom
    zoom = min(max(__round(val, ZOOM_PRECISION), MIN_ZOOM), MAX_ZOOM)
    if zoom != prev:
      on_zoom_changed.emit(zoom, prev)

func watch_origin(fn: Callable):
  on_origin_changed.connect(fn)

func watch_zoom(fn: Callable):
  on_zoom_changed.connect(fn)

func __round(num, digit):
  return round(num * pow(10.0, digit)) / pow(10.0, digit)

func add_node(node_type, position):
  __nodes.append(node_type.new((position-origin)/zoom))
  on_node_added.emit(__nodes[-1])
