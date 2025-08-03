extends Node2D

@onready var player_trace: Line2D = $PlayerTrace
@onready var message_label: Label = $MessageLabel
@onready var pretzel_outline_node: Line2D = $PretzelOutline
@onready var score_label: Label = $ScoreLabel
@onready var persistent_traces_container: Node2D = $PersistentTracesContainer

var MATCHED_1 = false
var MATCHED_2 = false
var MATCHED_3 = false
var MATCHED_4 = false

var successful_traces : int = 0

var target_outline_points: PackedVector2Array = PackedVector2Array([
	Vector2(325, 206),
	Vector2(390, 180),
	Vector2(450, 195),
	Vector2(490, 225),
	Vector2(550, 195),
	Vector2(640, 195),
	Vector2(670, 230),
	Vector2(670, 240),
	Vector2(665, 280),
	Vector2(613, 360),
	Vector2(550, 400),
	Vector2(500, 430),
	Vector2(450, 420),
	Vector2(411, 380),
	Vector2(360, 350),
	Vector2(340, 310),
	Vector2(320, 255)
])

var target_outline_points_2: PackedVector2Array = PackedVector2Array([
	Vector2(369, 240),
	Vector2(392, 286),
	Vector2(413, 313),
	Vector2(431, 289),
	Vector2(448, 259),
	Vector2(397, 234)
])

var target_outline_points_3: PackedVector2Array = PackedVector2Array([
	Vector2(526, 268),
	Vector2(566, 250),
	Vector2(609, 248),
	Vector2(589, 301),
	Vector2(547, 337),
	Vector2(539, 297)
])

var target_outline_points_4 : PackedVector2Array = PackedVector2Array([
	Vector2(486, 299),
	Vector2(495, 344),
	Vector2(493, 383),
	Vector2(466, 366),
	Vector2(470, 338)
])

var trace_threshold: float = 25.0

var min_points_on_outline_percentage: float = 0.8

var is_tracing: bool = false
var game_over: bool = false

func _ready():
	_start_new_game()

func _start_new_game():
	$BackButton.show()
	message_label.text = "Trace the pretzel outline!"
	message_label.visible = true
	message_label.modulate = Color.WHITE
	player_trace.clear_points()
	game_over = false

	MATCHED_1 = false
	MATCHED_2 = false
	MATCHED_3 = false
	MATCHED_4 = false
	successful_traces = 0
	update_score_display()

	for child in persistent_traces_container.get_children():
		child.queue_free()

	pretzel_outline_node.hide()

func show_hitpoints():
	pretzel_outline_node.show()
	pretzel_outline_node.points = target_outline_points
	pretzel_outline_node.width = 5
	pretzel_outline_node.default_color = Color.RED

func _input(event):
	if game_over:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_tracing = true
				player_trace.clear_points()
				player_trace.add_point(event.position)
				message_label.visible = false
			else:
				is_tracing = false
				var trace_successful = false
				var current_target_points: PackedVector2Array

				if (not MATCHED_1):
					current_target_points = target_outline_points
				if (not MATCHED_2):
					current_target_points = target_outline_points_2
				if (not MATCHED_3):
					current_target_points = target_outline_points_3
				if (not MATCHED_4):
					current_target_points = target_outline_points_4


				trace_successful = check_trace(current_target_points)

				if trace_successful:
					successful_traces += 1
					$ScoreLabel.text = "Traces Completed: %d / %d" % [successful_traces, 4]

					if current_target_points == target_outline_points:
						MATCHED_1 = true
					elif current_target_points == target_outline_points_2:
						MATCHED_2 = true
					elif current_target_points == target_outline_points_3:
						MATCHED_3 = true
					elif current_target_points == target_outline_points_4:
						MATCHED_4 = true

					var successful_line = Line2D.new()
					successful_line.points = player_trace.points
					successful_line.width = player_trace.width
					successful_line.default_color = Color.BLUE
					persistent_traces_container.add_child(successful_line)

					display_message("Success!", Color.GREEN)
					player_trace.clear_points()

					if successful_traces == 4:
						game_over = true
						display_message("All traces complete! Game Over!", Color.GREEN)
						Inventory2._add_to_inventory(Order.Orderable.PRETZEL,1) 
						Inventory2.print_inventory()
						
				else:
					display_message("Failure! Try again.", Color.RED)
					player_trace.clear_points()

	elif event is InputEventMouseMotion:
		if is_tracing:
			player_trace.add_point(event.position)
			print("Cursor coordinates: ", event.position)

func check_trace(expected_trace_points):
	var points_on_outline_count: int = 0
	var total_trace_points: int = player_trace.get_point_count()

	if total_trace_points == 0:
		return false

	for i in range(total_trace_points):
		var player_point = player_trace.get_point_position(i)
		var is_point_on_outline: bool = false

		for j in range(expected_trace_points.size() - 1):
			var p1 = expected_trace_points[j]
			var p2 = expected_trace_points[j+1]

			var segment_vector = p2 - p1
			var point_vector = player_point - p1
			var segment_length_sq = segment_vector.length_squared()

			var t: float
			if segment_length_sq == 0:
				t = 0.0
			else:
				t = clamp(point_vector.dot(segment_vector) / segment_length_sq, 0.0, 1.0)

			var closest_point_on_segment = p1 + t * segment_vector
			var distance = player_point.distance_to(closest_point_on_segment)

			if distance <= trace_threshold:
				is_point_on_outline = true
				break

		if is_point_on_outline:
			points_on_outline_count += 1

	var percentage_on_outline = float(points_on_outline_count) / total_trace_points

	if percentage_on_outline >= min_points_on_outline_percentage:
		return true
	else:
		return false

func update_score_display():
	score_label.text = "Traces Completed: %d / %d" % [successful_traces, 4]

func display_message(msg: String, color: Color):
	message_label.text = msg
	message_label.modulate = color
	message_label.visible = true
	await get_tree().create_timer(1.0).timeout
	message_label.visible = false


func _on_back_button_pressed() -> void:
	SceneSwitcher.goto_scene("res://kitchen.tscn")
