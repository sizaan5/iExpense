//
//  EditView.swift
//  iExpense
//
//  Created by Izaan Saleem on 26/02/2024.
//

import SwiftUI
import SwiftData

struct EditView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var id: UUID// = ""
    @State var name: String// = ""
    @State var type: String// = "Personal"
    @State var amount: Double// = 0.0
    
    //var expense: ExpenseType_SwiftData
    @Query var expenses: [ExpenseType_SwiftData]
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
                            let item = ExpenseItem_SwiftData(name: name, type: type, amount: amount)
                            //let savedItems = expense.types.filter({ ( $0.type.lowercased() == type.lowercased() ) })
                            
                            if let saveItemIndex = expenses.firstIndex(where: { ( $0.type.lowercased() == item.type.lowercased() ) }) {
                                if let index = expenses[saveItemIndex].items?.firstIndex(where: { ( $0.id == id ) } ) {
                                    expenses[saveItemIndex].items?[index] = item
                                    modelContext.insert(item)
                                }
                            }
                            
                            /*if type == types[0] {
                                //Business
                                if let index = expense.items.firstIndex(where: { ( $0.id == id ) } ) {
                                    expense.items[index] = item
                                }
                            } else {
                                //Personal
                                if let index = expense.items.firstIndex(where: { ( $0.id == id ) } ) {
                                    expense.items[index] = item
                                }
                            }*/
                            
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
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ExpenseType_SwiftData.self, configurations: config)
        return EditView(id: UUID(), name: "Dinner", type: "Business", amount: 800.0)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
