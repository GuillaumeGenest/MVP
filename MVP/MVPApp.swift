//
//  MVPApp.swift
//  MVP
//
//  Created by Guillaume Genest on 13/10/2023.
//

import SwiftUI
import Firebase

@main
struct MVPApp: App {
    @State private var isShowingLogin: Bool = false
    @StateObject var authentificationService = AuthentificationService()
    @StateObject var appsettings = AppSettings()
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                if !appsettings.isShowingLogin {
                    TabbarView(showSignInView: $appsettings.isShowingLogin)
                }
            }.onAppear {
                    let authUser = try? authentificationService.getAuthenticatedUser()
                    appsettings.isShowingLogin = authUser == nil
//                    if let authUser = authUser {
//                        appsettings.SetUserIdCrashlytics(userId: authUser.uid)
//                    }
            }
            .fullScreenCover(isPresented: $appsettings.isShowingLogin) {
                NavigationStack {
                    AuthentificationView(isShowingLogin: $appsettings.isShowingLogin)
                }
            }
        }
    }
}


class AppSettings: ObservableObject {
    @Published var isShowingLogin: Bool = false

//    func SetUserIdCrashlytics(userId: String) {
//        Crashlytics.crashlytics().setUserID(userId)
//    }
}
