//
//  Expenses.swift
//  iExpense
//
//  Created by Izaan Saleem on 29/08/2024.
//

import Foundation
import SwiftData

//MARK: - SwiftData
@Model class ExpenseType_SwiftData {
    var type: String
    @Relationship(deleteRule: .cascade) var items: [ExpenseItem_SwiftData]? = [ExpenseItem_SwiftData]()
    
    init(type: String) {
        self.type = type
    }
}

@Model class ExpenseItem_SwiftData {
    var id = UUID()
    var name: String
    var type: String
    var amount: Double
    var expenseType_SwiftData: ExpenseType_SwiftData?
    
    init(id: UUID = UUID(), name: String, type: String, amount: Double, expenseType_SwiftData: ExpenseType_SwiftData? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
        self.expenseType_SwiftData = expenseType_SwiftData
    }
}

// MARK: - UserDefault
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


extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
