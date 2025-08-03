extends Node  
 

var layers : Array[CoffeeIngredient]  
var last_ingredient : CoffeeIngredient.Ingredient  
var first_ingredient : CoffeeIngredient.Ingredient
var is_flowing : bool 
var current_ingredient : CoffeeIngredient.Ingredient   
var first_run : bool = true 
var failed = false 

@onready var SHOW_ON_END = [$BackButton, $RestartButton]

const COFFEE_COLOR = Color("#6F4E37") 
const CHOCOLATE_COLOR = Color("#381819")
 
@onready var current_bar: ProgressBar = $FirstProgressBar  
var progress_bars : Array[ProgressBar] 

enum Drink {
	LATTE,
	CAPPUCCINO,
	MOCHA,  
	MACCHIATO
} 

var winning_conditions = {
	Drink.LATTE: [ 
		WinCondition.new(0.30, 0.35, CoffeeIngredient.Ingredient.COFFEE),
		WinCondition.new(0.50, 0.55, CoffeeIngredient.Ingredient.MILK),
		WinCondition.new(0.10, 0.15, CoffeeIngredient.Ingredient.MILK_FOAM)
	],
	Drink.CAPPUCCINO: [
		WinCondition.new(0.30, 0.40, CoffeeIngredient.Ingredient.COFFEE),
		WinCondition.new(0.40, 0.50, CoffeeIngredient.Ingredient.MILK),
		WinCondition.new(0.10, 0.20, CoffeeIngredient.Ingredient.MILK_FOAM)
	],
	Drink.MOCHA: [
		WinCondition.new(0.25, 0.35, CoffeeIngredient.Ingredient.COFFEE),
		WinCondition.new(0.40, 0.50, CoffeeIngredient.Ingredient.MILK),
		WinCondition.new(0.15, 0.25, CoffeeIngredient.Ingredient.CHOCOLATE)
	],
	Drink.MACCHIATO: [
		WinCondition.new(0.60, 0.80, CoffeeIngredient.Ingredient.COFFEE),
		WinCondition.new(0.10, 0.20, CoffeeIngredient.Ingredient.MILK),
		WinCondition.new(0.05, 0.10, CoffeeIngredient.Ingredient.MILK_FOAM)
	]
} 
func _ready() -> void: 
	$Nozzle.hide() 
	
	var opaque_fill_style = StyleBoxFlat.new()
	opaque_fill_style.bg_color = Color(1, 1, 1, 1) 
	opaque_fill_style.set_corner_radius_all(5)
	$FirstProgressBar.add_theme_stylebox_override("fill", opaque_fill_style)
	$FailedLabel.hide()
	$MessageBackground.hide() 
	$SuccessLabel.hide() 
	
	hideOnRestart()
	
func _process(delta: float) -> void:  
	
	
	if (failed):  
		$FailedLabel.show() 
		$MessageBackground.show() 
		showOnEnd()
		return
		   
	
	if (is_flowing):   
		add_ingredient(delta, current_ingredient) 
	
	
	if (self.layers.size() > 0 and is_flowing):   
		var actual_ingredient_str = CoffeeIngredient.Ingredient.keys()[current_ingredient] 
		print(actual_ingredient_str)
		current_bar.value = layers[-1].percentage 
		match current_ingredient: 
			CoffeeIngredient.Ingredient.COFFEE: 
				current_bar.modulate = COFFEE_COLOR  
				$Nozzle.modulate = COFFEE_COLOR 
			CoffeeIngredient.Ingredient.MILK: 
				current_bar.modulate = Color.MINT_CREAM  
				$Nozzle.modulate = Color.MINT_CREAM 
			CoffeeIngredient.Ingredient.MILK_FOAM: 
				current_bar.modulate = Color.ANTIQUE_WHITE 
				$Nozzle.modulate = Color.ANTIQUE_WHITE 
			CoffeeIngredient.Ingredient.CHOCOLATE: 
				current_bar.modulate = CHOCOLATE_COLOR   
				$Nozzle.modulate = CHOCOLATE_COLOR
				
	const CHECK_THRESHOLD_LOWER = 90
	const CHECK_THRESHOLD_UPPER = 110
	var current_fill = sum()
	
	if current_fill > CHECK_THRESHOLD_UPPER: 
		failed = true
		
	if (current_fill > CHECK_THRESHOLD_LOWER and current_fill < CHECK_THRESHOLD_UPPER): 
		evaluate_drink()
		   
 
func showOnEnd() -> void: 
	for button in SHOW_ON_END: 
		button.show() 
		
func hideOnRestart() -> void: 
	for button in SHOW_ON_END: 
		button.hide()
		
