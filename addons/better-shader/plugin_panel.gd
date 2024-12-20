@tool
extends Control

var plugin: EditorPlugin
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

var bs_storage: BSStorage

var target
var default_target
var mouse_on_viewport = false

func _input(event: InputEvent):
    if mouse_on_viewport:
        subviewport.push_input(event)
        
func on_apply_to_viewport_toggled(toggled_on: bool):
    if toggled_on:
        subviewport_container.material = bs_storage.loaded_material
        target.material = null
    else:
        target.material = bs_storage.loaded_material
        subviewport_container.material = null
        
    bs_storage.apply_to_viewport = toggled_on
    ResourceSaver.save(bs_storage, "res://addons/better-shader/default.tres")
    
func on_set_shader_file_button_pressed():
    file_dialog_shader.popup_centered()
    
func on_shader_file_selected(path: String):
    var shader_file = load(path)
    var shader_material = ShaderMaterial.new()
    shader_material.shader = shader_file
    bs_storage.loaded_material = shader_material
    ResourceSaver.save(bs_storage, "res://addons/better-shader/default.tres")
    on_apply_to_viewport_toggled(apply_to_viewport.button_pressed)
    
func on_unset_shader_file_button_pressed():
    bs_storage.loaded_material.shader = null
    on_apply_to_viewport_toggled(apply_to_viewport.button_pressed)

func on_set_base_scene_button_pressed():
    file_dialog_scene.popup_centered()

func on_unset_base_scene_button_pressed():
    bs_storage.loaded_scene = null
    ResourceSaver.save(bs_storage, "res://addons/better-shader/default.tres") 
    var texture_rect = TextureRect.new()
    texture_rect.material = bs_storage.loaded_material
    for c in center_container.get_children():
        c.queue_free()
    center_container.add_child(texture_rect)
    texture_rect.texture = load("res://icon.svg")
    target = texture_rect

func on_scene_file_selected(path: String):
    bs_storage.loaded_scene = load(path)
    ResourceSaver.save(bs_storage, "res://addons/better-shader/default.tres")
    var instance = bs_storage.loaded_scene.instantiate()
    instance.material = bs_storage.loaded_material
    target = instance  
    for c in center_container.get_children():
        c.queue_free()
    center_container.add_child(instance)

func on_subviewport_container_resized():
    center_container.size = subviewport_container.size
    
func on_zoom_level_value_changed(value: float):
    camera.zoom = Vector2(zoom_level_slider.value, zoom_level_slider.value)
    
func on_zoom_wheel_changed(sig: int):
    zoom_level_slider.value += sig * 0.1

func on_mouse_in():
    mouse_on_viewport = true
func on_mouse_out():
    mouse_on_viewport = false

func _ready() -> void:
    file_dialog_shader.file_selected.connect(on_shader_file_selected)
    file_dialog_scene.file_selected.connect(on_scene_file_selected)
    
    set_shader_file_button.pressed.connect(on_set_shader_file_button_pressed)
    unset_shader_file_button.pressed.connect(on_unset_shader_file_button_pressed)
    
    set_base_scene_button.pressed.connect(on_set_base_scene_button_pressed)
    unset_base_scene_button.pressed.connect(on_unset_base_scene_button_pressed)
    
    apply_to_viewport.toggled.connect(on_apply_to_viewport_toggled)
    
    zoom_level_slider.value_changed.connect(on_zoom_level_value_changed)
    
    subviewport_container.item_rect_changed.connect(on_subviewport_container_resized)
    subviewport_container.mouse_entered.connect(on_mouse_in)
    subviewport_container.mouse_exited.connect(on_mouse_out)
    camera.zoom_level_changed.connect(on_zoom_wheel_changed)
    
    bs_storage = ResourceLoader.load("res://addons/better-shader/default.tres")
    
    if bs_storage.loaded_material == null:
        bs_storage.loaded_material = ShaderMaterial.new()
    target = TextureRect.new()
    target.texture = load("res://icon.svg")
    if bs_storage.loaded_scene:
        target = bs_storage.loaded_scene.instantiate()
    
    target.material = bs_storage.loaded_material
    for c in center_container.get_children():
        c.queue_free()
    center_container.add_child(target)
    
    apply_to_viewport.button_pressed = bs_storage.apply_to_viewport
    
  
    
