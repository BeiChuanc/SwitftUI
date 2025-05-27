import UIKit
import AVFoundation

class BleoTitleDetailsVideoViewC: BleoCommonViewC, Routable {
    
    typealias Model = BleoTitleM
    
    var videoModel: BleoTitleM?
    
    var player: AVPlayer?
    
    var playerLayer: AVPlayerLayer?
    
    var playerItemObserver: NSKeyValueObservation?
    
    @IBOutlet weak var videoBack: UIButton!
    
    @IBOutlet weak var videoreport: UIButton!
    
    @IBOutlet weak var userHead: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var viewUsers: UIView!
    
    @IBOutlet weak var viewCount: UILabel!
    
    @IBOutlet weak var likeCount: UILabel!
    
    @IBOutlet weak var videoTextView: UITextView!
    
    @IBOutlet weak var videoContainPlay: UIView!
    
    @IBOutlet weak var videoPlay: UIButton!
    
    @IBOutlet weak var videoLoading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BleoSetVideoView()
        BleoLoadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "#47B394").cgColor, UIColor(hex: "#8AE466").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 170, height: 42)
        viewUsers.layer.insertSublayer(gradientLayer, at: 0)
        viewUsers.layer.cornerRadius = 21
        viewUsers.layer.masksToBounds = true
        viewUsers.alpha = 0.65
        
        playerLayer!.frame = videoContainPlay.bounds
    }
    
    func BleoSetVideoView() {
        userHead.layer.cornerRadius = userHead.frame.height / 2
        userHead.layer.masksToBounds = true
        videoBack.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        videoreport.addTarget(self, action: #selector(reportTapped), for: .touchUpInside)
        videoPlay.addTarget(self, action: #selector(playSwitch), for: .touchUpInside)
        videoLoading.hidesWhenStopped = true
    }
    
    func configure(with model: BleoTitleM) {
        videoModel = model
    }
    
    func BleoLoadData() {
        guard let videoModel = self.videoModel else { return }
        userHead.image = UIImage(named: videoModel.head)
        userName.text = videoModel.name
        likeCount.text = "\(Int.random(in: 200...999))"
        viewCount.text = "\(Int.random(in: 200...999))"
        playVideo(with: URL(string: videoModel.tUrl)!)
        videoTextView.text = videoModel.content
        if isLogin {
            
        }
    }
    
    func playVideo(with url: URL) {
        guard let videoModel = self.videoModel else { return }
        videoLoading.startAnimating()
        var playerItem = AVPlayerItem(url: url)
//        if isMe {
//            let meData = UvooUserDefaultsUtils.UvooGetUserInfo()
//            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let mediaURL = documentsURL.appendingPathComponent("Uvoo\(meData!.uId)/\(videoModel.imags[0].components(separatedBy: "/").last!)")
//            playerItem = AVPlayerItem(url: mediaURL)
//        }
        
        player = AVPlayer(playerItem: playerItem)
    
        playerItemObserver = playerItem.observe(\.status, options: [.new]) { [weak self] (item, _) in
            DispatchQueue.main.async {
                if item.status == .readyToPlay {
                    self?.videoLoading.stopAnimating()
                    self?.videoPlay.isHidden = false
                } else if item.status == .failed {
                    self?.videoLoading.stopAnimating()
                }
            }
        }
        
        observerVideoEnd(for: playerItem)
        
        playerLayer?.removeFromSuperlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.frame = videoContainPlay.bounds
        playerLayer!.videoGravity = .resizeAspectFill
        videoContainPlay.layer.addSublayer(playerLayer!)
        
        player?.play()
        player?.isMuted = false
    }
    
    func observerVideoEnd(for playerItem: AVPlayerItem) {
        NotificationCenter.default.addObserver(self, selector: #selector(videoEndPlay(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    @objc func videoEndPlay(_ notification: Notification) {
        guard let playerItem = notification.object as? AVPlayerItem, playerItem == self.player?.currentItem else {
            return
        }
        self.player?.seek(to: CMTime.zero)
        self.player?.play()
    }
    
    @objc func playSwitch() {
        if let layer = player {
            if layer.timeControlStatus == .playing {
                layer.pause()
                videoPlay.isSelected = true
            } else {
                layer.play()
                videoPlay.isSelected = false
            }
        }
    }
    
    @objc func backTapped() {
        BleoPageRoute.backToLevel()
    }
    
    @objc func reportTapped() {
        guard let model = videoModel else { return }
        UIAlertController.report(Id: model.tId) {
            BleoTransData.shared.BleoGetTitles()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                backTapped()
            }
        }
    }
}
