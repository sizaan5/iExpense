//
//  AddView.swift
//  iExpense
//
//  Created by Izaan Saleem on 16/02/2024.
//

import SwiftUI
import SwiftData

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query private var expenses: [ExpenseType_SwiftData]
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    @State private var appSupportDir = "N/A"
    
    //var expense: Expenses
    //var expense: ExpenseType_SwiftData?
    
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
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if name != "" {
                            //let item = ExpenseItem(name: name, type: type, amount: amount)
                            let item = ExpenseItem_SwiftData(name: name, type: type, amount: amount)
                            //let savedItems = expense.types.filter({ ( $0.type.lowercased() == type.lowercased() ) })
                            
                            /*if let savedItemsIndex = expense.types.firstIndex(where: { ( $0.type.lowercased() == type.lowercased() ) }) {
                             expense.types[savedItemsIndex].items.append(item)
                             } else {
                             let types = ExpenseType(type: type, items: [item])
                             expense.types.append(types)
                             }*/
                            
                            //                            if let savedItemIndex = expense.items.firstIndex(where: { ( $0.lowercased() == type.lowercased() ) }) {
                            //                                let type = ExpenseType_SwiftData(type: type, items: [item])
                            //                                expense.items[0] = type
                            //                            } else {
                            //                                let type = ExpenseType_SwiftData(type: type, items: [item])
                            //                                modelContext.insert(type)
                            //                            }
                            
                            if let savedItemIndex = self.expenses.firstIndex(where: { ( $0.type.lowercased() == item.type.lowercased() ) }) {
                                self.expenses[savedItemIndex].items?.append(item)
                                modelContext.insert(item)
                                //let type = self.expenses[savedItemIndex].items
                                //modelContext.insert(type)
                            } else {
                                let type = ExpenseType_SwiftData(type: type)
                                type.items = [item]
                                modelContext.insert(type)
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
            .onAppear {
                guard let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last else { return }
                self.appSupportDir = "\(appSupportDir)"
                print("appSupportDir: \(appSupportDir)")
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ExpenseType_SwiftData.self, configurations: config)
        return AddView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