func evaluate_drink() -> void: 
	for drink in Drink.values(): 
		
		var conditions = winning_conditions[drink] 
		var is_drink_complete = true

		print("Evaluating drink for:", Drink.keys()[drink])
		print("Expected layers:", conditions.size(), " | Actual layers:", layers.size())

		if conditions.size() != layers.size():
			is_drink_complete = false
			print("❌ Layer count mismatch!")

		for i in range(min(layers.size(), conditions.size())):
			var layer = layers[i]
			var condition = conditions[i]

			var actual_ingredient_str = CoffeeIngredient.Ingredient.keys()[layer.ingredient]
			var expected_ingredient_str = CoffeeIngredient.Ingredient.keys()[condition.ingredient]

			print("Checking layer", i)
			print("- Ingredient:", actual_ingredient_str, " | Expected:", expected_ingredient_str)
			print("- Percentage:", layer.percentage, " | Expected:", condition.lower_bound * 100, "to", condition.upper_bound * 100)

			if layer.ingredient != condition.ingredient:
				is_drink_complete = false 
				print("❌ Ingredient mismatch at layer", i)

			if layer.percentage < condition.lower_bound * 100 or layer.percentage > condition.upper_bound * 100: 
				is_drink_complete = false
				print("❌ Ratio out of bounds at layer", i)

		if is_drink_complete:
			print("✅ Matched drink:", Drink.keys()[drink]) 
			$SuccessLabel.show() 
			$MessageBackground.show()   
			 
			
			Inventory2._add_to_inventory(drink, 1)  
			Inventory2.print_inventory()
			#
		
			showOnEnd()
		else:
			print("❌ Drink did not match.")

				
	
func sum() -> float:
	var total := 0.0
	for ingredient in layers:
		total += ingredient.percentage
	return total
			
	
func generate_new_bar(): 
	if (first_run): 
		first_run = false 
		return
		
	var new_bar = ProgressBar.new()
	new_bar.size = current_bar.size  
	new_bar.rotation = -PI / 2  
	new_bar.show_percentage = false  

	# Transparent background (unfilled part)
	var transparent_bg_style = StyleBoxFlat.new()
	transparent_bg_style.bg_color = Color(0, 0, 0, 0)  # fully transparent
	transparent_bg_style.set_corner_radius_all(5)
	new_bar.add_theme_stylebox_override("background", transparent_bg_style)

	# Opaque fill (filled part of the bar)
	var opaque_fill_style = StyleBoxFlat.new()
	opaque_fill_style.bg_color = Color(1, 1, 1, 1)  # white and fully opaque
	opaque_fill_style.set_corner_radius_all(5)
	new_bar.add_theme_stylebox_override("fill", opaque_fill_style)

	var percentage = layers[-1].percentage / 100
	var fractional_size = percentage * current_bar.size.y  

	const MARGIN = 4
	new_bar.position = current_bar.position - Vector2(0, fractional_size + 0.3 * fractional_size)  

	current_bar.get_parent().add_child(new_bar) 
	current_bar = new_bar 
	
	progress_bars.append(current_bar)

	
func add_first_ingredient(ingredient : CoffeeIngredient.Ingredient): 
	if first_ingredient == null:
		first_ingredient = ingredient
		layers.append(CoffeeIngredient.new(0, ingredient)) 
		last_ingredient = ingredient  

	
func add_ingredient(delta: float , ingredient : CoffeeIngredient.Ingredient) -> void:  
	const FLOW_RATE = 20
	
	if (last_ingredient == ingredient and layers.size() > 0):  		 
		layers[-1].percentage += delta * FLOW_RATE 
		print(layers[-1].percentage)
	else: 
		layers.append(CoffeeIngredient.new(ingredient, 0)) 
		
		
	last_ingredient = ingredient
		  
	
func ingredient_changed(new_ingredient : CoffeeIngredient.Ingredient): 
	if (current_ingredient == null or current_ingredient != new_ingredient): 
		generate_new_bar() 
		current_ingredient = new_ingredient

func _on_coffee_button_button_down() -> void:  
	add_first_ingredient(CoffeeIngredient.Ingredient.COFFEE)  
	ingredient_changed(CoffeeIngredient.Ingredient.COFFEE)
	is_flowing = true   
	$Nozzle.show()


func _on_chocolate_button_button_down() -> void: 
	add_first_ingredient(CoffeeIngredient.Ingredient.CHOCOLATE)  
	ingredient_changed(CoffeeIngredient.Ingredient.CHOCOLATE)
	is_flowing = true   
	$Nozzle.show()


func _on_foam_button_button_down() -> void: 
	add_first_ingredient(CoffeeIngredient.Ingredient.MILK_FOAM)  
	ingredient_changed(CoffeeIngredient.Ingredient.MILK_FOAM)
	is_flowing = true   
	$Nozzle.show()
	


func _on_milk_button_button_down() -> void: 
	add_first_ingredient(CoffeeIngredient.Ingredient.MILK)  
	ingredient_changed(CoffeeIngredient.Ingredient.MILK)
	is_flowing = true   
	$Nozzle.show()
	


func _on_coffee_button_button_up() -> void:
	is_flowing = false
	$Nozzle.hide()


func _on_chocolate_button_button_up() -> void:
	is_flowing = false
	$Nozzle.hide()


func _on_foam_button_button_up() -> void:
	is_flowing = false 
	$Nozzle.hide()


func _on_milk_button_button_up() -> void:
	is_flowing = false 
	$Nozzle.hide()


func _on_restart_button_pressed() -> void:
	layers = []
	is_flowing = false 
	first_run = true  
	failed = false  
	self._ready()  
	$FirstProgressBar.value = 0 
	for progress_bar in progress_bars: 
		progress_bar.hide() 
	progress_bars = []
