extends Resource
## Store last session
class_name BSStorage

@export var loaded_scene: PackedScene
@export var loaded_material: Material
@export var apply_to_viewport: bool
@export var zoom_level: Vector2 = Vector2(0.1, 0.1)
@export var camera_position: Vector2 = Vector2(0.0, 0.0)
