//
//  ContentView.swift
//  iExpense
//
//  Created by Izaan Saleem on 15/02/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    //@State private var expenses = Expenses()
    @Query private var expenses: [ExpenseType_SwiftData]
    @State private var showingAddExpense = false
    /*@State private var sortOrder = [
        SortDescriptor(\ExpenseType_SwiftData.items?.first?.name),
        SortDescriptor(\ExpenseType_SwiftData.items?.first?.amount)
    ]*/
    @State private var sortOrderType: ExpenseTypeEnums = .ALL
    
    var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
                if self.sortOrderType == ExpenseTypeEnums.ALL {
                    ForEach(expenses) { expense in
                        ExpenseListView(expenseType: expense, title: expense.type, sortOrderType: sortOrderType)
                    }
                } else {
                    if let filterExpense = self.expenses.filter({ ( $0.type.lowercased() == self.sortOrderType.rawValue.lowercased() ) }).first {
                        ExpenseListView(expenseType: filterExpense, title: filterExpense.type, sortOrderType: sortOrderType)
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    NavigationLink {
                        AddView()
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                    Menu("Sort", systemImage: "arrow.up.arrow.down"){
                        Picker("Sort", selection: $sortOrderType) {
                            Text("Show All")
                                .tag(ExpenseTypeEnums.ALL)
                            Text("Show Personal")
                                .tag(ExpenseTypeEnums.PERSONAL)
                            Text("Show Business")
                                .tag(ExpenseTypeEnums.BUSINESS)
                        }
                    }
                }
                /*Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }*/
            }
            /*.sheet(isPresented: $showingAddExpense, content: {
                AddView(expense: expenses.first)
            })*/
        }
    }
}

#Preview {
    ContentView()
}


struct ExpenseStyling: ViewModifier {
    let value: Double
    func body(content: Content) -> some View {
        if value < 100 {
            content
                .fontWeight(.regular)
                .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
        } else if value < 1000 {
            content
                .fontWeight(.semibold)
                .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                .underline()
        } else {
            content
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                .background(.red.opacity(0.5))
                .clipShape(.rect(cornerRadius: 30))
        }
    }
}

enum ExpenseTypeEnums: String {
    case ALL = "All"
    case BUSINESS = "Business"
    case PERSONAL = "Personal"
}

enum SortOrder {
    case name
    case amount
}
