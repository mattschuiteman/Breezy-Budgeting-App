//
//  BreezyHomeView.swift
//  Breezy
//
//  Created by Matthew Schuiteman on 10/11/20.
//

import SwiftUI
import CoreData

struct BreezyBalanceView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.createdAt, ascending: false)],
        animation: .default)

    private var transactions: FetchedResults<Transaction>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MonthlyTransaction.dateLastPaid, ascending: false)],
        animation: .default)

    private var monthlyTransactions: FetchedResults<MonthlyTransaction>
    
    @FetchRequest( sortDescriptors: [NSSortDescriptor(keyPath: \Balance.amount, ascending: false)])
    
    private var balanceAmount: FetchedResults<Balance>

    
    @State var showCreateExpense: Bool = false
    @State var showCreateIncome: Bool = false
    
    @Binding var x: CGFloat
    
    let rightNow = Date()
    
    
    var body: some View {
        
        GeometryReader {geometry in
            
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
                
                
                ForEach(balanceAmount, id: \.self) {actualBalance in
                    
                    Text("\(actualBalance.amount.floatToCurrency())").font(.largeTitle)
                }
                
                
                List {
                    
                    Section(header: Text("Monthly Payments")) {
                    
                        ForEach(monthlyTransactions, id: \.self) {monthlyTransaction in
                            
                            HStack {
                                
                                VStack {
                                    
                                    Text("\(monthlyTransaction.name!)")
                                    Text(" Date last paid: \(monthlyTransaction.dateLastPaid!, formatter: dateFormatter)")
                                        .foregroundColor(Color.gray)
                                        .onAppear(perform: {
                                            checkIfNewMonthAndUpdate(newDate: rightNow, oldDate: monthlyTransaction.dateLastPaid!, item: monthlyTransaction)
                                        })
                                    
                                }
                                
                                Text("-$\(monthlyTransaction.amount.floatToCurrency())")
                                        .foregroundColor(Color.ruby)
                                
                            }
                            
                        }
                        
                    }
                    
                    Section(header: Text("Transactions")) {
                        
                        ForEach(transactions ,id: \.self) {transaction in
                                                        
                            HStack {
                                    
                                    VStack {
                                        Text("\(transaction.name!)")
                                        Text("\(transaction.createdAt!, formatter: dateFormatter)")
                                        
                                    }
                                    .padding()
                                
                                
                                if (transaction.isExpense) {
                                    Text("-$\(transaction.amount.floatToCurrency())")
                                            .foregroundColor(Color.ruby)
                                    
                                }
                                
                                else {
                                    
                                    Text("+$\(transaction.amount.floatToCurrency())")
                                        .foregroundColor(Color.emerald)
                                    
                                }
                            }
                            
                        }.onDelete(perform: { indexSet in
                            deleteTransation(offsets: indexSet, items: transactions, balance: balanceAmount)
                        })
                        
                    }
                    
                }.overlay(
                    
                    HStack {
                        
                        Button(action: {showCreateIncome.toggle()}, label: {
                            AddIncomeButton()
                        })
                        .popover(isPresented: $showCreateIncome,
                               content: {
                            
                                CreateIncome(isShowing: $showCreateIncome)
                        })
                        
                        Button(action: {showCreateExpense.toggle()}, label: {
                            addExpenseButton()
                        })
                        .popover(isPresented: $showCreateExpense,
                               content: {
                                
                            CreateExpense(isShowing: $showCreateExpense)
                        })
                        
                        
                    }.frame(width: geometry.size.width, height: geometry.size.height / 10)
                )
            }
            
        }
            
    }
    
    private func deleteTransation(offsets: IndexSet, items: FetchedResults<Transaction>, balance: FetchedResults<Balance>) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            offsets.map {
                
                if (items[$0].isExpense == true) {
                    let currentBalance = getBalance(items: balance)
                    let newAmount = currentBalance + items[$0].amount
                    updateBalance(newAmount: newAmount)
                }
                else {
                    let currentBalance = getBalance(items: balance)
                    let newAmount = currentBalance - items[$0].amount
                    updateBalance(newAmount: newAmount)
                }
            
            }

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func getBalance(items: FetchedResults<Balance>) -> Float {
        
        let currentAmount = items.first?.amount ?? 0.00
        
        return currentAmount
    }
    
    func updateBalance(newAmount: Float){
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Balance")
        
        fetchRequest.accessibilityElement(at: 0)
        
        do {
            let fetchReturn = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = fetchReturn[0] as! NSManagedObject
            objectUpdate.setValue(newAmount, forKey: "amount")
            do {
                try managedContext.save()
                print("updated successfully")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func checkIfNewMonthAndUpdate(newDate: Date, oldDate: Date, item: FetchedResults<MonthlyTransaction>.Element){

        var userCalendar = Calendar.current
        userCalendar.timeZone = TimeZone(abbreviation: "UTC")!

        let oldComponents = userCalendar.dateComponents([.month, .year], from: oldDate)
        let newComponents = userCalendar.dateComponents([.month, .year], from: newDate)

        guard let oldCompareDate = userCalendar.date(from: oldComponents) else { return }
        guard let newCompareDate = userCalendar.date(from: newComponents) else { return }

        if newCompareDate > oldCompareDate {
            //New date is a new month
            
            let amount = item.amount
            
            let originalBalance = getBalance(items: balanceAmount)
            
            let newAmount = originalBalance - amount
            
            item.dateLastPaid = rightNow
            
            updateBalance(newAmount: newAmount )
            
        } else if newCompareDate < oldCompareDate {
            //New date is an previous month
            
            //do nothing
        }
    }
}


struct addExpenseButton: View {
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .overlay(
                Text("Add Expense")
                    .foregroundColor(Color.white)
            )
            .foregroundColor(Color.sapphire)
    }
    
    let cornerRadius: CGFloat = 10.00
}

struct AddIncomeButton: View {
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .overlay(
                Text("Add Income")
                    .foregroundColor(Color.white)
            )
            .foregroundColor(Color.emerald)
    }
    
    let cornerRadius: CGFloat = 10
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()


extension Float {
    
    func floatToCurrency() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}
