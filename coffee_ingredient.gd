class_name CoffeeIngredient extends Node

enum Ingredient {
	MILK,
	COFFEE,
	MILK_FOAM,
	CHOCOLATE
} 

var percentage: float
var ingredient: Ingredient

func _init(p_ingredient: Ingredient, p_percentage: float = 0.0,):
	percentage = p_percentage
	ingredient = p_ingredient

# Optional: A helper function to get the ingredient name as a string
func get_ingredient_name() -> String:
	match ingredient:
		Ingredient.MILK: return "Milk"
		Ingredient.COFFEE: return "Coffee"
		Ingredient.MILK_FOAM: return "Foam"
		Ingredient.CHOCOLATE: return "Chocolate"
	push_error("Ingredient does not exist!") 
	return "None"


func get_info() -> String:
	return "%s: %.1f%%" % [get_ingredient_name(), percentage]
