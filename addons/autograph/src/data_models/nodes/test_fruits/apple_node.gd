class_name Apple extends AutographNode

const TITLE = "Apple"

func _build():
  self.background_color = Color("#66ba66")
  add_property("wormy", true)

static func _belongs_to(_graph: Autograph) -> bool:
  return true

static func _context_menu_path() -> String:
  return 'Fruit/{t}'.format({t=TITLE})

static func _name() -> String:
  return TITLE
