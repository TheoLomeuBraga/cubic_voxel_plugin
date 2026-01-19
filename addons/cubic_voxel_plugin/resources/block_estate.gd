extends Resource
class_name BlockEstate

enum Directions {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	FOWARD,
	BACK
}

@export var id : int
@export var direction : Directions = Directions.UP

func _init(_id : int,_direction : Directions = Directions.UP) -> void:
	id = _id
	_direction = _direction
