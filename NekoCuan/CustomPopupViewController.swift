//
//  CustomPopupViewController.swift
//  NekoCuan
//
//  Created by Felicia Diana on 18/05/24.
//

import UIKit

class CustomPopupViewController: UIViewController {
    var image: UIImage? // Property to hold the image

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color to semi-transparent black
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Create a container view for the popup content
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 10
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Add constraints to center the container view
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // Add an image view to the container view
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)
        
        // Add constraints for the image view
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.7)
        ])
        
        // Add a close button to the container view
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(closeButton)
        
        // Add constraints for the close button
        NSLayoutConstraint.activate([
            closeButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            closeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}





