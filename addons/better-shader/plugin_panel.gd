@tool
extends Control

var plugin: EditorPlugin
@onready var shader_file_button: Button  = %SetShaderFile
@onready var base_scene_button: Button  = %SetBaseScene
@onready var zoom_level_slider: HSlider  = %SetZoomLevel
@onready var file_dialog_shader: FileDialog  = %FileDialogShader
@onready var subviewport_container: SubViewportContainer  = %SubViewportContainer
@onready var subviewport: SubViewport  = %SubViewport
@onready var center_container: CenterContainer  = %CenterContainer
@onready var camera: Camera2D  = %Camera2D

var mouse_on_viewport = false

func _input(event: InputEvent):
    if mouse_on_viewport:
        subviewport.push_input(event)
    
func on_shader_file_button_pressed():
    file_dialog_shader.popup_centered()
    print("shader file")

func on_base_scene_button_pressed():
    subviewport_container.hide()
    print("base scene")

func on_shader_file_selected():
    print("file selected")

func on_subviewport_container_resized():
    #print("resize")
    center_container.size = subviewport_container.size
    
func on_zoom_level_value_changed(value: float):
    #print("zoom to " + str(zoom_level_slider.value))
    camera.zoom = Vector2(zoom_level_slider.value, zoom_level_slider.value)
    
func on_zoom_wheel_changed(sig: int):
    zoom_level_slider.value += sig * 0.1

func on_mouse_in():
    mouse_on_viewport = true
func on_mouse_out():
    mouse_on_viewport = false

func _ready() -> void:
    file_dialog_shader.file_selected.connect(on_shader_file_selected)
    shader_file_button.pressed.connect(on_shader_file_button_pressed)
    base_scene_button.pressed.connect(on_base_scene_button_pressed)
    zoom_level_slider.value_changed.connect(on_zoom_level_value_changed)
    
    subviewport_container.item_rect_changed.connect(on_subviewport_container_resized)
    subviewport_container.mouse_entered.connect(on_mouse_in)
    subviewport_container.mouse_exited.connect(on_mouse_out)
    camera.zoom_level_changed.connect(on_zoom_wheel_changed)
