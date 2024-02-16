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
                    expense.items.append(item)
                    
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView(expense: Expenses())
}
