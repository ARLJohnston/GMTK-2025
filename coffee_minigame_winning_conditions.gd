class_name WinningConditions extends Node   

enum Drink {
	LATTE,
	CAPPUCCINO,
	MOCHA,  
	MACCHIATO
} 

var winning_conditions = {
	Drink.LATTE: [ 
		WinCondition.new(0.20, 0.30, CoffeeIngredient.Ingredient.COFFEE),
		WinCondition.new(0.75, 0.95, CoffeeIngredient.Ingredient.MILK),
		WinCondition.new(0.05, 0.10, CoffeeIngredient.Ingredient.MILK_FOAM)
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
