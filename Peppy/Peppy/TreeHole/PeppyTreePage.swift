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
                    loadMedia()
                })
                .environmentObject(loginM)
                .environmentObject(peppyRouter)
            } else {
                if isEmpty { // 空白
                    PeppyTreeEmptyContentView(goToPublish: {
                        showPublishView = true
                        loadMedia()
                    })
                } else { // 用户
                    PeppyTreeContentView(goToPublish: {
                        showPublishView = true
                        loadMedia()
                    }, userDatas: userDataManager)
                    .environmentObject(peppyRouter)
                }
            }
        }
        .onAppear {
            guard loginM.isLogin else { return }
            loadMedia()
        }
    }
    
    func loadMedia() {
        userDataManager.peppyGetUserMedias()
        isEmpty = userDataManager.myMediaList.isEmpty
    }
}

struct PeppyTreeContentView: View {
    
    let goToPublish: () -> Void
    
    var currentU = PeppyUserManager.PEPPYCurrentUser()
    
    @State var isShowDelete: Bool = false
    
    @State var selectIndex: Int = 0
    
    @StateObject var userDatas: PeppyUserDataManager
    
    @EnvironmentObject var peppyRouter: PeppyRouteManager
    
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
                        ForEach(Array(userDatas.myMediaList.enumerated()), id: \.element.id) { index, item in
                            PeppyShowMeidaPage(myMediaData: item,
                                               goShowDetils: {
                                peppyRouter.navigate(to: .PLAYMEDIA(item))
                            },
                                               goDelete: {
                                isShowDelete = true
                                selectIndex = index
                            }).alert(isPresented: $isShowDelete) {
                                Alert(
                                    title: Text("Promot"),
                                    message: Text("Do you want to delete this post?"),
                                    primaryButton: .default(Text("Delete")) {
                                        PeppyUserDataManager.peppyDeletSignleMedia(
                                            mediaPath: "\(currentU.peppyId!)_publish/\(userDatas.myMediaList[selectIndex].mediaUrl!.lastPathComponent)",
                                            targetFile: selectIndex)
                                        userDatas.myMediaList.remove(at: selectIndex)
                                    },
                                    secondaryButton: .cancel(Text("Cancel"))
                                )
                            }
                        }
                    }.scrollIndicators(.hidden)
                }.frame(height: peppyH * 0.74)
                Spacer()
            }.frame(width: peppyW - 35)
        }
        .onAppear {
            userDatas.peppyGetUserMedias()
        }
    }
}
