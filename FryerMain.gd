extends Node2D

@export var flavours = ["chocolate", "strawberry", "vanilla"]

# Change this to lower time
# Can possibly make it so that for each point you get less and less time?

@export var time_limit = 5.0

var current_flavour = ""
var score = 0
var game_active = false
var time_left = 0.0

func _ready():
	# Connect all area signals
	$StrawberryArea.donut_dipped.connect(_on_zone_donut_dipped)
	$ChocolateArea.donut_dipped.connect(_on_zone_donut_dipped)
	$VanillaArea.donut_dipped.connect(_on_zone_donut_dipped)
	$Timer.timeout.connect(_on_timer_timeout)
	
	# Hide restart button initially (with safety check)
	if has_node("RestartButton"):
		$RestartButton.visible = false
		$RestartButton.pressed.connect(_on_restart_pressed)
	else:
		print("Warning: RestartButton node not found!")
	
	start_new_round()

func _process(delta):
	if game_active:
		time_left = $Timer.time_left
		if has_node("TimerLabel"):
			if time_left > 0:
				$TimerLabel.text = "Time: " + str("%.2f" % time_left)
			else:
				$TimerLabel.text = "Time: 0.00"

func start_new_round():
	current_flavour = flavours[randi() % flavours.size()]
	$FlavourLabel.text = "Dip in " + current_flavour + "!"
	reset_donut_position()
	$Timer.start(time_limit)
	time_left = time_limit
	
	if has_node("TimerLabel"):
		$TimerLabel.text = "Time: " + str("%.2f" % time_left)
	
	if has_node("RestartButton"):
		$RestartButton.visible = false
	
	if has_node("ScoreLabel"):
		$ScoreLabel.text = "Score: " + str(score)
	
	game_active = true
	print("New round: Dip in ", current_flavour)

func reset_donut_position():
	$Donut.position = Vector2(100, 300)
	$Donut.dragging = false

func _on_zone_donut_dipped(flavour):
	if not game_active:  # Prevent multiple triggers
		return
		
	game_active = false
	$Timer.stop()
	
	if current_flavour == flavour:
		score += 1
		print("Correct! Score: ", score)
		# Possibly quick pause?
		start_new_round()
	else:
		print("Wrong dip! Game Over! Final Score: ", score)
		game_over()

func _on_timer_timeout():
	if not game_active:
		return
		
	game_active = false
	print("Time's up! Score: ", score)
	game_over()

func game_over():
	# Handle game over state
	$FlavourLabel.text = "Game Over! Final Score: " + str(score)
	
	if has_node("TimerLabel"):
		$TimerLabel.text = ""
	
	if has_node("RestartButton"):
		$RestartButton.visible = true

func _on_restart_pressed():
	score = 0
	start_new_round()
