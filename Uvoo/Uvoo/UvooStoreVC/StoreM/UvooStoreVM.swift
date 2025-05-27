import Foundation
import RMStore

class UvooStoreVM {
    
    static let shared = UvooStoreVM()
    
    var UvooVIPGoods: [UvooStoreM] = []
    
    var UvooGiftGoods: [UvooStoreM] = []
    
    var uvooVIP: [UvooStoreM] = [
        UvooStoreM(Id: 1, goodId: "com.diy.clothe.vip.wk.9_99",   goodName: "(1w.)", goodPrice: "$9.99",  isVIP: true, isLimit: false),
        UvooStoreM(Id: 2, goodId: "com.diy.clothe.vip.mo.19_99",  goodName: "(1m.)", goodPrice: "$19.99", isVIP: true, isLimit: false),
        UvooStoreM(Id: 3, goodId: "com.diy.clothe.vip.qtr.29_99", goodName: "(3m.)", goodPrice: "$29.99", isVIP: true, isLimit: false),
        UvooStoreM(Id: 4, goodId: "com.diy.clothe.vip.ann.69_99", goodName: "(1y.)", goodPrice: "$69.99", isVIP: true, isLimit: false)]
    
    var uvooGift: [UvooStoreM] = [
        UvooStoreM(Id: 1, goodId: "com.diy.clothe.prem.4_99",         goodName: "1 of them",  goodPrice: "$4.99",  isVIP: false, isLimit: true),
        UvooStoreM(Id: 2, goodId: "com.diy.clothe.pri_pic.1x.4_99",   goodName: "1 of them",  goodPrice: "$4.99",  isVIP: false, isLimit: false),
        UvooStoreM(Id: 3, goodId: "com.diy.clothe.pri_pic.5x.14_99",  goodName: "5 of them",  goodPrice: "$14.99", isVIP: false, isLimit: false),
        UvooStoreM(Id: 4, goodId: "com.diy.clothe.pri_pic.10x.19_99", goodName: "10 of them", goodPrice: "$19.99", isVIP: false, isLimit: false),
        UvooStoreM(Id: 5, goodId: "com.diy.clothe.pri_pic.30x.49_99", goodName: "30 of them", goodPrice: "$49.99", isVIP: false, isLimit: false),
        UvooStoreM(Id: 6, goodId: "com.diy.clothe.pri_vid.1x.6_99",   goodName: "1 of them",  goodPrice: "$6.99",  isVIP: false, isLimit: false),
        UvooStoreM(Id: 7, goodId: "com.diy.clothe.pri_vid.5x.19_99",  goodName: "5 of them",  goodPrice: "$19.99", isVIP: false, isLimit: false),
        UvooStoreM(Id: 8, goodId: "com.diy.clothe.pri_vid.10x.29_99", goodName: "10 of them", goodPrice: "$29.99", isVIP: false, isLimit: false),
        UvooStoreM(Id: 9, goodId: "com.diy.clothe.pri_vid.30x.79_99", goodName: "30 of them", goodPrice: "$79.99", isVIP: false, isLimit: false)]
}

extension UvooStoreVM {

    func UvooGetVIP() {
        for vip in uvooVIP {
            if !UvooVIPGoods.contains(where: { $0.Id == vip.Id }), vip.isVIP {
                UvooVIPGoods.append(vip)
            }
        }
        UvooVIPGoods.sort(by: { $0.Id < $1.Id })
    }
    
    func UvooGetGift() {
        for gift in uvooGift {
            if !UvooGiftGoods.contains(where: { $0.Id == gift.Id }) {
                UvooGiftGoods.append(gift)
            }
        }
        UvooGiftGoods.sort(by: { $0.Id < $1.Id })
    }
}

extension UvooStoreVM {
    
    func UvooPurcahseVIP(vipId: String, completion: @escaping () -> Void) {
        UvooLoadVM.Uvooload()
        
        let products: Set = [vipId]
        RMStore.default().requestProducts(products) { success, invalidProductIdentifiers in
            RMStore.default().addPayment(vipId) { SKPaymentTransaction in
                UvooLoadVM.Uvoodismiss()
                if SKPaymentTransaction?.transactionState == .purchased {
                    UvooUserDefaultsUtils.UvooSaveVIP(true)
                    UvooLoadVM.UvooShow(type: .succeed)
                    completion()
                    
                } else {
                    UvooLoadVM.UvooShow(type: .failed, text: "User cancels payment")
                    completion()
                }
                
            } failure: { transaction, error in
                UvooLoadVM.UvooShow(type: .failed, text: "Invalid product information")
                completion()
            }
        } failure: { error in
            UvooLoadVM.UvooShow(type: .failed, text: "Invalid product information")
            completion()
        }
    }
    
    func UvooPurchaseGift(gId: String, completion: @escaping() -> Void) {
        UvooLoadVM.Uvooload()
        
        let products: Set = [gId]
        RMStore.default().requestProducts(products) { success, invalidProductIdentifiers in
            RMStore.default().addPayment(gId) { SKPaymentTransaction in
                UvooLoadVM.Uvoodismiss()
                if SKPaymentTransaction?.transactionState == .purchased {
                    UvooUserDefaultsUtils.UvooSaveLimit(true)
                    UvooLoadVM.UvooShow(type: .succeed)

                    completion()
                }else{
                    UvooLoadVM.UvooShow(type: .failed, text: "User cancels payment")
                }
                
            } failure: { transaction, error in
                UvooLoadVM.UvooShow(type: .failed, text: "Invalid product information")
            }
        } failure: { error in
            UvooLoadVM.UvooShow(type: .failed, text: "Invalid product information")
        }
    }
    
    func UvooRestore() {
        UvooLoadVM.Uvooload()
        RMStore.default().restoreTransactions(onSuccess: { transactions in
            UvooLoadVM.Uvoodismiss()
            if transactions?.count == 0 {
                UvooLoadVM.UvooShow(type: .failed, text: "There are currently no items to restore")
            } else {
                UvooLoadVM.UvooShow(type: .succeed, text: "Restore purchase successfully")
                
                UvooUserDefaultsUtils.UvooSaveVIP(true)
            }
        }, failure: { error in
            UvooLoadVM.UvooShow(type: .failed, text: "Cancel restore purchase")
        })
    }
}
