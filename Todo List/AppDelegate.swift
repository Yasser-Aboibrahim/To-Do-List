//
//  AppDelegate.swift
//  Todo List
//
//  Created by yasser on 9/19/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        let isLogged = UserDefaultManager.shared().isLoggedIn
        let userData = UserDefaultManager.shared().userEmail
        if userData != nil {
        
        
            if  isLogged {
                print("Go to TodoList screen")
                let todoListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerKeys.todoiListVC) as! TodoListVC
                let navigatioController = UINavigationController(rootViewController: todoListVC)
                UINavigationBar.appearance().tintColor = .white
                UINavigationBar.appearance().barTintColor = .purple
                self.window?.rootViewController = navigatioController

            }else{
                print("Go to SignIn screen")

                let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerKeys.signInVC) as! SignInVC
                let navigatioController = UINavigationController(rootViewController: signInVC)
                self.window?.rootViewController = navigatioController
            }
        }
       
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

