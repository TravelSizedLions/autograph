class_name ShortStringNode extends AutographNode

const TITLE = "String"

func _build():
  add_property("value", "")

static func _belongs_to(_graph: Autograph) -> bool:
  return true

static func _context_menu_path() -> String:
  return 'Variants/{t} (Single Line)'.format({t=TITLE})

static func _name() -> String:
  return TITLE
