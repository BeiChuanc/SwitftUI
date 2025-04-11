//
//  View.swift
//  Peppy
//
//  Created by 北川 on 2025/4/11.
//

import SwiftUI

// 扩展 View 以方便使用自定义修饰符
extension View {
    func hideBackButton() -> some View {
        modifier(HideBackButton())
    }
}

extension View {
    func onEndedDragging(_ action: @escaping () -> Void) -> some View {
        self.gesture(
            DragGesture()
                .onEnded { _ in
                    action()
                }
        )
    }
}
