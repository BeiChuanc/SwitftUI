import Foundation
import UIKit

struct UvooLibM: Codable {
    
    var Id: Int? = 0
    
    var designId: Int
    
    var genId: Int? = 0
    
    var imageData: Data?
    
    var image: UIImage? {
        guard let imageData = imageData else { return nil }
        return UIImage(data: imageData)
    }
    
    mutating func setImage(_ image: UIImage?) {
        imageData = image?.pngData()
    }
}
