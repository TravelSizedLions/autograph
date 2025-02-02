class_name CeleryNode extends AutographNode

const TITLE = "Celery"

func _build():
  self.background_color = Color("#492")

static func _belongs_to(_graph: Autograph) -> bool:
  return true

static func _context_menu_path() -> String:
  return 'Vegetable/Useless Garbage/{t}'.format({t=TITLE})

static func _name() -> String:
  return TITLE
