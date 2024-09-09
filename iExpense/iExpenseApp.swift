//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Izaan Saleem on 15/02/2024.
//

import SwiftUI

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseType_SwiftData.self)
    }
}
