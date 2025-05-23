import Foundation
import UIKit

extension String {
    
    func distance(str: String) -> Int {
        guard let range = self.range(of: str) else { return -1 }
        return distance(from: self.startIndex, to: range.lowerBound)
    }
}

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let cleanHex = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        
        guard cleanHex.count == 6 else {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }
        
        var rgb: UInt64 = 0
        Scanner(string: cleanHex).scanHexInt64(&rgb)
        
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255,
            blue: CGFloat(rgb & 0x0000FF) / 255,
            alpha: alpha
        )
    }
}

extension UITextField {
    
    func leftPadding(_ amount: CGFloat) {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.height))
        leftViewMode = .always
    }

    func rightPadding(_ amount: CGFloat) {
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.height))
        rightViewMode = .always
    }

    func placeHolderColor(_ color: UIColor) {
        guard let placeholder = placeholder else { return }
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: color,
                .font: font ?? .systemFont(ofSize: 14)
            ]
        )
    }
}

extension UILabel {
    func setGradientText(colors: [UIColor]) {
        guard let _ = self.text else { return }
        
        let size = self.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = colors.map { $0.cgColor } as CFArray
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: nil) else { return }
        
        context.drawLinearGradient(
            gradient,
            start: CGPoint(x: 0, y: 0),
            end: CGPoint(x: size.width, y: 0),
            options: []
        )
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        
        self.textColor = UIColor(patternImage: image)
    }
}

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

protocol NavigationBarAppearance {
    var shouldHideBottomBarWhenPushed: Bool { get }
}

class Navigationcontroller: UINavigationController {
    
    override func pushViewController(_ vc: UIViewController, animated: Bool) {
        if children.count > 0 {
            if let vcAppearance = vc as? NavigationBarAppearance {
                vc.hidesBottomBarWhenPushed = vcAppearance.shouldHideBottomBarWhenPushed
            } else {
                vc.hidesBottomBarWhenPushed = true
            }
        }
        super.pushViewController(vc, animated: animated)
    }
}
