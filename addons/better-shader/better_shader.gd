@tool
extends EditorPlugin


var plugin_panel_prefab = preload("res://addons/better-shader/plugin_panel.tscn")
var plugin_panel

## Init plugin
func _enter_tree() -> void:
    plugin_panel = plugin_panel_prefab.instantiate()
    add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UR, plugin_panel)

## Clean up
func _exit_tree() -> void:
    remove_control_from_bottom_panel(plugin_panel)
    plugin_panel.queue_free()
