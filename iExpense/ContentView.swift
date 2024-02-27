//
//  ContentView.swift
//  iExpense
//
//  Created by Izaan Saleem on 15/02/2024.
//

import SwiftUI

struct ExpenseType: Codable {
    var type: String
    var items: [ExpenseItem]
}

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable class Expenses {
    
    /*init() {
        if let savedItems = UserDefaults.standard.data(forKey: "items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
    }*/
    /*init() {
        if let savedType1 = UserDefaults.standard.data(forKey: "types") {
            if let decodedTypes = try? JSONDecoder().decode([ExpenseType].self, from: savedType1) {
                types = decodedTypes1
                return
            }
        }
    }*/
    
    init() {
        if let savedTypes = UserDefaults.standard.data(forKey: "types") {
            if let decodedTypes = try? JSONDecoder().decode([ExpenseType].self, from: savedTypes) {
                types = decodedTypes
            }
        }
    }
    
    /*var items: [ExpenseItem] = [] {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "items")
            }
        }
    }*/
    
    var types: [ExpenseType] = [] {
        didSet {
            if let encoded = try? JSONEncoder().encode(types) {
                UserDefaults.standard.set(encoded, forKey: "types")
            }
        }
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                if expenses.types.indices.contains(0) {
                    Section(expenses.types[0].type) {
                        ForEach(expenses.types[0].items) { item in
                            NavigationLink {
                                EditView(id: item.id, name: item.name, type: item.type, amount: item.amount, expense: expenses)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                        //Text(item.type)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .modifier(ExpenseStyling(value: item.amount))
                                }
                            }
                        }
                        .onDelete(perform: { indexSet in
                            removeItems(at: indexSet, section: 0)
                        })
                    }
                }
                if expenses.types.indices.contains(1) {
                    Section(expenses.types[1].type) {
                        ForEach(expenses.types[1].items) { item in
                            NavigationLink {
                                EditView(id: item.id, name: item.name, type: item.type, amount: item.amount, expense: expenses)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                        //Text(item.type)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .modifier(ExpenseStyling(value: item.amount))
                                }
                            }
                        }
                        .onDelete(perform: { indexSet in
                            removeItems(at: indexSet, section: 1)
                        })
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink {
                    AddView(expense: expenses)
                } label: {
                    Image(systemName: "plus")
                }
                /*Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }*/
            }
            .sheet(isPresented: $showingAddExpense, content: {
                AddView(expense: expenses)
            })
        }
    }
    
    func removeItems(at offsets: IndexSet, section: Int) {
        expenses.types[section].items.remove(atOffsets: offsets)
        if expenses.types[section].items.count <= 0 {
            if let index = expenses.types.firstIndex(where: { ( $0.type.lowercased() == expenses.types[section].type ) }) {
                expenses.types.remove(at: index)
            }
            //expenses.types.removeAll(where: { ( $0.type.lowercased() == expenses.types[section].type ) })
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
