//
//  MondoRegister.swift
//  Mondo
//
//  Created by 北川 on 2025/4/28.
//

import SwiftUI

// MARK: 注册
struct MondoRegister: View {
    
    @State var inputAcc: String = ""
    
    @FocusState var isAcc: Bool
    
    @State var inputPwd: String = ""
    
    @FocusState var isPwd: Bool
    
    @State var confrim: String = ""
    
    @FocusState var isConfirm: Bool
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ZStack {
            Image("register_bg").resizable()
            VStack {
                HStack {
                    Spacer()
                    Button(action: { pageControl.backToLevel() }) { Image("btnClose") }
                }.padding(.top, 80)
                Spacer()
                VStack(spacing: 10) { // 表单
                    MondoTextFielfItem(textInput: $inputAcc,
                                       placeholder: "Input username",
                                       interval: 15,
                                       backgroundColor: UIColor(hex: "#825EEE"),
                                       textColor: UIColor.white,
                                       placeholderColor: UIColor(hex: "#FFFFFF", alpha: 0.4),
                                       font: UIFont(name: "PingFangSC-Medium", size: 14)!,
                                       radius: 15)
                    .frame(height: 50)
                    .focused($isAcc)
                    MondoTextFielfItem(textInput: $inputPwd,
                                       placeholder: "Input password",
                                       interval: 15,
                                       backgroundColor: UIColor(hex: "#825EEE"),
                                       textColor: UIColor.white,
                                       placeholderColor: UIColor(hex: "#FFFFFF", alpha: 0.4),
                                       font: UIFont(name: "PingFangSC-Medium", size: 14)!,
                                       radius: 15)
                    .frame(height: 50)
                    .focused($isPwd)
                    MondoTextFielfItem(textInput: $confrim,
                                       placeholder: "Confirm password",
                                       interval: 15,
                                       backgroundColor: UIColor(hex: "#825EEE"),
                                       textColor: UIColor.white,
                                       placeholderColor: UIColor(hex: "#FFFFFF", alpha: 0.4),
                                       font: UIFont(name: "PingFangSC-Medium", size: 14)!,
                                       radius: 15)
                    .frame(height: 50)
                    .focused($isConfirm)
                }
                Button(action: { // 注册
                    guard !inputAcc.isEmpty else { isAcc = true
                        return
                    }
                    
                    guard !inputPwd.isEmpty else { isPwd = true
                        return
                    }
                    
                    guard confrim == inputPwd else { // 密码不匹配
                        MondoBaseVM.MondoShow(type: .failed, text: "Passwords do not match!")
                        return
                    }
                    
                    MondoUserVM.shared.MondoRegisterAcc(email: inputAcc, pwd: inputPwd) {
                        MondoUserVM.shared.loginIn = true
                        MondoBaseVM.MondoLoading {
                            pageControl.backToOriginal()
                        }
                    }
                    
                }) {
                    Image("btnRegister").resizable()
                        .frame(width: MONDOSCREEN.WIDTH - 32, height: 50)
                }.padding(.top, 20)
                VStack {
                    CombinedLinkTextItem(placeholderOne: "Terms of Service",
                                         placeholderTwo: "Privacy Policy",
                                         tarText: "By Continuing you agree with Terms of Service & Privacy Policy",
                                         customFont: .custom("", size: 12),
                                         tartColor: Color(hex: "#999999"),
                                         higlitColor: Color(hex: "#666666"),
                                         firstLink: URL(string: MONDOPROTOC.TERMS)!,
                                         secondLink: URL(string: MONDOPROTOC.PRIVACY)!)
                    .padding(.bottom, 60)
                    .padding(.top, 72)
                }
            }.padding(.horizontal, 16)
        }.ignoresSafeArea()
    }
}
