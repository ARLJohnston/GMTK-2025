class_name WinCondition extends Node  

var lower_bound 
var upper_bound 
var ingredient

func _init(_lower_bound : float, _upper_bound : float, _ingredient: CoffeeIngredient.Ingredient):
	lower_bound = _lower_bound 
	upper_bound = _upper_bound 
	ingredient = _ingredient

	
