# Better Procedural Terrain
A voxel-based procedural terrain generation tool made in Godot (3.2).

# Overview
Previously, I've made a terrain generation tool in Unity that uses heightmaps generated from 2D Perlin noise and creates terrain meshes based on said heightmaps. This project attempts to improve on that in a number of ways, including:
### Made in Godot
Godot is not inherently a better game engine than Unity. In fact, it's less feature rich and there is less community support and documentation. That being said, I prefer Godot because:
- It's lightweight and runs better on my system
- It uses GDScript, which is similar to Python and results in quicker development
- It uses a unique node-based structure which I think results in a better project and game structure
- It's FOSS, which I like to support when possible
### Voxels
Heightmaps inherently can't support any subsurface data, so terrains won't feature caves, overhangs, or other interesting features. This better terrain generation tool uses voxel data generated from 3D Perlin noise, and a marching cubes algorithm that constructs meshes from said voxel data. While more complicated, this system is more flexible and can be used to create more interesting terrains (and other objects).
### Multiple Chunk Generation
The last project only generated one terrain chunk at a time. On it's own, that's not very interesting and can't really be used to make an entire world. This project aims to include a system that handles generating multiple chunks based on the player's location, and to stitch these chunks together seamlessly. While still a tech demo, this system could eventually be used to create an interesting game world.
### Texture Support
The previous terrain generation tool included a shader that colored each vertex based on its height. It was limited to only a few colors, and resulted in jagged textures for the terrain that looked strange up close. The improved terrain generation tool will support textures for the terrain, and will include shaders that can mix textures together based on different criteria, including slope and height of the terrain.

# How to Use
- Pull the project and import it into Godot. 
- You should be able to already see some generated terrain. If not, make sure you've opened Scenes/Main.tscn and run **Scenes -> Reload Saved Scene**.
- You can mess with the terrain properties in *Globals/Properties/ChunkProps.gd*. You can replace terrain texture by importing your texture files and adding them to the terrain material which is located at *Entities/Terrain/Chunk/Assets/Materials/Terrain.tres*.

# References
- Godot Engine -- https://godotengine.org/
- Voxels -- https://en.wikipedia.org/wiki/Voxel
- Marching Cubes -- http://paulbourke.net/geometry/polygonise/
