class_name Camera
extends Node3D

@onready var ray_cast_3d: RayCast3D = $Camera3D/RayCast3D
@onready var hand: Node3D = $Hand


var player_controller : PlayerContoller
var input_rotation: Vector3
var mouse_input : Vector2

const MOUSE_SENSIVITY : float = .005


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player_controller = get_parent()


# Get Input 
func _input(event: InputEvent) -> void:
	# Get Mouse motion and apply it to mouse_input vareble so we cold use it to rotate camera
	if event is InputEventMouseMotion:
		mouse_input.x -= event.screen_relative.x * MOUSE_SENSIVITY
		mouse_input.y -= event.screen_relative.y * MOUSE_SENSIVITY


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Limits the rotation of camera
	input_rotation.x = clampf(input_rotation.x + mouse_input.y, deg_to_rad(-90), deg_to_rad(85))
	input_rotation.y += mouse_input.x # Just to rotate on y axsis left and right 

	player_controller.camera_contoller_anchor.transform.basis = Basis.from_euler(Vector3(input_rotation.x, 0.0, 0.0))

	player_controller.global_transform.basis = Basis.from_euler(Vector3(0.0, input_rotation.y, 0.0))

	global_transform = player_controller.camera_contoller_anchor.get_global_transform_interpolated()

	mouse_input = Vector2.ZERO


	var object := ray_cast_3d.get_collider()
	if ray_cast_3d.is_colliding():
		if object.is_in_group("Pickable"):
			if Input.is_action_pressed("hold"):
				object.
