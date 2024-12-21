## Allows user to zoom in/out on the viewport
@tool
extends Camera2D

var dragging = false
var drag_init_pos: Vector2

## Tell parent to update the slider
signal zoom_level_changed(sig: int)

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
            dragging = true
            drag_init_pos = get_global_mouse_position()
        if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
            dragging = false
            drag_init_pos = Vector2.ZERO
            
        if event.is_pressed():
            if event.button_index == MOUSE_BUTTON_WHEEL_UP:
                zoom_level_changed.emit(1)
            if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
                zoom_level_changed.emit(-1)

func _process(delta: float) -> void:
    if dragging:
        var tartget_pos = position + (drag_init_pos - get_global_mouse_position())  
        position = tartget_pos
