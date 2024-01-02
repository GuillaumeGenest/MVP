//
//  NewTicket.swift
//  MVP
//
//  Created by Guillaume Genest on 15/12/2023.
//

import SwiftUI

struct NewTicket: View {
    @ObservedObject var viewModel = NewTicketViewModel()
    
    @Binding var date: Date
    @Binding var BusinessId: String
    @Binding var amount: Double
    
    
    @State var listofBusiness: [String:String]?
    
    var body: some View {
        VStack{
            VStack{
                Text("Ajouter un ticket ")
                TextField("Valeur", value: $amount, formatter: Utils.numberFormatter)
                    .keyboardType(.decimalPad)
                    .frame(height: 40)
                    .padding(.trailing, 16)
                    .padding(.leading, 16)
                    .background(Color.white)
                    .cornerRadius(10)
                DatePicker(selection: $date, displayedComponents: .date) {
                    Text("Date")
                }
                .frame(height: 40)
                .padding(.trailing, 16)
                .padding(.leading, 16)
                .background(Color.white)
                .cornerRadius(10)
                DropDown(BusinessId: $BusinessId, listofBusiness: $listofBusiness)
                    .padding(.trailing, 16)
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .cornerRadius(10)
            }
            .padding()
            .background(Color.bleu_empire.opacity(0.3))
            .cornerRadius(15)
        }.task{
            do {
                listofBusiness = try await viewModel.getListBusinessName()
            }catch{
                
            }
        }
    }
}

struct NewTicket_Previews: PreviewProvider {
    static var previews: some View {
        NewTicket(date: .constant(Date()), BusinessId: .constant(""), amount: .constant(0.0))
            .padding(.horizontal, 8)
    }
}


struct DropDown: View {
    @Binding var BusinessId: String
    @State private var showDropDown: Bool = false
    @Binding var listofBusiness: [String: String]?
    
    var body: some View {
        VStack {
            Button {
                self.showDropDown.toggle()
            } label: {
                HStack {
                    Text("Commerçant : ")
                    Spacer()
                    Image(systemName: self.showDropDown ? "chevron.up" : "chevron.down")
                }
                .frame(height: 40)
                .padding(.leading, 16)
                .cornerRadius(10)
            }
            VStack {
                if self.showDropDown {
                    DropdownList(selectedBusinessID: $BusinessId, listofBusiness: listofBusiness, showDropDown: $showDropDown)
                        .transition(.move(edge: .top))
                        .animation(.easeInOut(duration: 0.4))
                }
            }
        }
    }
}

struct DropdownList: View {
    @Binding var selectedBusinessID: String
    var listofBusiness: [String: String]?
    @Binding var showDropDown: Bool

    func getBusinessID(for name: String) -> String? {
        return listofBusiness?.first { $0.value == name }?.key
    }

    var body: some View {
        ForEach(listofBusiness?.values.sorted() ?? [], id: \.self) { name in
            HStack {
                Text(name)
                    .foregroundColor(selectedBusinessID == getBusinessID(for: name) ? .blue : .black)
                Spacer()
                if selectedBusinessID == getBusinessID(for: name) {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .font(.system(size: 16))
            .padding(.leading, 10)
            .padding(.vertical, 2)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if selectedBusinessID == getBusinessID(for: name) {
                        selectedBusinessID = ""
                        showDropDown.toggle()
                    } else if let businessID = getBusinessID(for: name) {
                        selectedBusinessID = businessID
                    }
                }
            }
        }
    }
}
