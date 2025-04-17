import SwiftUI

// MARK: 去除按钮的点击效果
struct InvalidButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
           .foregroundStyle(.primary)
           .background(Color.clear)
    }
}

// MARK: 自定义TabBar子项
struct tabBarItem: View {
    
    let normalImage: String
    
    let selectImage: String
    
    let isSelected: Bool
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(isSelected ? selectImage : normalImage)
        }
        .frame(width: 99, height: 64)
        .buttonStyle(InvalidButton())
    }
}

// MARK: 自定义边框圆角
struct RoundedBorderStyle: ViewModifier {
    
    let cornerRadius: CGFloat
    
    let borderColor: Color
    
    let borderWidth: CGFloat
    
    func body(content: Content) -> some View {
        content
           .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
           .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                   .stroke(borderColor, lineWidth: borderWidth)
            )
    }
}

// MARK: 自定义视图修饰符，用于隐藏返回按钮
struct HideBackButton: ViewModifier {
    func body(content: Content) -> some View {
        content
           .navigationBarBackButtonHidden()
    }
}

// MARK: 旋转动画
struct RotatingLoader: View {
    @State private var isRotating = false

    var body: some View {
        Image("")
           .resizable()
           .frame(width: 50, height: 50)
           .foregroundColor(.blue)
           .rotationEffect(.degrees(isRotating ? 360 : 0))
           .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isRotating)
           .onAppear {
                isRotating = true
            }
    }
}

// MARK: 点动画
struct DotLoader: View {
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                   .frame(width: 12, height: 12)
                   .foregroundColor(.white)
                   .scaleEffect(isAnimating ? 1.2 : 0.8)
                   .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(Double(index) * 0.2), value: isAnimating)
            }
        }
       .onAppear {
            isAnimating = true
        }
    }
}
