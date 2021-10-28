//
//  ViewController.swift
//  ARGame
//
//  Created by admin on 14.03.2021.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let shapes = Shapes()
    
    @IBOutlet weak var colorSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.showsStatistics = true
        sceneView.scene.physicsWorld.contactDelegate = self
        shapes.placesCubes(sceneView: sceneView)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        shapes.placeSphere(sceneView: sceneView, color: colorSegmentedControl.selectedSegmentIndex)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}

extension ViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        let colorA = nodeA.geometry?.materials.first?.name
        let colorB = nodeB.geometry?.materials.first?.name
        
        if nodeB.physicsBody?.contactTestBitMask == BitMaskCategory.box {
            if (colorA! == colorB!) {
                nodeA.removeFromParentNode()
                nodeB.removeFromParentNode()
            } else {
                nodeB.removeFromParentNode()
            }
        }
    }
}
