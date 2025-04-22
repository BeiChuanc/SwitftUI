//
//  ReButtonEffect.swift
//  Erigo
//
//  Created by 北川 on 2025/4/16.
//

import SwiftUI

/// 消除按钮点击效果
struct ReButtonEffect: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
           .foregroundStyle(.primary)
           .background(Color.clear)
    }
}
