
import Foundation
import ARKit
import SceneKit

class Shapes: SCNNode {
    let colors: [UIColor] = [.red, .black, .blue, .yellow, .green, . orange]
    let size: CGFloat = 0.15
    let range = -2.0...2.0
    
    private func placeCube(sceneView: ARSCNView) {
        
        let cubeGeomtery = SCNBox(width: size, height: size, length: size, chamferRadius: 0)
        let material = SCNMaterial()
        let random = Int.random(in: 0...5)
        material.diffuse.contents = colors[random]
        material.name = String(random)
        cubeGeomtery.materials = [material]
        
        let cubeNode = SCNNode(geometry: cubeGeomtery)
        cubeNode.position = SCNVector3(Double.random(in: range), Double.random(in: range), Double.random(in: range))
        
        let physicsShape = SCNPhysicsShape(geometry: cubeGeomtery, options: nil)
        cubeNode.physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
        cubeNode.physicsBody?.categoryBitMask = BitMaskCategory.box
        cubeNode.physicsBody?.collisionBitMask = BitMaskCategory.sphere
        cubeNode.physicsBody?.contactTestBitMask = BitMaskCategory.sphere
        
        sceneView.scene.rootNode.addChildNode(cubeNode)
    }
    
    func placesCubes(sceneView: ARSCNView) {
        for _ in 1...100 {
            placeCube(sceneView: sceneView)
        }
    }
    
    func placeSphere(sceneView: ARSCNView, color: Int) {
        let sphere = SCNSphere(radius: 0.2)
        let material = SCNMaterial()
        material.diffuse.contents = colors[color]
        material.name = String(color)
        sphere.materials = [material]
        
        let sphereNode = SCNNode(geometry: sphere)
    
        
        let physicsShape = SCNPhysicsShape(geometry: sphere, options: nil)
        sphereNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicsShape)
        sphereNode.physicsBody?.mass = 0.3
        sphereNode.physicsBody?.categoryBitMask = BitMaskCategory.sphere
        sphereNode.physicsBody?.collisionBitMask = BitMaskCategory.box
        sphereNode.physicsBody?.contactTestBitMask = BitMaskCategory.box
        
        let force = simd_make_float4(0, 0, -5, 0)
        let rotatedForce = simd_mul((sceneView.session.currentFrame?.camera.transform)!, force)
        let vectorForce = SCNVector3(x:rotatedForce.x, y:rotatedForce.y, z:rotatedForce.z)
        sphereNode.physicsBody?.applyForce(vectorForce, asImpulse: true)
        
        sceneView.scene.rootNode.addChildNode(sphereNode)
    }
}
