import SwiftUI

extension View {
    
    // 隐藏返回按钮
    func hideBackButton() -> some View {
        modifier(HideBackButton())
    }
    
    func onEndedDragging(_ action: @escaping () -> Void) -> some View {
        self.gesture(
            DragGesture()
                .onEnded { _ in
                    action()
                }
        )
    }
    
    // 设置placeholder
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
