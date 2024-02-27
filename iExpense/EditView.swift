//
//  EditView.swift
//  iExpense
//
//  Created by Izaan Saleem on 26/02/2024.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var id: UUID// = ""
    @State var name: String// = ""
    @State var type: String// = "Personal"
    @State var amount: Double// = 0.0
    
    var expense: Expenses
    //@State private var expenseItem: ExpenseItem
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                Text("Type: \(type)")
                
                Text("Amount: \(amount.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD")))")   
            }
            .navigationTitle($name)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if name != "" {
                            let item = ExpenseItem(name: name, type: type, amount: amount)
                            //let savedItems = expense.types.filter({ ( $0.type.lowercased() == type.lowercased() ) })
                            
                            if type == types[0] {
                                //Business
                                if let index = expense.types[0].items.firstIndex(where: { ( $0.id == id ) } ) {
                                    expense.types[0].items[index] = item
                                }
                            } else {
                                //Personal
                                if let index = expense.types[1].items.firstIndex(where: { ( $0.id == id ) } ) {
                                    expense.types[1].items[index] = item
                                }
                            }
                            
                            /*if let savedItemsIndex = expense.types.firstIndex(where: { ( $0.type.lowercased() == type.lowercased() ) }) {
                                if let index = expense.types[savedItemsIndex].items.firstIndex(where: { ( $0.id == id ) } ) {
                                    expense.types[savedItemsIndex].items[index] = item
                                }
                            } else {
                                let types = ExpenseType(type: type, items: [item])
                                expense.types.append(types)
                            }*/
                            
                            /*var items = savedItems.first?.items
                             if savedItems.count > 0 {
                             items?.append(item)
                             
                             } else {
                             let types = ExpenseType(type: type, items: [item])
                             expense.types.append(types)
                             }*/
                            
                            dismiss()
                        }
                    }
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    EditView(id: UUID(), name: "Dinner", type: "Business", amount: 800.0, expense: Expenses())
}
