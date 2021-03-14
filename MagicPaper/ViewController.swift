//
//  ViewController.swift
//  MagicPaper
//
//  Created by Bogdan Orzea on 2021-03-13.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "Newspaper Images", bundle: .main) {
            configuration.detectionImages = trackedImages
            configuration.maximumNumberOfTrackedImages = 1
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()

        if let imageAnchor = anchor as? ARImageAnchor {
            // Create a SpriteKit scene
            let videoScene = SKScene(size: CGSize(width: 1280.0, height: 720.0))
            // Create a SpriteKit VideoNode
            let videoNode = SKVideoNode(fileNamed: "harrypotter.mp4")
            videoNode.play()
            // Flip the video
            videoNode.yScale = -1.0
            // Center the video into the scene
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            videoScene.addChild(videoNode)

            let plane = SCNPlane(
                width: imageAnchor.referenceImage.physicalSize.width,
                height: imageAnchor.referenceImage.physicalSize.height
            )

            // Adds VideoScene as the material of the plane
            plane.firstMaterial?.diffuse.contents = videoScene

            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -Float.pi / 2

            node.addChildNode(planeNode)
        }

        return node
    }


}
