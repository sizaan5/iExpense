//
//  AddView.swift
//  iExpense
//
//  Created by Izaan Saleem on 16/02/2024.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    var expense: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    //let savedItems = expense.types.filter({ ( $0.type.lowercased() == type.lowercased() ) })
                    
                    if let savedItemsIndex = expense.types.firstIndex(where: { ( $0.type.lowercased() == type.lowercased() ) }) {
                        expense.types[savedItemsIndex].items.append(item)
                    } else {
                        let types = ExpenseType(type: type, items: [item])
                        expense.types.append(types)
                    }
                    
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
}

#Preview {
    AddView(expense: Expenses())
}
