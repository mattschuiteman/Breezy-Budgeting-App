//
//  OnBoardingView.swift
//  Breezy
//
//  Created by Matthew Schuiteman on 10/17/20.
//
import CoreData
import SwiftUI

struct OnBoardingView: View {
    
    @EnvironmentObject private var viewRouter: ViewRouter
    
    @State private var initialBudgetAmount: String = "0.00"
    
    var body: some View {
        
        GeometryReader { geometry in
    
            VStack {
                Text("Enter Initial Budget")
                TextField("", text: $initialBudgetAmount)
                
                Button(action: {
                    createBalance(amount: initialBudgetAmount)
                    viewRouter.currentPage = "breezyView"
                },
                       
                       label: {
                        
                        Rectangle().frame(width: geometry.size.width, height: geometry.size.height / 6, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                })
                
                
            }
            
        }
        
    }
        
    
    private func createBalance(amount: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Balance", in: managedContext)!
        
        let newBalance = NSManagedObject(entity: entity, insertInto: managedContext)
        
        let amount = Float(amount)
        
        print("set initial amount")
        
        newBalance.setValue(amount, forKeyPath: "amount")
        
        
        do {
            try managedContext.save()
            print("Saved initial balance")
        }
        catch let error as NSError{
            print("Could not save because \(error)")
        }
    }
    
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
