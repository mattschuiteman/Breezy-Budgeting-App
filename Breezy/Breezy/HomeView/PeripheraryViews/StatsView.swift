//
//  Stats View.swift
//  Breezy
//
//  Created by Matthew Schuiteman on 10/24/20.
//

import SwiftUI

struct StatsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.createdAt, ascending: false)],
        animation: .default)

    private var transations: FetchedResults<Transaction>
    
    @Binding var x: CGFloat
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Button(action: {
                  
                  // opening menu,...
                  
                  withAnimation{
                      
                      x = 0
                  }
                  
              }) {
                  
                  Image(systemName: "line.horizontal.3")
                      .font(.system(size: 24))
              }
        
                List {
                    
                
                
                    Text("Total Profit: \(calculateProfit(items: transations).floatToCurrency() )")
                    
              
                    
                    Text("Total Income: \(calculateTotalIncome(items: transations).floatToCurrency() )")
                    
              
                    
                    Text("Total Expenses: \(calculateTotalExpenses(items: transations).floatToCurrency() )")
                    
              
                    
                    Text("Average Income after Losses Per Day: \(calculateAverageProfit(items: transations).floatToCurrency() )")
                    
                    Text("Average Pure Income Per Day: \(calculateAverageIncome(items: transations).floatToCurrency() )")
                    
                    Text("Average Pure Expenses Per Day: \(calculateAverageExpense(items: transations).floatToCurrency() )")
                }
                
            }
            
        }
        
    }
    
   private func calculateProfit(items: FetchedResults<Transaction>) -> Float {
        
        var sum: Float = 0.00
        
        for index in items {
            
            if index.isExpense == true {
                sum = sum - index.amount
            }
            
            else {
                sum = sum + index.amount
            }
        }
        
        return sum
        
    }
    
    private func calculateTotalExpenses (items: FetchedResults<Transaction>) -> Float {
        
        var sum: Float = 0.00
        
        for index in items {
            
            if index.isExpense == true {
                sum = sum + index.amount
            }
            
            else {
                continue
            }
            
        }
        
        return sum
    }
    
    private func calculateTotalIncome (items: FetchedResults<Transaction>) -> Float {
        
        var sum: Float = 0.00
        
        for index in items {
            
            if index.isExpense == false {
                sum = sum + index.amount
            }
            
            else {
                continue
            }
            
        }
        
        return sum
    }
    
    private func calculateAverageProfit (items: FetchedResults<Transaction>) -> Float {
        
        var uniqueDays: [Date] = [items.first!.createdAt!]
        
        //Add all days to array
        
        for index in items {
            
            if uniqueDays.contains(index.createdAt!) == false {
                uniqueDays.append(index.createdAt!)
            }
            
        }
        
        let sum = calculateProfit(items: transations)
        
        let average = sum / Float(uniqueDays.count)
        
        return average
    }
    
    private func calculateAverageIncome (items: FetchedResults<Transaction>) -> Float {
        
        var uniqueDays: [Date] = [items.first!.createdAt!]
        
        //Add all days to array
        
        for index in items {
            
            if uniqueDays.contains(index.createdAt!) == false {
                uniqueDays.append(index.createdAt!)
            }
            
        }
        
        let sum = calculateTotalIncome(items: transations)
        
        let average = sum / Float(uniqueDays.count)
        
        return average
    }
    
    private func calculateAverageExpense (items: FetchedResults<Transaction>) -> Float {
        
        var uniqueDays: [Date] = [items.first!.createdAt!]
        
        //Add all days to array
        
        for index in items {
            
            if uniqueDays.contains(index.createdAt!) == false {
                uniqueDays.append(index.createdAt!)
            }
            
        }
        
        let sum = calculateTotalExpenses(items: transations)
        
        let average = sum / Float(uniqueDays.count)
        
        return average
    }
}

