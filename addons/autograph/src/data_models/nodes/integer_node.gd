class_name IntegerNode extends AutographNode

const TITLE = "Integer"

func _build():
  add_property("value", 0)

static func _belongs_to(_graph: Autograph) -> bool:
  return true

static func _context_menu_path() -> String:
  return 'Variants/{t}'.format({t=TITLE})

static func _name() -> String:
  return TITLE
