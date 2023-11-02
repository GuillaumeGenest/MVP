//
//  AuthentificationView.swift
//  MVP
//
//  Created by Guillaume Genest on 26/10/2023.
//

import SwiftUI

struct AuthentificationView: View {
    
    @Binding var isShowingLogin : Bool
    @StateObject var viewmodel = AuthentificationModelView()
    
    @State var UserEmail: String = ""
    @State var UserEmailConfirmation: String = ""
    @State var UserName: String = ""
    @State var Password: String = ""
    
    
    enum Mode {
            case SignUp
            case SignIn
            case SignUpwithEmail
            case SignInwithEmail
        }
    
    @State var currentMode: Mode = .SignInwithEmail
    
    
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center){
                VStack{
                    
                    Text("IMTY0")
                    if currentMode == .SignUpwithEmail {
                        VStack(alignment: .center){
                            SignUpwithEmail
                        }.padding()
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(20)
                            .padding()
                            .cornerRadius(20)
                            .padding(.bottom, 20)
                    }
                    if currentMode == .SignInwithEmail {
                        VStack(alignment: .center){
                            SignInwithEmail
                        }.padding()
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(20)
                            .padding()
                            .cornerRadius(20)
                            .padding(.bottom, 20)
                    }
                }
            }//.edgesIgnoringSafeArea(.all)
            .overlay(LoadingView(show: $viewmodel.isLoading))
        }
    }
    
    
    
    private var SignUpwithEmail: some View {
        VStack(alignment: .leading, spacing: 4){
            
            Text("S'inscrire")
                .font(.system(size: 20))
                .foregroundColor(Color.white)
                .bold()
            HStack{
                Text("Déjà inscrit ?")
                Button {
                    currentMode = .SignInwithEmail
                } label: {
                    Text("Se connecter")
                        .underline()
                        .bold()
                }
            }.foregroundColor(Color.white)
                .font(.callout)
                .padding(.bottom, 20)
            UsernameTextField(sentence: "Prenom", username: $UserName)
                .frame(maxWidth: .infinity)
            UsernameTextField(sentence: "Adresse email", username: $UserEmail)
                .frame(maxWidth: .infinity)
            UsernameTextField(sentence: "Confirmer l'adresse email", username: $UserEmailConfirmation)
                .frame(maxWidth: .infinity)
            PasswordSecureField(password: $Password)
                .frame(maxWidth: .infinity)
        
            
            VStack(spacing : 20){
                button_log(name: "Créer ton compte ", action: {
                    createUser()
                    
                }, colorbackground: Color.bleu_empire, colorforeground: .white)
                
                Button {
                    //currentMode = .SignUp
                } label: {
                    Text("Autre méthode d'inscription")
                        .bold()
                        .font(.callout)
                        .frame(alignment: .center)
                        .foregroundColor(Color.white)
                        .underline()
                }
            }.padding(.vertical, 20)
            
        }
    }
    
    private var SignInwithEmail: some View {
        return VStack(alignment: .leading, spacing: 10){
            Text("Se connecter")
                .foregroundColor(Color.white)
                .font(.system(size: 20))
                .bold()
            HStack{
                Text("Pas encore inscrit ?")
                Button {
                    currentMode = .SignUpwithEmail
                } label: {
                    Text("Créer un compte")
                        .underline()
                        .bold()

                }

            }.foregroundColor(Color.white)

                .padding(.bottom, 20)

            UsernameTextField(sentence: "Adresse email", username: $UserEmail)
                .frame(maxWidth: .infinity)
            PasswordSecureField(password: $Password)
                .frame(maxWidth: .infinity)

            VStack(spacing : 20){
                  button_log(name: "SE CONNECTER", action: {
                      loginUser()
                  }, colorbackground: Color.bleu_empire, colorforeground: .white)
                Button {
                   // loginData.ResetPassword(UserEmail: UserEmail)
                } label: {
                    Text("Mot de passe oublié ?")
                        .underline()
                        .bold()
                        .foregroundColor(Color.white)
                        .font(.callout)
                }

                Button {
                    currentMode = .SignInwithEmail
                } label: {
                    Text("Autre méthode de connexion")
                        .underline()
                        .bold()
                        .foregroundColor(Color.white)
                        .font(.callout)

                }



            }.padding(.top, 20)
        }
    }
      
    
    private var SignIn: some View {
        return VStack(alignment: .center){
            HStack{
                Text("Se connecter")
                    .font(.system(size: 18))
                    .foregroundColor(Color.white)
                    .bold()
                Spacer()
            }
            Button(action: {
                LoginWithApple()
            }, label: {
                Text("Sign With Apple")
                //SignInWithAppleButtonView(type: .signIn, style: .black)
                //    .cornerRadius(10)
            })
            .frame(height: 55)
            
            
            Button (action: {
                loginWithGoogle()
            }, label: {
                
                Text("Sign In with Google")
            })

//            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .standard, state: .normal)) {
//                loginWithGoogle
//            }
                .cornerRadius(10)
            
            HStack{
                Rectangle()
                    .frame(height: 0.5)
                Text("ou")
                Rectangle()
                    .frame(height: 0.5)
            }.foregroundColor(.white)
            Button {
                currentMode = .SignInwithEmail
            } label: {
                HStack{
                    Image(systemName: "envelope")
                    Text("Se connecter avec email")
                }.font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
            }
            
            Button {
                
            } label: {
                HStack{
                    Image(systemName: "custom.phone.badge.checkmark")
                    Text("Se connecter avec son téléphone")
                }.font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
            }
            
            
            
            VStack{
                HStack{
                    Text("Pas encore inscrit ?")
                        .foregroundColor(Color.white)
                    Button {
                        currentMode = .SignUp
                    } label: {
                        Text("Créer un compte")
                            .foregroundColor(Color.white)
                            .bold()
                            .underline()
                    }
                    
                }.font(.callout)
                .padding(.vertical, 8)
                
            }
        }
    }
    
    
    
    
    private func loginUser() {
        Task {
            do {
                viewmodel.isLoading = true
                try await viewmodel.signInWithEmail(email: self.UserEmail, password: self.Password)
                viewmodel.isLoading = false
                self.isShowingLogin.toggle()
            }catch {
                print("error \(error.localizedDescription)")
            }
        }
    }
    
    private func createUser() {
        
        Task {
            do {
                viewmodel.isLoading = true
                try await viewmodel.signUpWithEmail(email: self.UserEmail, password: self.Password, name: self.UserName)
                viewmodel.isLoading = false
                self.isShowingLogin.toggle()
            } catch  {
                print("error \(error.localizedDescription)")
            }
        }
    }
}

