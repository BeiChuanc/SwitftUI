import UIKit
import SnapKit
import AVFoundation
import CommonCrypto

class UvooMePlayVideoVC: UvooTopVC {

    @IBOutlet weak var player_container: UIView!
    
    @IBOutlet weak var playerBack: UIButton!
    
    @IBOutlet weak var playerreport: UIButton!
    
    @IBOutlet weak var headUser: UIImageView!
    
    @IBOutlet weak var nameUser: UILabel!
    
    @IBOutlet weak var likePlayer: UIButton!
    
    @IBOutlet weak var liketText: UILabel!
    
    @IBOutlet weak var comPlayer: UIButton!
    
    @IBOutlet weak var comText: UILabel!
    
    @IBOutlet weak var titleTetx: UILabel!
    
    @IBOutlet weak var playBt: UIButton!
    
    @IBOutlet weak var contentText: UITextView!
    
    @IBOutlet weak var loadActivity: UIActivityIndicatorView! {
        didSet {
            loadActivity.hidesWhenStopped = true
        }
    }
    
    var isMe: Bool = false
    
    var titleModel: UvooPublishM?
    
    var player: AVPlayer?
    
    var playerLayer: AVPlayerLayer?
    
    var playerItemObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetVideoView()
        UvooLoadTitleData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        playerLayer!.frame = player_container.bounds
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCom), name: Notification.Name(UvooNotiName.com), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func UvooSetVideoView() {
        headUser.layer.cornerRadius = headUser.frame.height / 2
        headUser.layer.masksToBounds = true
        playerBack.addTarget(self, action: #selector(previous), for: .touchUpInside)
        likePlayer.addTarget(self, action: #selector(likeOnTap), for: .touchUpInside)
        comPlayer.addTarget(self, action: #selector(comOnTap), for: .touchUpInside)
        playerreport.addTarget(self, action: #selector(reportOnTap), for: .touchUpInside)
        playBt.addTarget(self, action: #selector(playOnTap), for: .touchUpInside)
    }
    
    func UvooLoadTitleData() {
        guard let titleModel = self.titleModel else { return }
        let land = UvooLoginVM.shared.isLand
        nameUser.text = titleModel.name
        
        comText.text = "\(PostManager.shared.UvooGetPost(by: titleModel.tId)!.comment.count)"
        titleTetx.text = titleModel.title
        contentText.text = titleModel.content
        if titleModel.bId == 1006 {
            headUser.image = UIImage(named: "officeHead")
        } else {
            if isMe {
                let meData = UvooUserDefaultsUtils.UvooGetUserInfo()
                guard let imageData = meData?.head else {
                    headUser.image = UIImage(named: "UvooHead")
                    return }
                let image = UIImage(data: imageData)
                headUser.image = image
            } else {
                headUser.image = UIImage(named: titleModel.head)
            }
        }
        
        if land {
            let meData = UvooUserDefaultsUtils.UvooGetUserInfo()
            if meData!.like.contains(where: { $0.tId == titleModel.tId }) {
                likePlayer.isSelected = true
                liketText.text = "\(titleModel.likes + 1)"
            } else {
                liketText.text = "\(titleModel.likes)"
            }
        } else {
            liketText.text = "\(titleModel.likes)"
        }
        
        playVideo(with: URL(string: titleModel.imags[0])!)
        playerreport.isHidden = titleModel.bId == 1006 || isMe
    }
    
    func playVideo(with url: URL) {
        loadActivity.startAnimating()
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
    
        playerItemObserver = playerItem.observe(\.status, options: [.new]) { [weak self] (item, _) in
            DispatchQueue.main.async {
                if item.status == .readyToPlay {
                    self?.loadActivity.stopAnimating()
                    self?.playBt.isHidden = false
                } else if item.status == .failed {
                    self?.loadActivity.stopAnimating()
                }
            }
        }
        
        observerVideoEnd(for: playerItem)
        
        playerLayer?.removeFromSuperlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.frame = player_container.bounds
        playerLayer!.videoGravity = .resizeAspect
        player_container.layer.addSublayer(playerLayer!)
        
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
    
    @objc func likeOnTap(_ sender: UIButton) {
        guard let title = titleModel else { return }
        let land = UvooLoginVM.shared.isLand
        if land {
            sender.isSelected = !sender.isSelected
            UvooUserDefaultsUtils.UvooUpdateUserInfo { model in
                if model.like.contains(where: { $0.tId == title.tId }) {
                    model.like.removeAll(where: { $0.tId == title.tId })
                    liketText.text = "\(title.likes - 1)"
                } else {
                    model.like.append(title)
                    liketText.text = "\(title.likes + 1)"
                }
            }
        } else {
            UvooRouteUtils.UvooLogin()
        }
    }
    
    @objc func reportOnTap() {
        guard let title = titleModel else { return }
        UIAlertController.report(Id: title.tId) {
            
        }
    }
    
    @objc func reloadCom() {
        guard let title = titleModel else { return }
        comText.text = "\(PostManager.shared.UvooGetPost(by: title.tId)!.comment.count)"
    }
    
    @objc func comOnTap() {
        guard let titleModel = self.titleModel else {
            return }
        UvooRouteUtils.UvooShowComment(title: titleModel)
    }
    
    @objc func playOnTap() {
        if let layer = player {
            if layer.timeControlStatus == .playing {
                layer.pause()
                playBt.isSelected = true
            } else {
                layer.play()
                playBt.isSelected = false
            }
        }
    }
}
