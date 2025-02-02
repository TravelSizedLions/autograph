class_name Tomato extends AutographNode

const TITLE = "Tomato"

func _build():
  self.background_color = Color("#F22")

static func _belongs_to(_graph: Autograph) -> bool:
  return true

static func _context_menu_path() -> String:
  return 'Vegetable/{t}'.format({t=TITLE})

static func _name() -> String:
  return TITLE
