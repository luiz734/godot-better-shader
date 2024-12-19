@tool
extends EditorPlugin


var plugin_panel_prefab = preload("res://addons/better-shader/plugin_panel.tscn")
var plugin_panel

func _enter_tree() -> void:
    # Initialization of the plugin goes here.
    # Add the new type with a name, a parent type, a script and an icon.
    # add_custom_type("MyButton", "Button", preload("button.gd"), preload("icon.png"))
    
    plugin_panel = plugin_panel_prefab.instantiate()
    plugin_panel.plugin = self
    # add_control_to_bottom_panel(plugin_panel, "Better Shader")
    add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UR, plugin_panel)
   
    scene_saved.connect(on_save_scene)
   
func on_save_scene(filepath: String):
    var editor_interface = get_editor_interface()
    # add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL, s)
    # await get_tree().create_timer(4.0).timeout
    # remove_control_from_docks(s)
    # editor_interface.get_current_feature_profile()
   
    # print(s)
    

func _exit_tree() -> void:
    # Clean-up of the plugin goes here.
    # Always remember to remove it from the engine when deactivated.
    # remove_custom_type("MyButton")
    remove_control_from_bottom_panel(plugin_panel)
    plugin_panel.queue_free()
    
    if scene_changed.is_connected(on_save_scene):
        scene_saved.disconnect(on_save_scene)
