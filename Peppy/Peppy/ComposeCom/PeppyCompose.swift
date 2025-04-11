//
//  PeppyCompose.swift
//  所有自定义样式
//
//  Created by 北川 on 2025/4/10.
//

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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
