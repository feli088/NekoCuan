//
//  LaunchViewController.swift
//  NekoCuan
//
//  Created by Felicia Diana on 24/05/24.
//
import UIKit
import AVKit
import AVFoundation

class LaunchViewController: UIViewController {

    var player: AVQueuePlayer?
    var playerLooper: AVPlayerLooper?
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color to clear
        view.backgroundColor = .clear

        // Setup video background
        setupVideoBackground()

        // Create and setup the Maneki Neko UIImageView
        let nekoImageView = UIImageView(image: UIImage(named: "fortunecat")) // Assuming you named the image 'fortunecat'
        nekoImageView.contentMode = .scaleAspectFit
        nekoImageView.translatesAutoresizingMaskIntoConstraints = false

        // Create and setup the UILabel for main text
        let mainLabel = UILabel()
        mainLabel.text = "Scan your Angpao!"
        mainLabel.font = UIFont(name: "Baloo2-Bold", size: 36) ?? UIFont.boldSystemFont(ofSize: 36)
        mainLabel.textColor = .white
        mainLabel.textAlignment = .center
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create and setup the UILabel for subtext
        let subLabel = UILabel()
        subLabel.text = "and Get your Fortune Blessings from the Manekineko"
        subLabel.font = UIFont(name: "Baloo2-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20)
        subLabel.textColor = .white
        subLabel.textAlignment = .center
        subLabel.translatesAutoresizingMaskIntoConstraints = false

        // Create and setup the UIButton
        let startButton = UIButton(type: .system)
        startButton.setTitle("Start", for: .normal)
        startButton.titleLabel?.font = UIFont(name: "Baloo2-Bold", size: 24) ?? UIFont.boldSystemFont(ofSize: 24)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = .red
        startButton.layer.cornerRadius = 10
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)

        // Create a UIStackView for the cat image and labels
        let imageAndLabelsStackView = UIStackView(arrangedSubviews: [nekoImageView, mainLabel, subLabel])
        imageAndLabelsStackView.axis = .vertical
        imageAndLabelsStackView.alignment = .center
        imageAndLabelsStackView.spacing = 4
        imageAndLabelsStackView.translatesAutoresizingMaskIntoConstraints = false

        // Create a parent UIStackView
        let parentStackView = UIStackView(arrangedSubviews: [imageAndLabelsStackView, startButton])
        parentStackView.axis = .vertical
        parentStackView.alignment = .center
        parentStackView.spacing = 32
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(parentStackView)

        // Add constraints
        NSLayoutConstraint.activate([
            // Parent StackView constraints
            parentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            parentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            // Width constraints for labels and button
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            subLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.heightAnchor.constraint(equalToConstant: 50),

            // Width and height constraints for image view
            nekoImageView.widthAnchor.constraint(equalToConstant: 320),
            nekoImageView.heightAnchor.constraint(equalToConstant: 320)
        ])
        
        // Play background music
        playBackgroundMusic()
    }

    func setupVideoBackground() {
        guard let path = Bundle.main.path(forResource: "02", ofType: "mp4") else {
            debugPrint("02.mp4 not found")
            return
        }

        let playerItem = AVPlayerItem(url: URL(fileURLWithPath: path))
        player = AVQueuePlayer(playerItem: playerItem)
        playerLooper = AVPlayerLooper(player: player!, templateItem: playerItem)

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill

        // Insert the playerLayer at the bottom of the view's layer stack
        view.layer.insertSublayer(playerLayer, at: 0)

        player?.play()

        // Add observer to monitor when the player starts playing
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidStartPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
    }

    @objc func playerDidStartPlaying() {
        debugPrint("Video started playing")
    }

    func playBackgroundMusic() {
        guard let path = Bundle.main.path(forResource: "cny", ofType: "mp3") else {
            debugPrint("cny.mp3 not found")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            audioPlayer?.play()
        } catch {
            print("Could not load file")
        }
    }

    @objc func startButtonTapped() {
        let arViewController = ViewController()
        arViewController.modalPresentationStyle = .fullScreen
        present(arViewController, animated: true, completion: nil)
    }
}
