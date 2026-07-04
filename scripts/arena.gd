extends Node2D

# First arena canon: covered parking, BMW M5, open hood, oil puddle.
const FLOOR_Y := 548.0


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(1280, 720)), Color("#151820"))

	_draw_back_wall()
	_draw_floor()
	_draw_parking_lines()
	_draw_columns()
	_draw_bmw_m5_on_knees()
	_draw_foreground_grime()


func _draw_back_wall() -> void:
	draw_rect(Rect2(0, 94, 1280, 350), Color("#202631"))
	for y in [146, 224, 302, 380]:
		draw_line(Vector2(0, y), Vector2(1280, y), Color("#2f3744"), 3.0)

	for x in range(64, 1230, 170):
		draw_rect(Rect2(x, 118, 104, 34), Color("#e0efe8"))
		draw_rect(Rect2(x + 4, 122, 96, 26), Color("#9fc8c0"))

	draw_rect(Rect2(0, 70, 1280, 28), Color("#10131a"))
	for x in range(48, 1260, 180):
		draw_rect(Rect2(x, 76, 108, 12), Color("#d7eadf"))


func _draw_floor() -> void:
	var floor_poly := PackedVector2Array([
		Vector2(0, FLOOR_Y),
		Vector2(1280, FLOOR_Y),
		Vector2(1280, 720),
		Vector2(0, 720),
	])
	draw_colored_polygon(floor_poly, Color("#272b32"))
	draw_line(Vector2(0, FLOOR_Y), Vector2(1280, FLOOR_Y), Color("#5f6975"), 4.0)


func _draw_parking_lines() -> void:
	for x in range(-120, 1400, 210):
		draw_line(Vector2(x, 690), Vector2(x + 120, FLOOR_Y + 18), Color("#c4b56a", 0.45), 5.0)

	draw_line(Vector2(80, 620), Vector2(1210, 620), Color("#343b44"), 2.0)
	draw_line(Vector2(0, 668), Vector2(1280, 668), Color("#1b1f26"), 8.0)


func _draw_columns() -> void:
	for x in [130, 1090]:
		draw_rect(Rect2(x, 88, 62, 466), Color("#2d333d"))
		draw_rect(Rect2(x + 8, 96, 46, 448), Color("#39414d"))
		draw_rect(Rect2(x, 350, 62, 42), Color("#d1b848"))
		draw_line(Vector2(x + 58, 88), Vector2(x + 58, 554), Color("#151920"), 4.0)


func _draw_bmw_m5_on_knees() -> void:
	var car_offset := Vector2(710, 424)

	# Oil puddle under the defeated legend.
	_draw_filled_ellipse(car_offset + Vector2(-44, 128), Vector2(176, 24), Color("#050607", 0.88))
	_draw_filled_ellipse(car_offset + Vector2(-22, 126), Vector2(92, 12), Color("#2d3134", 0.45))

	# Wheels are tucked high to sell the "on its knees" stance.
	draw_circle(car_offset + Vector2(-210, 108), 46, Color("#07080a"))
	draw_circle(car_offset + Vector2(168, 112), 44, Color("#07080a"))
	draw_circle(car_offset + Vector2(-210, 108), 24, Color("#7f8790"))
	draw_circle(car_offset + Vector2(168, 112), 23, Color("#7f8790"))

	var body := PackedVector2Array([
		car_offset + Vector2(-320, 88),
		car_offset + Vector2(-270, 22),
		car_offset + Vector2(-98, 4),
		car_offset + Vector2(120, 16),
		car_offset + Vector2(280, 58),
		car_offset + Vector2(330, 110),
		car_offset + Vector2(255, 130),
		car_offset + Vector2(-284, 128),
	])
	draw_colored_polygon(body, Color("#2d4f72"))
	draw_polyline(body + PackedVector2Array([body[0]]), Color("#0f1720"), 4.0)

	var cabin := PackedVector2Array([
		car_offset + Vector2(-132, 8),
		car_offset + Vector2(-48, -48),
		car_offset + Vector2(96, -38),
		car_offset + Vector2(170, 24),
	])
	draw_colored_polygon(cabin, Color("#18202a"))
	draw_polyline(cabin + PackedVector2Array([cabin[0]]), Color("#7aa2b4"), 3.0)

	# Open hood: mandatory, because this M5 is emotionally and mechanically unavailable.
	var hood := PackedVector2Array([
		car_offset + Vector2(134, 14),
		car_offset + Vector2(226, -78),
		car_offset + Vector2(270, -62),
		car_offset + Vector2(198, 30),
	])
	draw_colored_polygon(hood, Color("#345f86"))
	draw_polyline(hood + PackedVector2Array([hood[0]]), Color("#0c1219"), 4.0)
	draw_line(car_offset + Vector2(204, 28), car_offset + Vector2(244, -60), Color("#0c1219"), 3.0)

	draw_rect(Rect2(car_offset + Vector2(206, 42), Vector2(76, 36)), Color("#12171d"))
	draw_line(car_offset + Vector2(218, 54), car_offset + Vector2(266, 62), Color("#66737f"), 4.0)
	draw_line(car_offset + Vector2(220, 70), car_offset + Vector2(274, 50), Color("#47515d"), 3.0)

	draw_rect(Rect2(car_offset + Vector2(-318, 76), Vector2(54, 16)), Color("#e6d57a"))
	draw_rect(Rect2(car_offset + Vector2(270, 78), Vector2(46, 14)), Color("#c73a35"))
	draw_string(ThemeDB.fallback_font, car_offset + Vector2(-36, 114), "M5", HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color("#dce7ef"))


func _draw_foreground_grime() -> void:
	draw_circle(Vector2(312, 628), 12, Color("#111419", 0.5))
	draw_circle(Vector2(908, 642), 18, Color("#111419", 0.45))
	draw_line(Vector2(0, 708), Vector2(1280, 708), Color("#0c0f14"), 18.0)


func _draw_filled_ellipse(center: Vector2, radius: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for i in range(48):
		var angle := TAU * float(i) / 48.0
		points.append(center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y))
	draw_colored_polygon(points, color)
