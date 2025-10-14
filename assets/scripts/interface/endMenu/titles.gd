extends RichTextLabel

class_name Titles

@export_multiline var creator: String = "VaJa72"
@export_multiline var programmers: String = "VaJa72\nMcFord"
@export_multiline var artists: String = "VaJa72\nMcFord"
@export_multiline var testers: String = "StaSyan\nMcFord"
@export_multiline var special_thanks: String = "swadowiq\nRealLifePze\nLittleTinyBit\nБаян Гордыня"
@export_multiline var music: String

func update_text() -> void:
	text = _add_title("createdBy") + creator + "\n\n" \
		+ _add_title("programmers") + programmers + "\n\n" \
		+ _add_title("artists") + artists + "\n\n" \
		+ _add_title("testers") + testers + "\n\n" \
		+ _add_title("music") + "\n" + music + "\n\n\n" \
		+ Loc.trans("interface.titles.ponies") + "\n\n" \
		+ Loc.trans("interface.titles.jam") + "\n\n" \
		+ Loc.trans("interface.titles.copyright")

func _add_title(code: String) -> String:
	return "[font_size=20]" + Loc.trans("interface.titles." + code) + "[/font_size]\n"
