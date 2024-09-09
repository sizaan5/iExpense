//
//  ExpenseListView.swift
//  iExpense
//
//  Created by Izaan Saleem on 29/08/2024.
//

import SwiftUI
import SwiftData

struct ExpenseListView: View {
    
    @Environment(\.modelContext) var modelContext
    @State private var sortOrder: SortOrder = .name
    @Bindable var expenseType: ExpenseType_SwiftData
    var title: String
    @State var sortOrderType: ExpenseTypeEnums
    
    var sortedItems: [ExpenseItem_SwiftData] {
        switch sortOrder {
        case .name:
            return expenseType.items?.sorted(by: { $0.name < $1.name }) ?? []
        case .amount:
            return expenseType.items?.sorted(by: { $0.amount < $1.amount }) ?? []
        }
    }
    
    var body: some View {
        Form {
            Section(header: HStack {
                Text(title)
                Spacer()
                Menu("", systemImage: "arrow.up.arrow.down"){
                    Picker("Sort Order", selection: $sortOrder) {
                        Text("Name").tag(SortOrder.name)
                        Text("Amount").tag(SortOrder.amount)
                    }
                }
                .tint(.secondary)
            }) {
                List(sortedItems) { item in
                    NavigationLink {
                        EditView(id: item.id, name: item.name, type: item.type, amount: item.amount)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .modifier(ExpenseStyling(value: item.amount))
                        }
                    }.swipeActions(edge: .trailing) {
                        Button("Delete", role: .destructive) {
                            self.remove(item: item)
                        }
                    }
                }
            }
        }
        /*List {
            if expenses.indices.contains(0) {
                Section(header: HStack {
                    Text("\(expenses[0].type)")
                    Spacer()
                    Menu("Sort", systemImage: "arrow.up.arrow.down"){
                        Picker("Sort", selection: $sortOrderP) {
                            Text("By name")
                                .tag([
                                    SortDescriptor(\ExpenseType_SwiftData.items?[0].name),
                                    SortDescriptor(\ExpenseType_SwiftData.items?[0].amount)
                                ])
                            Text("By amount")
                                .tag([
                                    SortDescriptor(\ExpenseType_SwiftData.items?[0].amount),
                                    SortDescriptor(\ExpenseType_SwiftData.items?[0].name)
                                ])
                        }
                    }
                    .tint(.secondary)
                }) {
                    ForEach(expenses[0].items ?? []) { item in
                        NavigationLink {
                            EditView(id: item.id, name: item.name, type: item.type, amount: item.amount)
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
                        }.swipeActions(edge: .trailing) {
                            Button("Delete", role: .destructive) {
                                self.remove(id: item.id, section: 0)
                            }
                        }
                    }
//                    .onDelete(perform: { indexSet in
//                        removeItems(at: indexSet, section: 0)
//                    })
                }
            }
            
            if expenses.indices.contains(1) {
                Section(header: HStack {
                    Text("\(expenses[1].type)")
                    Spacer()
                    Menu("Sort", systemImage: "arrow.up.arrow.down"){
                        Picker("Sort", selection: $sortOrderB) {
                            Text("By name")
                                .tag([
                                    SortDescriptor(\ExpenseType_SwiftData.items?[1].name),
                                    SortDescriptor(\ExpenseType_SwiftData.items?[1].amount)
                                ])
                            Text("By amount")
                                .tag([
                                    SortDescriptor(\ExpenseType_SwiftData.items?[1].amount),
                                    SortDescriptor(\ExpenseType_SwiftData.items?[1].name)
                                ])
                        }
                    }
                    .tint(.secondary)
                }) {
                    ForEach(expenses[1].items ?? []) { item in
                        NavigationLink {
                            EditView(id: item.id, name: item.name, type: item.type, amount: item.amount)
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
                        }.swipeActions(edge: .trailing) {
                            Button("Delete", role: .destructive) {
                                self.remove(id: item.id, section: 1)
                            }
                        }
                    }
//                    .onDelete(perform: { indexSet in
//                        self.removeItems(at: indexSet, section: 1)
//                    })
                }
            }
        }*/
    }
    
    /*func removeItems(at offsets: IndexSet, section: Int) {
        /*expenses.types[section].items.remove(atOffsets: offsets)
        if expenses.types[section].items.count <= 0 {
            if let index = expenses.types.firstIndex(where: { ( $0.type.lowercased() == expenses.types[section].type ) }) {
                expenses.types.remove(at: index)
            }
            //expenses.types.removeAll(where: { ( $0.type.lowercased() == expenses.types[section].type ) })
        }*/
        for offset in offsets {
            let expense = expenses[section].items[offset]
            modelContext.delete(expense)
        }
    }*/
    
    /*init(type: ExpenseTypeEnums, sortOrder: [SortDescriptor<ExpenseType_SwiftData>]) {
        if type != .ALL {
            let type = type.rawValue
            //_expenses = Query(filter: #Predicate<ExpenseType_SwiftData> { ( $0.type == type ) }, sort: sortOrder)
        } else {
            //_expenses = Query(filter: #Predicate<ExpenseType_SwiftData> { ( $0.type != "" ) }, sort: sortOrder)
        }
    }*/
    
    func remove(item: ExpenseItem_SwiftData) {
        do {
            modelContext.delete(item)
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
        
//        if let deleteItem = self.expenses[section].items?.filter({ ( $0.id == id ) }).first {
//            modelContext.delete(deleteItem)
//            do {
//                try modelContext.save()
//            } catch {
//                print(error.localizedDescription)
//            }
//        } else {
//            print("Unable to unwrap.")
//        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ExpenseType_SwiftData.self, configurations: config)
        let type = ExpenseType_SwiftData(type: "Personal")
        return ExpenseListView(expenseType: type, title: "Personal", sortOrderType: .ALL)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
    //type: .ALL, sortOrder: [SortDescriptor(\ExpenseType_SwiftData.type)]).modelContainer(for: ExpenseType_SwiftData.self)
}
