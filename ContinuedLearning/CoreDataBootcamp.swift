//
//  CoreDataBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/11.
//

import SwiftUI
import CoreData

class CoreDataViewModel:ObservableObject{
    
    let container:NSPersistentContainer
    @Published var savedEntities:[FruitEntity] = []
    
    init(){
        container = NSPersistentContainer(name: "FruitContainer")
        container.loadPersistentStores { description, error in
            if let error = error{
                print("Error loading core data\(error)")
            }else{
                print("Successfully loaded core data!")
            }
        }
        fetchFruits()
    }
    
    func fetchFruits(){
        let request = NSFetchRequest<FruitEntity>(entityName: "FruitEntity")//指定泛型
        do{
           savedEntities = try  container.viewContext.fetch(request)
        }catch let error{
            print("Error fetching.\(error)")
        }
    }
    
    func addFruit(text:String){
        let newFruit = FruitEntity(context: container.viewContext)
        newFruit.name = text
        saveData()
    }
    
    func updateFruit(entity:FruitEntity){
        let currentName = entity.name ?? ""
        let newName = currentName + "!"
        
        entity.name = newName
        saveData()
    }
    
    func deletFruit(indexSet:IndexSet){
        guard let index = indexSet.first else {return}
        let entity = savedEntities[index]
        container.viewContext.delete(entity)//删除方法
        saveData()
    }
    
    func saveData(){
        do{
            try container.viewContext.save()
            fetchFruits()
        }catch let error{
            print("Error saving.\(error)")
        }
    }
    
}


struct CoreDataBootcamp: View {
    
    @StateObject var vm = CoreDataViewModel()
    @State var textFieldText:String = ""
    
    var textFieldBackground: CGColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    var buttonBackground: CGColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Add fruit here...",text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(height: 55)
                    .background(Color(textFieldBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)
                Button {
                    guard !textFieldText.isEmpty else {return}
                    vm.addFruit(text: textFieldText)
                    textFieldText = ""
                } label: {
                    Text("Button")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color(buttonBackground))
                        .cornerRadius(10)
                        
                }
                .padding(.horizontal)
                List{
                    ForEach(vm.savedEntities) { entity in
                        Text(entity.name ?? "No Name")
                            .onTapGesture {
                                vm.updateFruit(entity: entity)
                            }
                    }
                    .onDelete(perform:vm.deletFruit)
                }.listStyle(PlainListStyle())
                Spacer()
            }
        }
    }
}

struct CoreDataBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataBootcamp()
    }
}
