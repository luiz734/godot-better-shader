# better-shader

Godot plugin to improve shader development inside the engine.

## Problems
- Shader editor is split vertically alongside the 2D editor
- Manual setup is required for prototyping

This leaves almost no room for seeing the shader code.

## What this plugin does
- Adds a new dock dedicated to shader preview
- Edit your shader splitting **horizontally**
- No need for manual setup: start prototyping faster


## Setup
1. Install and enable the plugin
    - Clone the repo
    - Copy `addons/better-shader` to your `addons` directory
    - Go to `Project Settings > Plugins` and enable the addon
    - This should create a dock on the top left called *Shader Preview*
2. Create a shader material or use one of the examples
3. Click the *Set Material* button


### Common mistake
✅ Load materials: `my_material.tres`.

❌ **Don't** load shaders directly: `my_shader.gdshader`



**Be careful with cyclic references:** e.g. assign the plugin panel as the target scene. This can make your project not load anymore. Although you can easily fix this by editing the project file and the plugin directory, it's better to avoid. 

**Always** use version control to avoid issues while using external plugins.

## Usage
- Use left mouse click to drag
- Use the scroll wheel or the slider to zoom

### Buttons
- `Set Preview Scene` allows you to apply the shader on any scene (`target`)
  - It applies the material to the root node 
  - If you want to apply it to all the elements at once, make the root node a viewport container, viewport texture, etc
- `Remove (scene)`  sets the default `target`
  - Default target: a texture rect with the Godot icon
 - `Set material` sets the shader material
 - `Remove (material)` remove the material

### Apply to viewport 
The preview is rendered inside a viewport. Enabling this option will apply the current material to this viewport.
![preview](screenshots/preview.gif)

## Tips
- You can make the engine look like a dedicated shader editor by removing docks. 
- You can **disable** the plugin by removing the dock.

![fullscreen](screenshots/fullscreen.gif)

## Issues
### Can't add to dock
This happens if you enable and disable the plugin too quickly. I'm working on a fix for that.

**Workaround:** reload your project.

### My session doesn't restore
The session file is stored as a resource called `default tres`. It contains the target, the material and more options related to the plugin. If for some reason it keeps resetting your settings, inspect it and check for errors on the output console.

> Note: I never experienced this issue.