private func LoginWithApple() {
//    Task{
//        do {
//            try await loginData.signInWithApple()
//            self.isShowingLogin.toggle()
//            loginData.isLoading = false
//        }
//        catch SignUpError.userNotFoundCreated {
//            loginData.isLoading = false
//            print("error SignUpError.userNotFoundCreated")
//            print("tentative affichage")
//            showAlertWithAutoDismiss(message: SignUpError.userNotFoundCreated.errorDescription ?? "Error")
//        }
//        catch {
//            loginData.isLoading.toggle()
//            await loginData.setError(error)
//        }
//    }
}


private func loginWithGoogle() {
//    Task{
//        do {
//            print("Sign In with google check user ")
//            try await loginData.signInWithGoogle()
//            loginData.isLoading = false
//            self.isShowingLogin.toggle()
//        } catch {
//            loginData.isLoading = false
//            await loginData.setError(error)
//
//        }
//    }

}

private func loginWWithTelephone() {
    
}





struct AuthentificationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthentificationView(isShowingLogin: .constant(false))
        AuthentificationView(isShowingLogin: .constant(false), currentMode: .SignUpwithEmail)
    }
}



struct UsernameTextField: View {
    let sentence : String
    @Binding var username: String
    var body: some View {
        TextField("\(sentence)", text: $username)
            .padding()
            .background(Color.cellcolor)
            .cornerRadius(150)
    }
}

struct PasswordSecureField: View {
    @Binding var password: String
    var body: some View {
        SecureField("Mot de passe", text: $password)
            .padding()
            .background(Color.cellcolor)
            .cornerRadius(150)
    }
}
