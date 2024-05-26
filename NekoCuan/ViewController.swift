//
//  ViewController.swift
//  NekoCuan
//
//  Created by Felicia Diana on 16/05/24.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    var imageView: UIImageView?
    var images: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView(frame: view.frame)
        view.addSubview(sceneView)
        
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        loadImages()
        setupImageView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "ARImages", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1
        
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    @objc func handleTap(_ gestureRecognize: UITapGestureRecognizer) {
        let location = gestureRecognize.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(location, options: nil)
        if let hitTestResult = hitTestResults.first {
            let node = hitTestResult.node
            if node.name == "__Head_Head_0" {
                showRandomImage()
            }
        }
    }
    
    func loadImages() {
        images = [
            UIImage(named: "Image1")!,
            UIImage(named: "Image2")!,
            UIImage(named: "Image3")!,
            UIImage(named: "Image4")!,
        ]
    }
    
    func setupImageView() {
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFit
        imageView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.isHidden = true
        imageView?.isUserInteractionEnabled = true
        imageView?.layer.cornerRadius = 16
        imageView?.layer.masksToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissImage))
        imageView?.addGestureRecognizer(tapGestureRecognizer)
        
        if let imageView = imageView {
            self.view.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 400),
                imageView.heightAnchor.constraint(equalToConstant: 800)
            ])
        }
    }
    
    func showRandomImage() {
        guard !images.isEmpty else { return }
        let randomImage = images.randomElement()
        imageView?.image = randomImage
        imageView?.isHidden = false
        imageView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.imageView?.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    @objc func dismissImage() {
        imageView?.isHidden = true
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        DispatchQueue.main.async {
            self.addPlane(anchor: imageAnchor, node: node)
        }
    }
    
    func addPlane(anchor: ARImageAnchor, node: SCNNode) {
        let plane = SCNPlane(width: anchor.referenceImage.physicalSize.width, height: anchor.referenceImage.physicalSize.height)
        plane.materials.first?.diffuse.contents = UIColor.red
        plane.materials.first?.isDoubleSided = true
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(anchor.transform.columns.3.x, 0, anchor.transform.columns.3.z)
        node.addChildNode(planeNode)
        add3DObject(to: planeNode)
    }
    
    func add3DObject(to node: SCNNode) {
        guard let objectScene = SCNScene(named: "art.scnassets/fortunecat.scn") else {
            fatalError("Could not load 3D model")
        }
        let objectNode = objectScene.rootNode.clone()
        objectNode.scale = SCNVector3(0.1, 0.1, 0.1)
        objectNode.position = SCNVector3Zero
        objectNode.name = "fortunecat"
        node.addChildNode(objectNode)
    }
}





