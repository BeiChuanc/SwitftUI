import SwiftUI

// 个人中心
struct PeppySetPage: View {
    var body: some View {
        PeppySetContentView()
    }
}

struct PeppySetContentView: View {
    
    @State var showPrivacy: Bool = false
    
    @State var showTerms: Bool = false
    
    @State var showLogout: Bool = false
    
    @State var showDelete: Bool = false
    
    @State var unlockedAnimals: [Int] = []
    
    @State var userCurrent = PeppyLoginMould()
    
    @EnvironmentObject var loginM: PeppyLoginManager
    
    @EnvironmentObject var peppyRouter: PeppyRouteManager
    
    var body: some View {
        ZStack {
            Image("centerNg")
                .resizable()
                .ignoresSafeArea()
            VStack {
                PeppyUserHeadContentView(head: loginM.isLogin ? userCurrent.head ?? "" : "head_1",
                                         headBgColor: loginM.isLogin ? userCurrent.headColor ?? "" : "#FFFFFF",
                                         headFrame: 72.0)
                .onTapGesture {
                    if loginM.isLogin {
                        peppyRouter.navigate(to: .UPLOADHEAD)
                    } else {
                        peppyRouter.navigate(to: .LOGIN)
                    }
                }
                .padding(.leading, 10)
                
                Text(loginM.isLogin ? userCurrent.kickName ?? "" : "Guest")
                    .font(.custom("Marker Felt", size: 20))
                    .foregroundStyle(.white)
                
                VStack {
                    Text("YOU HAVE UNLOCKED \(unlockedAnimals.count) ELECTRONIC PETS")
                        .frame(width: 200)
                        .font(.custom("Marker Felt", size: 20))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }.padding(.top, 30)
                
                if loginM.isLogin {
                    withAnimation(.easeInOut(duration: 10)) {
                        HStack (spacing: 20) { // 解锁聊天个数
                            ForEach(unlockedAnimals, id: \.self) { head in
                                Image("An_\(head)").resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                    }
                }
                
                VStack(spacing: 18) {
                    Button(action: { // 隐私政策
                        showPrivacy = true
                    }) {
                        Image("btnPrivacy")
                    }.sheet(isPresented: $showPrivacy) {
                        PeppyWebViewPage(url: URL(string: PEPPYPROTOCOL.PEPPYPRIVACY)!)
                            .navigationBarTitleDisplayMode(.automatic)
                    }
                    
                    Button(action: { // 技术支持
                        showTerms = true
                    }) {
                        Image("btnTerms")
                    }.sheet(isPresented: $showTerms) {
                        PeppyWebViewPage(url: URL(string: PEPPYPROTOCOL.PEPPYTERMS)!)
                            .navigationBarTitleDisplayMode(.automatic)
                    }
                    
                    Button(action: { // 登出
                        if loginM.isLogin {
                            showLogout = true
                            return
                        }
                        peppyRouter.navigate(to: .LOGIN)
                    }) {
                        Image("btnLogOut")
                    }.alert(isPresented: $showLogout) {
                        Alert(
                            title: Text("Promot"),
                            message: Text("Are you sure you want to log out?"),
                            primaryButton: .default(Text("Confirm")) {
                                unlockedAnimals.removeAll()
                                loginM.isLogin = false
                            },
                            secondaryButton: .cancel(Text("Cancel"))
                        )
                    }
                    
                    Button(action: { // 删除账号
                        if loginM.isLogin {
                            showDelete = true
                            return
                        }
                        peppyRouter.navigate(to: .LOGIN)
                    }) {
                        Image("btnDeleteAc")
                    }.alert(isPresented: $showDelete) {
                        Alert(
                            title: Text("Promot"),
                            message: Text("Are you sure you want to delete this account?"),
                            primaryButton: .default(Text("Confirm")) {
                                unlockedAnimals.removeAll()
                                PeppyUserManager.PEPPYDeleteUer()
                                PeppyUserDataManager.shared.blockAnimals.removeAll()
                                PeppyUserDataManager.shared.myMediaList.removeAll()
                                PeppyLoadManager.peppyProgressShow(type: .succeed, text: "The account will be deleted after 24 hours. If you log in within 24 hours, it will be considered a logout failure.")
                                loginM.isLogin = false
                            },
                            secondaryButton: .cancel(Text("Cancel"))
                        )
                    }
                }.padding(.top, 60)
                
                Spacer()
            }.frame(width: peppyW)
                .padding(.top, 20)
                .onAppear {
                    userCurrent = PeppyUserManager.PEPPYCurrentUser()
                }
        }
        .onAppear {
            if loginM.isLogin {
                unlockedAnimals = PeppyChatDataManager.shared.peppyGetMessageList()
            }
        }
    }
}

// MARK: 用户头像
struct PeppyUserHeadContentView: View {
    
    var head: String
    
    var headBgColor: String
    
    var headFrame: CGFloat
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("UserHead_bg")
                .resizable()
                .frame(width: headFrame,
                       height: headFrame)
            ZStack{}
                .frame(width: headFrame * 0.83,
                       height: headFrame * 0.83)
                .background(Color(hex: headBgColor)) // 用户头像底色
                .border(.black, width: 1)
            Image(head) // 用户头像
                .resizable()
                .padding(.all, 2.0)
                .frame(width: headFrame * 0.83,
                       height: headFrame * 0.83)
        }
        .frame(width: headFrame * 0.83,
               height: headFrame * 0.83)
        .padding(.trailing, 10)
    }
}
