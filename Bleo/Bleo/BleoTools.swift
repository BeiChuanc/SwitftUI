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

extension JSONDecoder {
    
    func decodeFromFile<T: Decodable>(at path: URL) throws -> T {
        let data = try Data(contentsOf: path)
        
        let jsonString = String(data: data, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "<![CDATA[", with: "")
            .replacingOccurrences(of: "]]>", with: "")
        
        guard let processedData = jsonString?.data(using: .utf8) else {
            throw NSError(domain: "JSONProcessingError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Failed to process JSON string"])
        }
        
        return try decode(T.self, from: processedData)
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

extension UIAlertController {
    
    static func show(message: String, call: @escaping () -> Void) {
        var showAlter: UIAlertController!
        showAlter = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlter.addAction(ok)
        BleoPageRoute.currentVC?.present(showAlter, animated: true, completion: nil)
    }
    
    static func logout(call: @escaping() -> Void) {
        let alert = UIAlertController(title: "Prompt", message: "Are you sure you want to log out of the current account?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { Action in
            call()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
        BleoPageRoute.currentVC?.present(alert, animated: true, completion: nil)
    }
    
    static func delete(call: @escaping() -> Void) {
        let alert = UIAlertController(title: "Prompt", message: "Are you sure you want to delete the current account?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Delete", style: .default, handler: { Action in
            call()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
        BleoPageRoute.currentVC?.present(alert, animated: true, completion: nil)
    }
    
    static func deleteT(call: @escaping() -> Void) {
        let alert = UIAlertController(title: "Prompt", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Delete", style: .default, handler: { Action in
            call()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
        BleoPageRoute.currentVC?.present(alert, animated: true, completion: nil)
    }
    
    static func report(Id: Int, call: @escaping () -> Void) {
        var reportAlter: UIAlertController!
        reportAlter = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
        
        let reportCommon : (UIAlertAction) -> Void = { action in
            if Id < 11 && Id > 0 {
                if !BleoTransData.shared.reportTitleList.contains(Id) {
                    BleoTransData.shared.reportTitleList.append(Id)
                }
            }
            if Id > 99 && Id < 104 {
                if !BleoTransData.shared.blockUserList.contains(Id) {
                    BleoTransData.shared.blockUserList.append(Id)
                }
            }
            call()
        }
        
        let report1 = UIAlertAction(title: NSLocalizedString("Report Sexually Explicit Material", comment: ""), style: .default,handler: reportCommon)
        let report2 = UIAlertAction(title: NSLocalizedString("Report spam", comment: ""), style: .default,handler: reportCommon)
        let report3 = UIAlertAction(title: NSLocalizedString("Report something else", comment: ""), style: .default,handler: reportCommon)
        let report4 = UIAlertAction(title: NSLocalizedString("Block", comment: ""), style: .default,handler: reportCommon)
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.cancel,handler: nil)
        reportAlter.addAction(report1)
        reportAlter.addAction(report2)
        reportAlter.addAction(report3)
        reportAlter.addAction(report4)
        reportAlter.addAction(cancel)
        reportAlter.modalPresentationStyle = .overFullScreen
        BleoPageRoute.currentVC?.present(reportAlter, animated: true, completion: nil)
    }
}
