extends RigidBody2D

onready var line : Line2D = $"%Line2D"
const _max_distance : float = 240.0
var _throwable : bool = false

func _physics_process(delta: float) -> void:
	if not _throwable:
		return
	
	_calculate_force()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.is_pressed() and _throwable:
		_throwable = false
		_throw()

func _on_Throwable_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		_throwable = event.is_pressed()

func _calculate_force() -> Vector2:
	var mouse_position : Vector2 = get_global_mouse_position()
	var direction : Vector2 = mouse_position.direction_to(global_position)
	var distance : float = min(mouse_position.distance_to(global_position), _max_distance)
	
	var power : Vector2 = direction * distance
	
	var half_distance : float = _max_distance / 2.0
	var below_half = distance <= half_distance
	
	var green : float = 1 if below_half else (_max_distance - distance) / half_distance
	var red : float = 1 - ((half_distance - distance) / half_distance) if below_half else 1

	line.default_color = Color(red, green, 0)
	line.points = [power * -1, global_position - position]
	line.global_position = global_position
	
	return power * 5
	
func _throw() -> void:
	var force : Vector2 = _calculate_force()
	line.points = []
	apply_central_impulse(force)
