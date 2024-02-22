import SwiftUI
import RealityKit

import RealityKitContent
import RealityKitSupport

struct ContentView: View {
    @State
    var minY: Float = 0.0

    @State
    var maxY: Float = 1.0

    let start = Date()

    var body: some View {
        VStack {
            TimelineView(.animation) { context in
                RealityView { content in
                    guard let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) else {
                        fatalError()
                    }
                    content.add(scene)
                } update: { content in
                    guard let sphere = content.firstEntity(named: "Sphere") as? ModelEntity else {
                        fatalError()
                    }
                    guard var material = sphere.model!.materials.first as? ShaderGraphMaterial else {
                        fatalError()
                    }
                    let delta = context.date.timeIntervalSince(start)
                    let value = Float(abs(delta.remainder(dividingBy: 1.0))) / 1.0
                    try! material.setParameter(name: "MIN_Y", value: .float(value))
                    try! material.setParameter(name: "MAX_Y", value: .float(1.0 - value))
                    sphere.model!.materials = [material]
                }
            }
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
