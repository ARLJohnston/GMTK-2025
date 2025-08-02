extends Node  
 

var layers : Array[CoffeeIngredient]  
var last_ingredient : CoffeeIngredient.Ingredient    
var first_ingredient : CoffeeIngredient.Ingredient
var is_flowing : bool 
var current_ingredient : CoffeeIngredient.Ingredient   
var first_run : bool = true
 
@onready var current_bar: ProgressBar = $FirstProgressBar



func _process(delta: float) -> void:    
	
	if (is_flowing):  
		add_ingredient(delta, current_ingredient)
	
	if (self.layers.size() > 0 and is_flowing):  
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
	if (first_ingredient == null): 
		first_ingredient = ingredient
	
	
func add_ingredient(delta: float , ingredient : CoffeeIngredient.Ingredient) -> void:  
	const FLOW_RATE = 20
	
	if (last_ingredient == ingredient and layers.size() > 0):  		 
		#print(delta * FLOW_RATE)
		layers[-1].percentage += delta * FLOW_RATE 
	else: 
		layers.append(CoffeeIngredient.new(0, ingredient)) 
		
		
	last_ingredient = ingredient
		  
		
		
func ingredient_changed(new_ingredient : CoffeeIngredient.Ingredient): 
	if (current_ingredient != new_ingredient): 
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
