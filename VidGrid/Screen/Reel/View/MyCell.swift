//
//  MyCell.swift
//  VidGrid
//
//  Created by iMac on 06/08/24.
//

import UIKit
import AVFoundation
import SDWebImage

class MyCell: UICollectionViewCell {
    
    static let identifier = "MyCell"
    
    @IBOutlet weak var videoPreview1: UIView!
    @IBOutlet weak var videoPreview2: UIView!
    @IBOutlet weak var videoPreview3: UIView!
    @IBOutlet weak var videoPreview4: UIView!
    
    private var videoViews: [UIView] {
        return [videoPreview1, videoPreview2, videoPreview3, videoPreview4]
    }
    
    private var players = [AVPlayer]()
    private var playerLayers = [AVPlayerLayer]()
    private var currentVideoIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with videos: [Video]) {
        /// Remove any existing player layers
        for playerLayer in playerLayers {
            playerLayer.removeFromSuperlayer()
        }
        
        players.removeAll()
        playerLayers.removeAll()
        
        for (index, video) in videos.enumerated() {
            if index < videoViews.count {
                let videoView = videoViews[index]
                
                /// Remove all subviews from the videoView
                videoView.subviews.forEach { $0.removeFromSuperview() }
                
                /// Set up thumbnail image view
                let thumbnailImageView = UIImageView()
                thumbnailImageView.contentMode = .scaleAspectFill
                thumbnailImageView.clipsToBounds = true
                videoView.addSubview(thumbnailImageView)
                
                /// Set up constraints for the thumbnailImageView
                thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    thumbnailImageView.topAnchor.constraint(equalTo: videoView.topAnchor),
                    thumbnailImageView.bottomAnchor.constraint(equalTo: videoView.bottomAnchor),
                    thumbnailImageView.leadingAnchor.constraint(equalTo: videoView.leadingAnchor),
                    thumbnailImageView.trailingAnchor.constraint(equalTo: videoView.trailingAnchor)
                ])
                
                /// Load thumbnail image
                if let url = URL(string: video.thumbnail) {
                    thumbnailImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
                }
                
                /// Create and configure AVPlayer
                if let videoURL = URL(string: video.video) {
                    let player = AVPlayer(url: videoURL)
                    players.append(player)
                    
                    // Create and configure AVPlayerLayer
                    let playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = videoView.bounds
                    playerLayer.videoGravity = .resizeAspectFill
                    videoView.layer.addSublayer(playerLayer)
                    playerLayers.append(playerLayer)
                }
            }
        }
        
        playNextVideo()
    }
    
    func playNextVideo() {
        guard currentVideoIndex < players.count else { return }
        
        let player = players[currentVideoIndex]
        player.seek(to: .zero)
        player.playImmediately(atRate: 2.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            player.pause()
            self.currentVideoIndex += 1
            self.playNextVideo()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        currentVideoIndex = 0
        for player in players {
            player.pause()
        }
    }
    
}



