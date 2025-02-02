class_name Banana extends AutographNode

const TITLE = "Banana"

func _build():
  self.background_color = Color("#baba44")
  add_property("ripe", true)
  add_property("secretly rotten on the inside", true)

static func _belongs_to(_graph: Autograph) -> bool:
  return true

static func _context_menu_path() -> String:
  return 'Fruit/{t}'.format({t=TITLE})

static func _name() -> String:
  return TITLE
