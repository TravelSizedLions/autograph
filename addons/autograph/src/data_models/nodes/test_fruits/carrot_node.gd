class_name Carrot extends AutographNode

const TITLE = "Carrot"

func _build():
  self.background_color = Color("#C63")
  add_property("baby", false)

static func _belongs_to(_graph: Autograph) -> bool:
  return true

static func _context_menu_path() -> String:
  return 'Vegetable/{t}'.format({t=TITLE})

static func _name() -> String:
  return TITLE
