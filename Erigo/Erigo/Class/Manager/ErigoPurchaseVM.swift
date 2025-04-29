//
//  ErigoPurchase.swift
//  Erigo
//
//  Created by 北川 on 2025/4/25.
//

import Foundation
import RMStore

// MARK: 商品
class ErigoPurchaseVM {
    
    static let shared = ErigoPurchaseVM()
    
    var storeJsonFile: String? {
        return Bundle.main.path(forResource: "ErigoStore", ofType: "json")
    }
    
    var vipStoreList: [ErigoStoreM] = []
    
    var giftStoreList: [ErigoStoreM] = []
    
}

// MARK: 商品列表
extension ErigoPurchaseVM {

    /// 获取VIP商品
    func ErigoAvVIP() {
        guard let storeJsonFile = self.storeJsonFile else { return }
        let storeData = try? Data(contentsOf: URL(filePath: storeJsonFile))
        if let storeList = ErigoLoginVM.decode(data: storeData!, to: [ErigoStoreM].self) {
            for store in storeList {
                if !vipStoreList.contains(where: { $0.Id == store.Id }), store.isVIP! {
                    vipStoreList.append(store)
                }
            }
        }
        vipStoreList.sort(by: { $0.Id! < $1.Id! })
    }
    
    /// 获取礼物商品
    func ErigoAvGift() {
        guard let storeJsonFile = self.storeJsonFile else { return }
        let storeData = try? Data(contentsOf: URL(filePath: storeJsonFile))
        if let storeList = ErigoLoginVM.decode(data: storeData!, to: [ErigoStoreM].self) {
            for store in storeList {
                if !giftStoreList.contains(where: { $0.Id == store.Id }), !store.isVIP! {
                    giftStoreList.append(store)
                }
            }
            
        }
        giftStoreList.sort(by: { $0.Id! < $1.Id! })
    }
}

// MARK: 商品订阅 & 购买
extension ErigoPurchaseVM {
    
    /// 内购VIP商品
    func ErigoAvVIP(vipId: String) {
        ErigoProgressVM.Erigoload()
        
        let products: Set = [vipId]
        RMStore.default().requestProducts(products) { success, invalidProductIdentifiers in
            RMStore.default().addPayment(vipId) { SKPaymentTransaction in
                ErigoProgressVM.ErigoDismiss()
                if SKPaymentTransaction?.transactionState == .purchased {
                    print("支付成功")
                    ErigoUserDefaults.updateUserDetails { erigo in
                        erigo.isVIP = true
                        return erigo
                    }
                    ErigoProgressVM.ErigoShow(type: .succeed)
                    
                } else {
                    print("取消支付")
                    ErigoProgressVM.ErigoShow(type: .failed, text: "User cancels payment")
                }
                
            } failure: { transaction, error in
                print("商品信息无效")
                ErigoProgressVM.ErigoShow(type: .failed, text: "Invalid product information")
            }
        } failure: { error in
            print("商品信息无效")
            ErigoProgressVM.ErigoShow(type: .failed, text: "Invalid product information")
        }
    }
    
    /// 内购商品
    func ErigoAvGift(gid: String, completion: @escaping() -> Void) {
        ErigoProgressVM.Erigoload()
        
        let products: Set = [gid]
        RMStore.default().requestProducts(products) { success, invalidProductIdentifiers in
            RMStore.default().addPayment(gid) { SKPaymentTransaction in
                ErigoProgressVM.ErigoDismiss()
                if SKPaymentTransaction?.transactionState == .purchased {
                    print("支付成功")
                    ErigoUserDefaults.updateUserDetails { erigo in
                        erigo.isLimit = true
                        return erigo
                    }
                    ErigoProgressVM.ErigoShow(type: .succeed)

                    completion()
                }else{
                    print("取消支付")
                    ErigoProgressVM.ErigoShow(type: .failed, text: "User cancels payment")
                }
                
            } failure: { transaction, error in
                print("商品信息无效")
                ErigoProgressVM.ErigoShow(type: .failed, text: "Invalid product information")
            }
        } failure: { error in
            print("商品信息无效")
            ErigoProgressVM.ErigoShow(type: .failed, text: "Invalid product information")
        }
    }
    
    /// 恢复购买
    func ErigoRestore() {
        ErigoProgressVM.Erigoload()
        RMStore.default().restoreTransactions(onSuccess: { transactions in
            ErigoProgressVM.ErigoDismiss()
            if transactions?.count == 0 {
                print("当前没有可恢复的商品")
                ErigoProgressVM.ErigoShow(type: .failed, text: "There are currently no items to restore")
            } else {
                print("恢复购买成功")
                ErigoProgressVM.ErigoShow(type: .succeed, text: "Restore purchase successfully")
                
                ErigoUserDefaults.updateUserDetails { erigo in
                    erigo.isVIP = true
                    return erigo
                }
            }
        }, failure: { error in
            print("取消恢复购买")
            ErigoProgressVM.ErigoShow(type: .failed, text: "Cancel restore purchase")
        })
    }
}
