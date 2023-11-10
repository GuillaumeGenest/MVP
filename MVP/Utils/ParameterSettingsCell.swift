//
//  ParameterSettingsCell.swift
//  MVP
//
//  Created by Guillaume Genest on 08/11/2023.
//

import SwiftUI
struct ParameterSettingsCell: View {
    @Environment(\.colorScheme) var colorScheme
    let titre: String
    let value: [ConfigurationArray]
    var body: some View {
        VStack(alignment: .leading){
            Text(titre)
                .bold()
             VStack(alignment: .leading){
                ForEach(value){ configurationArray in
                    Button(action: configurationArray.action,
                    label: {
                        HStack{
                            Text(configurationArray.NameFile)
                            Spacer()
                            Image(systemName: "chevron.forward")
                        }.font(.callout)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    })
                    if configurationArray != value.last{
                Rectangle()
                  .frame(height: 0.5)
                    }
               }
             }.padding(.horizontal)
                .padding(.vertical, 3)
            .frame(maxWidth: .infinity)
        }.padding()
        .background(Color.backgroundgrey)
        .cornerRadius(15)
    }
}



struct ParameterSettingsCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ParameterSettingsCell(titre: "Mon Compte" ,value: [ConfigurationArray(NameFile: "Mon Compte", action: {})])
                .padding()
            ParameterSettingsCell(titre: "Mon Compte" ,value: [ConfigurationArray(NameFile: "Mon Compte", action: {}), ConfigurationArray(NameFile: "Changement de mot de passe", action: {})])
                .padding()
        }
    }
}

struct ConfigurationArray : Identifiable, Equatable{
    static func == (lhs: ConfigurationArray, rhs: ConfigurationArray) -> Bool {
        return lhs.id == rhs.id
    }
    let id : UUID = UUID()
    var NameFile: String
    var action: () -> Void
}
