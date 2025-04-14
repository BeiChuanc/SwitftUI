//
//  PeppyLoginAppleController.swift
//  Peppy
//
//  Created by 北川 on 2025/4/12.
//

import Foundation
import UIKit
import AuthenticationServices

class ASAuthorizationControllerViewController: UIViewController {
    let authorizationController: ASAuthorizationController

    init(authorizationController: ASAuthorizationController) {
        self.authorizationController = authorizationController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authorizationController.performRequests()
    }
}
