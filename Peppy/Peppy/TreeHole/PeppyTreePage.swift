//
//  PeppyTreePage.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import SwiftUI

// MARK: 树洞
struct PeppyTreePage: View {
    
    // 列表是否为空
    @State private var isEmpty: Bool = true
    
    // 是否显示发布视图
    @State private var showPublishView: Bool = false
    
    // 用户数据
    @StateObject var userDataManager = PeppyUserDataManager()
    
    @EnvironmentObject var loginM: PeppyLoginManager
    
    @EnvironmentObject var peppyRouter: PeppyRouteManager
    
    var body: some View {
        
        ZStack {
            if showPublishView { // 发布
                PeppyTreePublishContentView(goBack: {
                    showPublishView = false
                })
                .environmentObject(loginM)
                .environmentObject(peppyRouter)
            } else {
                if isEmpty { // 空白
                    PeppyTreeEmptyContentView(goToPublish: {
                        showPublishView = true
                    }) // 用户
                } else {
                    PeppyTreeContentView(goToPublish: {
                        showPublishView = true
                    }, userDatas: userDataManager)
                }
            }
        }
        .onAppear {
            print("树洞页")
            guard loginM.isLogin else { return }
            userDataManager.peppyGetUserMedias()
            isEmpty = userDataManager.myMediaList.isEmpty
        }
    }
}

struct PeppyTreeContentView: View {
    
    let goToPublish: () -> Void
    
    @StateObject var userDatas: PeppyUserDataManager
    
    var body: some View {
        ZStack {
            Image("tree_publish").resizable()
                .ignoresSafeArea()
            VStack {
                Spacer().frame(height: 20)
                HStack {
                    Image("tree_list_left")
                    Spacer()
                    Button(action: {
                        withAnimation(.bouncy) {
                            goToPublish() // 发布页
                        }
                    }) {
                        Image("me_publios")
                    }
                }
                
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(userDatas.myMediaList) { item in
                            PeppyShowMeidaPage(myMediaData: item)
                        }
                    }.scrollIndicators(.hidden)
                }.frame(height: peppyH * 0.74)
                Spacer()
            }.frame(width: peppyW - 35)
        }
        .onAppear {
            print("树洞主页")
            userDatas.peppyGetUserMedias()
        }
    }
}
