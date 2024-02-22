# ShaderGraphParameterAnimationExample

This example demonstrates how to modify a VisionOS RealityKit model using a custom shader graph built using Reality Compose Pro, use it in a project, and then animate the parameters of the shader graph in Swift.

## Description

The goal is to render a clipped sphere in vision OS and animate the clipping of the sphere. See the example below:

![alt text](<Documentation/Screen Recording 2024-02-22 at 10.54.00.gif>)

Doing this by animating the sphere's geometry at runtime would be inefficient. A better way is to use shaders. However, on VisionOS, shaders are not supported due to valid security concerns (thanks Facebook). However, RealityKit on visionOS does provide the ability to create [MaterialX](https://developer.apple.com/wwdc23/10202) shaders using Reality Compose Pro. This example demonstrates how to create a custom shader graph using Reality Compose Pro, expose shader parameters to Swift, and then animate them.

### Shader Graph

![alt text](<Documentation/Screenshot 2024-02-22 at 10.52.37.png>)

This simple shader graph controls the output opacity of the geometry's pixels based on the distance from the model's center. I take the geometry's texture coordinate value (see the `Texcoord` node in the example), extract the Y value from it (the `Swizzle_1` node), then compare it (`ifgreater` and `ifgreater1`) to user-defined parameters `MIN_Y`, `MAX_Y` to decide if the pixel should be visible or not. The output of the shader graph is an unlit surface (`UnlitSurface` material).

The output color of the unlit surface is hard-coded to magenta. To use this shader graph in production, you'll want to expose the color as a parameter. You may also need to create variants of this graph for different material types.

It's possible that this graph could be streamlined, but I wanted to keep it simple for this example.

### Modifying Parameters in Swift

The Swift code is relatively simple. You can modify a material's shader graph parameters using the following code:

```swift
try material.setParameter(name: "MIN_Y", value: .float(value))
```

Accessing the model entities and the materials upon them is a bit of a pain, but I've been using my [`RealityKitSupport`](https://github.com/schwa/RealityKitSupport) helper library to make it easier.

### Animating Parameters in Swift

Unfortunately, RealityKit's (rather convoluted) explicit animation functionality does not support animating shader parameters. However, you can write your own timer-based animation loop to animate the parameters yourself. The code implements a SwiftUI `TimelineView` to animate the parameters of every frame (via RealityView's update handler). This example is straightforward, but you may want to use a more sophisticated animation implementation for an actual project.

* `FB13645019`: RealityKit's animation system cannot animate ShaderGraphMaterial custom parameters
