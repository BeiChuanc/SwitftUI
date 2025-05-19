import Foundation
import UIKit
import SnapKit

class UvoodiyShowScienceVC: UvooTopVC {
    
    var selectShow: Int = 0
    
    let showImageName: [String] = ["diy_climb_show", "diy_ski_show", "diy_cy_show"]
    
    let topTextName: [String] = ["top_climb", "top_ski", "top_cy"]
    
    
    var showButtonBack = UIButton(type: .custom)
    
    var topShowText = UIImageView()
    
    var showImage = UIImageView()
    
    var imageShowScroll = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        UvooScienceSetView()
    }
    
    func UvooScienceSetView() {
        view.addSubview(imageShowScroll)
        imageShowScroll.addSubview(showImage)
        view.addSubview(showButtonBack)
        view.addSubview(topShowText)
        
        showButtonBack.setImage(UIImage(named: "btnBack"), for: .normal)
        showButtonBack.addTarget(self, action: #selector(previous), for: .touchUpInside)
        
        showImage.image   = UIImage(named: showImageName[selectShow])
        showImage.contentMode = .scaleToFill
        topShowText.image = UIImage(named: topTextName[selectShow])
        imageShowScroll.showsVerticalScrollIndicator = false
        
        showButtonBack.translatesAutoresizingMaskIntoConstraints  = false
        topShowText.translatesAutoresizingMaskIntoConstraints     = false
        showImage.translatesAutoresizingMaskIntoConstraints       = false
        imageShowScroll.translatesAutoresizingMaskIntoConstraints = false
        
        showButtonBack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets.top).offset(45)
            make.leading.equalToSuperview().offset(16)
        }
        
        topShowText.snp.makeConstraints { make in
            make.centerY.equalTo(showButtonBack)
            make.centerX.equalToSuperview()
        }
        
        imageShowScroll.snp.makeConstraints { make in
            make.width.equalTo(UvooScreen.width)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(-45)
            make.bottom.equalToSuperview().offset(40)
        }
        
        showImage.snp.makeConstraints { make in
            make.width.equalTo(UvooScreen.width)
            make.edges.equalToSuperview()
        }
        
    }
}
