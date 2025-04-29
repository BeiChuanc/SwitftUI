//
//  MondoSet.swift
//  Mondo
//
//  Created by 北川 on 2025/4/28.
//

import SwiftUI

// MARK: 设置
struct MondoSet: View {
    
    @State var editName: String = ""
    
    @State var isEdit: Bool = false
    
    @State var isPrivacy: Bool = false
    
    @State var isTerms: Bool = false
    
    @State var uploadImage: UIImage?
    
    @State var isDelete: Bool = false
    
    @State var isLogout: Bool = false
    
    @ObservedObject var monLogin = MondoUserVM.shared
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ZStack {
            Image("setBg").resizable()
            VStack {
                HStack {
                    Button(action: { pageControl.backToLevel() }) { Image("backSet") }
                    Spacer()
                }
                
                if monLogin.loginIn {
                    if MondoCacheVM.MondoAvCurUser().head == "monder" {
                        Image("monder")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 78, height: 78)
                            .clipShape(RoundedRectangle(cornerRadius: 39))
                            .padding(.top, 20)
                    } else {
                        if let image = uploadImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 78, height: 78)
                                .clipShape(RoundedRectangle(cornerRadius: 39))
                                .padding(.top, 20)
                        }
                    }
                } else {
                    Image("monder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 78, height: 78)
                        .clipShape(RoundedRectangle(cornerRadius: 39))
                        .padding(.top, 20)
                }
                
                VStack(spacing: 30) {
                    Button(action: { // 修改名字
                        withAnimation(.interactiveSpring(duration: 0.5, extraBounce: 0.2)) {
                            isEdit.toggle()
                        }
                    }) { Image("btnName") }
                    
                    Button(action: { // 隐私
                        isPrivacy = true
                    }) { Image("btnPrivacy") }
                        .fullScreenCover(isPresented: $isPrivacy) {
                            NavigationStack {
                                MondoWebItem(url: URL(string: MONDOPROTOC.PRIVACY))
                                    .frame(width: MONDOSCREEN.WIDTH,
                                           height: MONDOSCREEN.HEIGHT)
                                    .toolbar {
                                        ToolbarItem(placement: .topBarLeading) {
                                            Button(action: { isPrivacy = false }) {
                                                Image("guide_back")
                                            }
                                        }
                                    }
                            }
                        }
                    
                    Button(action: { // 技术支持
                        isTerms = true
                    }) { Image("btnTerms") }
                        .fullScreenCover(isPresented: $isTerms) {
                            NavigationStack {
                                MondoWebItem(url: URL(string: MONDOPROTOC.TERMS))
                                    .frame(width: MONDOSCREEN.WIDTH,
                                           height: MONDOSCREEN.HEIGHT)
                                    .toolbar {
                                        ToolbarItem(placement: .topBarLeading) {
                                            Button(action: { isTerms = false }) {
                                                Image("guide_back")
                                            }
                                        }
                                    }
                            }
                        }
                    
                    Button(action: { // 删除账户
                        if monLogin.loginIn {
                            isDelete = true
                        } else {
                            pageControl.route(to: .LOGIN)
                        }
                    }) { Image("btnDelete") }
                        .alert(isPresented: $isDelete) {
                            Alert(
                                title: Text("Promot"),
                                message: Text("Are you sure you want to delete this account?"),
                                primaryButton: .default(Text("Confirm")) {
                                    MondoCacheVM.MondoDelCur()
                                    MondoUserVM.shared.monMyTitles.removeAll()
                                    MondoUserVM.shared.monReportList.removeAll()
                                    MondoUserVM.shared.monBlockList.removeAll()
                                    MondoRelMesVM.shared.mesListUser.removeAll()
                                    MondoBaseVM.MondoShow(type: .succeed, text: "The account will be deleted after 24 hours. If you log in within 24 hours, it will be considered a logout failure.")
                                    MondoUserVM.shared.loginIn = false
                                    pageControl.backToOriginal()
                                },
                                secondaryButton: .cancel(Text("Cancel"))
                            )
                        }
                }
                
                Spacer()
                
                Button(action: {
                    if monLogin.loginIn {
                        isLogout = true
                    } else {
                        pageControl.route(to: .LOGIN)
                    }
                }) { // 登出
                    Image("btnLogout").resizable()
                        .frame(width: MONDOSCREEN.WIDTH - 32, height: 60)
                }.padding(.bottom, 200)
                    .alert(isPresented: $isLogout) {
                        Alert(
                            title: Text("Promot"),
                            message: Text("Are you sure you want to log out?"),
                            primaryButton: .default(Text("Confirm")) {
                                MondoUserVM.shared.monReportList.removeAll()
                                MondoUserVM.shared.monBlockList.removeAll()
                                MondoUserVM.shared.loginIn = false
                                pageControl.backToOriginal()
                            },
                            secondaryButton: .cancel(Text("Cancel"))
                        )
                    }
                
            }.padding(.top, 80)
                .padding(.horizontal, 16)
                .zIndex(isEdit ? 0 : 1)
            if isEdit {
                ZStack {
                    ZStack {}
                        .frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT)
                        .background(
                            Color.clear
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.interactiveSpring(duration: 0.5, extraBounce: 0.2)) {
                                        isEdit.toggle()
                                    }
                                }
                        )
                    ZStack {
                        Image("wish_bgh").resizable().frame(height: 120)
                        VStack(spacing: 10) {
                            HStack {
                                MondoTextFielfItem(textInput: $editName,
                                                   placeholder: "Change your nickname",
                                                   interval: 15,
                                                   backgroundColor: UIColor.clear,
                                                   textColor: UIColor(hex: "#925EFF"),
                                                   placeholderColor: UIColor(hex: "#925EFF"),
                                                   bordColor: UIColor(hex: "#925EFF"),
                                                   font: UIFont(name: "PingFangSC-Medium", size: 14)!,
                                                   radius: 8)
                            }.frame(height: 40)
                                .padding(.horizontal, 16)
                            HStack {
                                Spacer()
                                Button(action: { // 修改昵称 & 返回
                                    withAnimation(.interactiveSpring(duration: 0.5, extraBounce: 0.2)) {
                                        MondoCacheVM.MondoFixDetails { mon in
                                            mon.name = editName
                                            return mon
                                        }
                                        isEdit.toggle()
                                    }
                                }) {
                                    Text("Edit")
                                        .font(.custom("PingFangSC-Regular", size: 12))
                                        .foregroundStyle(Color.white)
                                }
                                    .frame(width: 80, height: 30)
                                    .background(Color(hex: "#925EFF")).clipShape(RoundedRectangle(cornerRadius: 15))
                            }.padding(.horizontal, 16)
                        }
                    }.padding(.bottom, 200)
                        .padding(.horizontal, 16)
                }
                .transition(.asymmetric(
                    insertion: .scale,
                    removal: .opacity
                        ))
                .zIndex(1)
            }
        }.ignoresSafeArea()
            .onAppear {
                if monLogin.loginIn {
                    uploadImage = MondoUserVM.shared.MondoAvHead(uid: MondoCacheVM.MondoAvCurUser().uid)
                }
            }
    }
}
