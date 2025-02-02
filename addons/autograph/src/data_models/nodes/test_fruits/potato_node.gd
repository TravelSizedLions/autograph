class_name PotatoNode extends AutographNode

const TITLE = "Potato"

func _build():
  self.background_color = Color("#631")
  add_property("boiled", false)
  add_property("mashed", false)
  add_property("stuck in a stew", false)

static func _belongs_to(_graph: Autograph) -> bool:
  return true

static func _context_menu_path() -> String:
  return 'Starch/{t}'.format({t=TITLE})

static func _name() -> String:
  return TITLE
