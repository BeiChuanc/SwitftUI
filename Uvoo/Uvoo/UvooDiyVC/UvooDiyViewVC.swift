import Foundation
import UIKit
import FSPagerView
import SnapKit

class UvooDiyViewVC: UvooHeadVC {
    
    @IBOutlet weak var btndesign: UIButton!
    
    var learnCard = FSPagerView()
    
    let width = UvooScreen.width * 0.65
    
    let height = (UvooScreen.width * 0.65) * (424.0 / 270.0)
    
    let topOffset = UvooScreen.height * 0.25
    
    let bottomOffset = UvooScreen.height * 0.12
    
    let learnCardName: [String] = ["diy_wea", "diy_hat", "diy_tshirt", "diy_colthe"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetLearnView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func UvooSetLearnView() {
        
        view.addSubview(learnCard)
        learnCard.translatesAutoresizingMaskIntoConstraints = false
        
        learnCard.delegate = self
        learnCard.dataSource = self
        learnCard.scrollDirection = .horizontal
        learnCard.transformer = FSPagerViewTransformer(type: .linear)
        learnCard.itemSize = CGSize(width: width, height: height)
        learnCard.register(diyShowCell.self, forCellWithReuseIdentifier: "diyShowCell")
        
        learnCard.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaInsets.top).offset(topOffset)
            make.bottom.equalTo(view.safeAreaInsets.bottom).offset(-bottomOffset)
        }
    }
    
    @IBAction func btnOntap(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            UvooRouteUtils.UvooSetView()
            break
        case 1:
            UvooRouteUtils.UvooGenDisplay()
            break
        default:
            break
        }
    }
}

extension UvooDiyViewVC: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 4
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        UvooRouteUtils.UvooShowDesign(select: index)
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "diyShowCell", at: index) as! diyShowCell
        cell.diySetImage(image: learnCardName[index])
        cell.contentView.layer.shadowColor = UIColor.clear.cgColor
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        return cell
    }
}

class diyShowCell: FSPagerViewCell {
    
    var diyImageView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        diyImageView.image = nil
    }
    
    func diySetView() {
        diyImageView.contentMode = .scaleToFill
        self.insertSubview(diyImageView, at: 2)
        
        diyImageView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
    
    func diySetImage(image: String) {
        diyImageView.image = UIImage(named: image)
        diySetView()
    }
}
