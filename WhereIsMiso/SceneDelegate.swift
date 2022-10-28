//
//  SceneDelegate.swift
//  WhereIsMiso
//
//  Created by Kurt Jacobs on 2022/10/10.
//

import UIKit
import ui_layer

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appDependencies: AppDependencies = AppDependencies()
    private lazy var mainCoordinator: MainCoordinator = MainCoordinator(dependencies: appDependencies)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        mainCoordinator.start()
        window?.rootViewController = mainCoordinator.navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }


}

