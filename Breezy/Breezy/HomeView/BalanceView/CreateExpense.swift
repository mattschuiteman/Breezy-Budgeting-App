//
//  createExpense.swift
//  Breezy
//
//  Created by Matthew Schuiteman on 10/11/20.
//

import SwiftUI
import CoreData
import Combine

struct CreateExpense: View {
    
    @FetchRequest( sortDescriptors: [NSSortDescriptor(keyPath: \Balance.amount, ascending: false)])
    
    private var currentBalance: FetchedResults<Balance>
    
    
    @Binding var isShowing: Bool
    
    @State private var newExpenseName = "Expense"
    @State private var newExpenseDate = Date()
    @State private var newExpenseAmount = "0"
    @State private var newExpenseIsExpense = true
    
    @State private var newExpenseIsMonthly = false
    
    var body: some View {
        
        NavigationView {
        
            VStack {
            
                Form {
                    
                    Section {
                        
                        TextField("Name", text: $newExpenseName).keyboardType(.default)
                        
                        DatePicker(selection: $newExpenseDate, in: ...Date(), displayedComponents: .date) {
                                       Text("Date")
                        }
                        
                        TextField("Amount", text: $newExpenseAmount).keyboardType(.decimalPad)
                            .onReceive(Just(newExpenseAmount)) { newValue in
                                let filtered = newValue.filter { ".0123456789".contains($0) }

                                if filtered != newValue {
                                    self.newExpenseAmount = filtered
                                }
                                
                            }
                        
                        Toggle(isOn: $newExpenseIsMonthly) {
                            Text("Is this expense every month?")
                        }
                        
                    }
                    
                }
                .navigationBarTitle(Text("Add Expense"), displayMode: .inline)
                .navigationBarItems(leading:
                    Button(action: {isShowing = false},
                        label: {
                        Text("Cancel")
                    })
                )
                
                Button(action: {
                    createExpense(
                        name: newExpenseName,
                        createdAt: newExpenseDate,
                        amount: newExpenseAmount,
                        isMonthly: newExpenseIsMonthly,
                        isExpense: newExpenseIsExpense)
                    
                    isShowing = false
                    
                },
                       label: {
                    addExpenseButton()
                })
                
            }
            
            
            
        }
        
        
        
    }
    
    private func createExpense(name: String, createdAt: Date, amount: String, isMonthly: Bool, isExpense: Bool ) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Creates a new expense that is a one time purchase
        
        if isMonthly == false {
        
            let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: managedContext)!
            
            let newExpense = NSManagedObject(entity: entity, insertInto: managedContext)
            
            let amount = Float(amount)
            
            newExpense.setValue(name, forKeyPath: "name")
            newExpense.setValue(createdAt, forKeyPath: "createdAt")
            newExpense.setValue(amount, forKeyPath: "amount")
            newExpense.setValue(isExpense, forKeyPath: "isExpense")
            
            let originalBalance = getBalance(items: currentBalance)
            
            let newAmount = originalBalance - amount!
            
            updateBalance(newAmount: newAmount )
            
            do {
                try managedContext.save()
            }
            catch let error as NSError{
                print("Could not save because \(error)")
            }
            
        }
        
        //Creates a new expense that is a monthly expense
        
        else {
            
            let entity = NSEntityDescription.entity(forEntityName: "MonthlyTransaction", in: managedContext)!
            
            let newExpense = NSManagedObject(entity: entity, insertInto: managedContext)
            
            let amount = Float(amount)
            
            newExpense.setValue(name, forKeyPath: "name")
            newExpense.setValue(createdAt, forKeyPath: "dateLastPaid")
            newExpense.setValue(amount, forKeyPath: "amount")
            
            let originalBalance = getBalance(items: currentBalance)
            
            let newAmount = originalBalance - amount!
            
            updateBalance(newAmount: newAmount )
            
            do {
                try managedContext.save()
            }
            catch let error as NSError{
                print("Could not save because \(error)")
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
}

extension Float {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}
