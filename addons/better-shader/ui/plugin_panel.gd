@tool
extends Control

@onready var set_shader_file_button: Button  = %SetShaderFile
@onready var unset_shader_file_button: Button  = %UnsetShaderFile
@onready var file_dialog_shader: FileDialog  = %FileDialogShader

@onready var set_base_scene_button: Button  = %SetBaseScene
@onready var unset_base_scene_button: Button  = %UnsetBaseScene
@onready var file_dialog_scene: FileDialog = %FileDialogScene

@onready var apply_to_viewport: CheckButton = %ApplyToViewport

@onready var zoom_level_slider: HSlider  = %SetZoomLevel
@onready var subviewport_container: SubViewportContainer  = %SubViewportContainer
@onready var subviewport: SubViewport  = %SubViewport
@onready var center_container: CenterContainer  = %CenterContainer
@onready var camera: Camera2D  = %Camera2D

const BS_STORAGE_PATH = "res://addons/better-shader/session.tres"
const ICON_PATH = "res://addons/better-shader/icon.svg"
var default_texture = preload(ICON_PATH)

## Resource to store last setup
var bs_storage: BSStorage

## Current node the material is being applyied to
var material_target

## Used to foward the events to the viewport
var mouse_on_viewport = false

func _ready() -> void:
    # Shader file 
    set_shader_file_button.pressed.connect(_on_set_shader_file_button_pressed)
    unset_shader_file_button.pressed.connect(on_unset_shader_file_button_pressed)
    file_dialog_shader.file_selected.connect(on_shader_file_selected)
    
    # Scene file
    set_base_scene_button.pressed.connect(on_set_base_scene_button_pressed)
    unset_base_scene_button.pressed.connect(on_unset_base_scene_button_pressed)
    file_dialog_scene.file_selected.connect(on_scene_file_selected)
    
    # Other callbacks
    apply_to_viewport.toggled.connect(_on_apply_to_viewport_toggled)
    zoom_level_slider.value_changed.connect(on_zoom_level_value_changed)
    subviewport_container.item_rect_changed.connect(on_subviewport_container_resized)
    subviewport_container.mouse_entered.connect(on_mouse_in)
    subviewport_container.mouse_exited.connect(on_mouse_out)
    camera.zoom_level_changed.connect(on_zoom_wheel_changed)
    camera.position_changed.connect(on_camera_position_changed)
    
    # Setup the last session
    if not FileAccess.file_exists(BS_STORAGE_PATH):
        bs_storage = BSStorage.new()
        ResourceSaver.save(BSStorage.new(), BS_STORAGE_PATH)

    bs_storage = ResourceLoader.load(BS_STORAGE_PATH)

    if bs_storage.loaded_material == null:
        bs_storage.loaded_material = ShaderMaterial.new()
    material_target = TextureRect.new()
    material_target.texture = default_texture
    if bs_storage.loaded_scene:
        material_target = bs_storage.loaded_scene.instantiate()
    material_target.material = bs_storage.loaded_material
    for c in center_container.get_children():
        c.queue_free()
    center_container.add_child(material_target)
    apply_to_viewport.button_pressed = bs_storage.apply_to_viewport
    zoom_level_slider.value = bs_storage.zoom_level.x
    camera.zoom = bs_storage.zoom_level
    camera.position = bs_storage.camera_position

    print("setup done")


# Only foward inputs
func _input(event: InputEvent):
    if mouse_on_viewport:
        subviewport.push_input(event)

        
## Apply the shader to the viewport or the target
func _on_apply_to_viewport_toggled(toggled_on: bool):
    if toggled_on:
        subviewport_container.material = bs_storage.loaded_material
        material_target.material = null
    else:
        material_target.material = bs_storage.loaded_material
        subviewport_container.material = null
        
    bs_storage.apply_to_viewport = toggled_on
    ResourceSaver.save(bs_storage, BS_STORAGE_PATH)


#############
# Shader File 
#############
func _on_set_shader_file_button_pressed():
    file_dialog_shader.popup_centered()

func on_shader_file_selected(path: String):
    var material_file = load(path)
    #var shader_material = ShaderMaterial.new()
    #shader_material.shader = shader_file
    bs_storage.loaded_material = material_file
    ResourceSaver.save(bs_storage, BS_STORAGE_PATH)
    _on_apply_to_viewport_toggled(apply_to_viewport.button_pressed)
    
func on_unset_shader_file_button_pressed():
    bs_storage.loaded_material.shader = null
    _on_apply_to_viewport_toggled(apply_to_viewport.button_pressed)


#############
# Scene File
#############
func on_set_base_scene_button_pressed():
    file_dialog_scene.popup_centered()

func on_unset_base_scene_button_pressed():
    bs_storage.loaded_scene = null
    ResourceSaver.save(bs_storage, BS_STORAGE_PATH) 
    var texture_rect = TextureRect.new()
    texture_rect.material = bs_storage.loaded_material
    for c in center_container.get_children():
        c.queue_free()
    center_container.add_child(texture_rect)
    texture_rect.texture = default_texture
    material_target = texture_rect

func on_scene_file_selected(path: String):
    bs_storage.loaded_scene = load(path)
    ResourceSaver.save(bs_storage, BS_STORAGE_PATH)
    var instance = bs_storage.loaded_scene.instantiate()
    instance.material = bs_storage.loaded_material
    material_target = instance  
    for c in center_container.get_children():
        c.queue_free()
    center_container.add_child(instance)


# Other signals callbacks
func on_subviewport_container_resized():
    center_container.size = subviewport_container.size

func on_camera_position_changed(pos: Vector2):
    bs_storage.camera_position = pos
    ResourceSaver.save(bs_storage, BS_STORAGE_PATH)

func on_zoom_level_value_changed(value: float):
    camera.zoom = Vector2(zoom_level_slider.value, zoom_level_slider.value)
    bs_storage.zoom_level = Vector2(zoom_level_slider.value, zoom_level_slider.value)
    ResourceSaver.save(bs_storage, BS_STORAGE_PATH)
    # TODO: stop writing on every change

func on_zoom_wheel_changed(sig: int):
    zoom_level_slider.value += sig * 0.1
    bs_storage.zoom_level = Vector2(zoom_level_slider.value, zoom_level_slider.value)
    ResourceSaver.save(bs_storage, BS_STORAGE_PATH)

func on_mouse_in():
    mouse_on_viewport = true
func on_mouse_out():
    mouse_on_viewport = false
