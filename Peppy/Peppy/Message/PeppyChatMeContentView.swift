//
//  PeppyChatMeContentView.swift
//  Peppy
//
//  Created by 北川 on 2025/4/14.
//

import SwiftUI

// MARK: 聊天 - 用户
struct PeppyChatMeContentView: View {
    
    var user: PeppyLoginMould
    
    var body: some View {
        VStack(alignment: .trailing) {
            Image(user.head!)
        }
    }
}
