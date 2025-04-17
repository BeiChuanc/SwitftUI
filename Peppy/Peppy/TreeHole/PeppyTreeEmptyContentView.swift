import SwiftUI

// MARK: 空数据页面
struct PeppyTreeEmptyContentView: View {
    
    let goToPublish: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("tree_empty").resizable()
                .ignoresSafeArea()
            
            Button(action: {
                withAnimation(.bouncy) {
                    goToPublish()
                }
            }) {
                Image("btnPublish")
                    .resizable()
                    .frame(width: 160, height: 42)
            }.padding(.bottom, 200)
        }
    }
}
