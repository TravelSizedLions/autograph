class_name LongStringNode extends AutographNode

const TITLE = "String"

func _build():
  add_property("value", "", {
    renderer=LongStringPropertyRenderer
  })

static func _belongs_to(_graph: Autograph) -> bool:
  return true

static func _context_menu_path() -> String:
  return 'Variants/{t} (Text Box)'.format({t=TITLE})

static func _name() -> String:
  return TITLE
