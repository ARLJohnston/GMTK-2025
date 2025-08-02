extends Node  
 

var layers : Array[CoffeeIngredient]  
var last_ingredient : CoffeeIngredient.Ingredient    
var first_ingredient : CoffeeIngredient.Ingredient
var is_flowing : bool 
var current_ingredient : CoffeeIngredient.Ingredient   
var first_run : bool = true
 
@onready var current_bar: ProgressBar = $FirstProgressBar  

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

func _process(delta: float) -> void:    
	
	if (is_flowing):   
		add_ingredient(delta, current_ingredient)
	
	if (self.layers.size() > 0 and is_flowing):   
		var actual_ingredient_str = CoffeeIngredient.Ingredient.keys()[current_ingredient] 
		print(actual_ingredient_str)
		current_bar.value = layers[-1].percentage 
		match current_ingredient: 
			CoffeeIngredient.Ingredient.COFFEE: 
				current_bar.modulate = Color.SADDLE_BROWN  
			CoffeeIngredient.Ingredient.MILK: 
				current_bar.modulate = Color.MINT_CREAM 
			CoffeeIngredient.Ingredient.MILK_FOAM: 
				current_bar.modulate = Color.ANTIQUE_WHITE
			CoffeeIngredient.Ingredient.CHOCOLATE: 
				current_bar.modulate = Color.BROWN      
				
	const CHECK_THRESHOLD_LOWER = 90
	const CHECK_THRESHOLD_UPPER = 110
	var current_fill = sum()
	
	if current_fill > CHECK_THRESHOLD_UPPER: 
		print("failed") 
		
	if (current_fill > CHECK_THRESHOLD_LOWER and current_fill < CHECK_THRESHOLD_UPPER): 
		evaluate_drink()
		   
		
		
func evaluate_drink() -> void:
	var conditions = winning_conditions[Drink.LATTE] 
	var is_drink_complete = true

	print("Evaluating drink for:", Drink.keys()[Drink.LATTE])
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
		print("✅ Matched drink:", Drink.keys()[Drink.LATTE])
	else:
		print("❌ Drink did not match.")

	
#func does_match_conditions(conditions: Array[WinCondition]) -> bool:
	#if conditions.size() != layers.size():
		#return false
	#
	#for i in range(layers.size()):
		#var layer = layers[i]
		#var condition = conditions[i]
		#
		#if layer.ingredient != condition.ingredient:
			#return false
		#if layer.percentage < condition.lower_bound * 100 or layer.percentage > condition.upper_bound * 100:
			#return false
	#
	#return true


				
	
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
	var transparent_bg_style = StyleBoxFlat.new()
	transparent_bg_style.bg_color = Color(0, 0, 0, 0) 
	transparent_bg_style.set_corner_radius_all(5)

	new_bar.add_theme_stylebox_override("background", transparent_bg_style)
	
	var percentage = layers[-1].percentage  / 100
	var fractional_size = percentage * current_bar.size.y  
	
	
	
	const MARGIN = 4

	new_bar.position = current_bar.position - Vector2(0, fractional_size * 2 + MARGIN)  
	
	current_bar.get_parent().add_child(new_bar) 
	
	current_bar = new_bar
	
func add_first_ingredient(ingredient : CoffeeIngredient.Ingredient): 
	if first_ingredient == null:
		first_ingredient = ingredient
		layers.append(CoffeeIngredient.new(0, ingredient))  # Add a fresh layer
		last_ingredient = ingredient  # Also update last_ingredient to match

	
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


func _on_chocolate_button_button_down() -> void: 
	add_first_ingredient(CoffeeIngredient.Ingredient.CHOCOLATE)  
	ingredient_changed(CoffeeIngredient.Ingredient.CHOCOLATE)
	is_flowing = true  


func _on_foam_button_button_down() -> void: 
	add_first_ingredient(CoffeeIngredient.Ingredient.MILK_FOAM)  
	ingredient_changed(CoffeeIngredient.Ingredient.MILK_FOAM)
	is_flowing = true  


func _on_milk_button_button_down() -> void: 
	add_first_ingredient(CoffeeIngredient.Ingredient.MILK)  
	ingredient_changed(CoffeeIngredient.Ingredient.MILK)
	is_flowing = true  


func _on_coffee_button_button_up() -> void:
	is_flowing = false


func _on_chocolate_button_button_up() -> void:
	is_flowing = false


func _on_foam_button_button_up() -> void:
	is_flowing = false


func _on_milk_button_button_up() -> void:
	is_flowing = false
