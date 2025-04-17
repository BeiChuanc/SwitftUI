import SwiftUI

// MARK: 选择头像
struct PeppySelectPage: View {
    
    @State var selectIndex: Int = 0
    
    @State var selectHead: String = ""
    
    @State var seletColor: String = ""
    
    @EnvironmentObject var peppyRouter: PeppyRouteManager
    
    var headBg: [PeppyColorType] = [.ONE, .TWO, .THREE, .FOUR]
    
    var headList: [String] = ["head_1", "head_2", "head_3", "head_4", "head_5"]
    
    var body: some View {
        ZStack {
            Image("selectHeadBg").resizable()
            VStack {
                Spacer().frame(height: 50)
                HStack {
                    Button(action: {
                        peppyRouter.pop()
                    }) {
                        Image("btnBac").frame(width: 24, height: 24)
                    }
                    Spacer()
                }.frame(height: 25)
                    .padding(.horizontal, 20)
                
                Text("Please choose your avatar")
                    .font(.custom("PingFangTC-Semibold", size: 20))
                    .foregroundStyle(.white)
                    .padding(.top, 30)
                
                PeppyUserHeadContentView(head: selectHead,
                                         headBgColor: seletColor,
                                         headFrame: 96.0)
                .padding(.top, 20)
                
                ZStack {
                    Image("row_bg").resizable()
                    HStack {
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: [GridItem(.adaptive(minimum: 80, maximum: 80 * 2))], spacing: 20) {
                                    ForEach(Array(headList.enumerated()), id: \.offset) { index, item in
                                        selectHeadItem(head: item, isSelect: index == selectIndex) {
                                            selectHead = item
                                            selectIndex = index
                                        }
                                    }
                                }.padding(.horizontal, (peppyW - 80) / 2)
                            }
                        }
                    }
                }.frame(height: 90)
                    .padding(.top, 20)
                
                Text("Please select your background color")
                    .font(.custom("PingFangTC-Semibold", size: 20))
                    .foregroundStyle(.white)
                    .padding(.top, 30)
                
                let columns = [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]
                
                let (column1, column2) = splitColors(headBg)
                
                LazyVGrid(columns: columns, spacing: 25) {
                    // 第一列
                    ForEach(column1.indices, id: \.self) { index in
                        selectHeadBg(bgColor: column1[index].rawValue) {
                            seletColor = column1[index].rawValue
                        }
                    }
                    
                    ForEach(column2.indices, id: \.self) { index in
                        selectHeadBg(bgColor: column2[index].rawValue) {
                            seletColor = column2[index].rawValue
                        }
                    }
                }.padding(.horizontal, 80)
                
                Button(action: { // 完成上传头像
                    PeppyUserManager.PEPPYUpdateUserDetails { pey in
                        pey.head = selectHead
                        pey.headColor = seletColor
                        return pey
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5 , execute: {
                        peppyRouter.pop()
                    })
                }) {
                    Image("registerFinish").resizable()
                        .frame(width: peppyW - 80, height: 48)
                }.padding(.top, 30)
                
                Spacer()
            }
        }.ignoresSafeArea()
            .onAppear {
                selectHead = headList[0]
                seletColor = PeppyColorType.ONE.rawValue
            }
    }
    
    func splitColors(_ items: [PeppyColorType]) -> ([PeppyColorType], [PeppyColorType]) {
        var column1: [PeppyColorType] = []
        var column2: [PeppyColorType] = []
        
        for (index, item) in items.enumerated() {
            if index % 2 == 0 {
                column1.append(item)
            } else {
                column2.append(item)
            }
        }
        
        return (column1, column2)
    }
}

// MARK: 选择头像Item
struct selectHeadItem: View {
    
    var head: String
    
    var isSelect: Bool
    
    var select: () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(head).resizable()
                .frame(width: 60, height: 60)
        }
        .background(isSelect ? Color(hex: "#FFFFFF", alpha: 0.2) : Color.clear)
        .modifier(RoundedBorderStyle(cornerRadius: 5, borderColor: isSelect ? Color.black : Color.clear, borderWidth: 2))
        .onTapGesture {
            select()
        }
    }
}

// MARK: 选择头像背景
struct selectHeadBg: View {
    
    var bgColor: String
    
    var selectBg: () -> Void
    
    var body: some View {
        ZStack {}
            .frame(width: 84, height: 84)
            .background(Color(hex: bgColor))
            .modifier(RoundedBorderStyle(cornerRadius: 1, borderColor: Color.black, borderWidth: 2))
            .onTapGesture {
                selectBg()
            }
    }
}
