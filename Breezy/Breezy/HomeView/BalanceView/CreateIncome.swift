//
//  CreateIncome.swift
//  Breezy
//
//  Created by Matthew Schuiteman on 10/13/20.
//

import SwiftUI
import CoreData

struct CreateIncome: View {
    
    @FetchRequest( sortDescriptors: [NSSortDescriptor(keyPath: \Balance.amount, ascending: false)])
    
    private var currentBalance: FetchedResults<Balance>
    
    @Binding var isShowing: Bool
    
    @State private var newIncomeName = ""
    @State private var newIncomeDate = Date()
    @State private var newIncomeAmount = ""
    @State private var newIncomeIsExpense = false
    
    var body: some View {
        
        NavigationView {
        
            VStack {
            
                Form {
                    
                    Section {
                        
                        TextField("Name", text: $newIncomeName).keyboardType(.default)
                        
                        DatePicker(selection: $newIncomeDate, in: ...Date(), displayedComponents: .date) {
                                       Text("Date")
                        }
                        
                        TextField("Amount", text: $newIncomeAmount).keyboardType(.decimalPad)
                        
                    }
                    
                }
                .navigationBarTitle(Text("Add Income"), displayMode: .inline)
                .navigationBarItems(leading:
                    Button(action: {isShowing = false},
                        label: {
                        Text("Cancel")
                    })
                )
                
                Button(action: {
                        createIncome(
                        name: newIncomeName,
                        createdAt: newIncomeDate,
                        amount: newIncomeAmount,
                        isExpense: newIncomeIsExpense
                        )
                    isShowing = false
                },
                       label: {
                        AddIncomeButton()
                })
                
            }

        }
        
    }
    
    private func createIncome(name: String, createdAt: Date, amount: String, isExpense: Bool) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: managedContext)!
        
        let newIncome = NSManagedObject(entity: entity, insertInto: managedContext)
        
        let amount = Float(amount)
        
        
        newIncome.setValue(isExpense, forKeyPath: "isExpense")
        newIncome.setValue(name, forKeyPath: "name")
        newIncome.setValue(createdAt, forKeyPath: "createdAt")
        newIncome.setValue(amount, forKeyPath: "amount")
        
        let originalBalance = getBalance(items: currentBalance)
        
        let newAmount = originalBalance + amount!
        
        updateBalance(newAmount: newAmount )
        
        do {
            try managedContext.save()
        }
        catch let error as NSError{
            print("Could not save because \(error)")
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
