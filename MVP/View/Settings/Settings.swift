//
//  Settings.swift
//  MVP
//
//  Created by Guillaume Genest on 07/11/2023.
//

import SwiftUI

struct Settings: View {
    @StateObject var viewModel = SettingsViewModel()
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack{
            VStack {
                
                if let user = viewModel.user {
                    UserInformation(user: user)
                }
                if viewModel.authProviders.contains(.email) {
                    EmailSection
                }else {
                    OtherAuthProvidersSection
                }
                ParameterSettingsCell(titre: "Support / Aide" ,value: [ConfigurationArray(NameFile: "Contacter le support", action: {
                    
                    
                    let email = "contact@sunnyonroads.com"
                    if let url = URL(string: "mailto:\(email)"),
                       UIApplication.shared.canOpenURL(url)
                    {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }), ConfigurationArray(NameFile: "Politique de confidentialité", action: {
                    if let appURL = URL(string:"https://sunnyonroads.com") {
                        UIApplication.shared.open(appURL) { success in
                            if success {
                                print("The URL was delivered successfully.")
                            } else {
                                print("The URL failed to open.")
                            }
                        }
                    } else {
                        print("Invalid URL specified.")
                    }
                }), ConfigurationArray(NameFile: "Supprimer mon compte", action: {
                    
                })]).padding()
                Spacer()
                button_log(name: "Deconnection", action: {
                    Task {
                        do {
                            try viewModel.signOut()
                            showSignInView = true
                        } catch {
                            print(error)
                        }
                    }
                }, colorbackground: Color.bleu_empire, colorforeground: Color.white)
                .padding(.horizontal, 8)
                .padding(.bottom, 20)
            }.task {
                try? await viewModel.loadCurrentUser()
            }
        }
        
    }
    
    private var EmailSection: some View {
        ParameterSettingsCell(titre: "Mon Compte" ,value: [ConfigurationArray(NameFile: "Modifier mon profil", action: {}), ConfigurationArray(NameFile: "Changement de mot de passe", action: {})])
            .padding()
    }
    
    
    private var OtherAuthProvidersSection: some View {
        ParameterSettingsCell(titre: "Mon Compte" ,value: [ConfigurationArray(NameFile: "Modifier mon profil", action: {})])
            .padding()
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        UserInformation(user: MockedDataUser)
        Settings(showSignInView: .constant(false))
            .environmentObject(AppSettings())
    }
}



struct UserInformation: View {
    let user: UserModel
    var body: some View {
        HStack {
            ZStack {
                    Circle()
                        .stroke(Color.bleu_empire, lineWidth: 5)
                        .frame(width: 100, height: 100)
                            
                        Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color.bleu_empire)
                                .frame(width: 50, height: 50)
                        }
            VStack(alignment: .leading) {
                Text("Email: \(user.email)")
                Text("Nom: \(user.name)")
            }
            Spacer()
        }.padding(.horizontal, 8)
    }
}
