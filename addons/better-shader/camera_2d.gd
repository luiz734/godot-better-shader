@tool
extends Camera2D

var dragging = false
var init_pos: Vector2
var base_pos: Vector2

signal zoom_level_changed(sig: int)

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
            dragging = true
            init_pos = get_global_mouse_position()
        if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
            dragging = false
            init_pos = Vector2.ZERO
            
        if event.is_pressed():
            if event.button_index == MOUSE_BUTTON_WHEEL_UP:
                zoom_level_changed.emit(1)
            if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
                zoom_level_changed.emit(-1)

func _process(delta: float) -> void:
    if dragging:
        var tartget_pos = base_pos + (init_pos - get_global_mouse_position())  
        position = tartget_pos
        base_pos = position
    
        
        
