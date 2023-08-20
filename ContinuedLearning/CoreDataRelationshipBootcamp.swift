//
//  CoreDataRelationshipBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/17.
//

import SwiftUI
import CoreData

//BusinessEntity
//DepartMentEntity
//EmployeeEntity


//Core Data Relationship 可以联系实体间的关系，对其中一个实体进行变更，其余与之相关联的实体也会随之变更

//单例管理
class CoreDataManager{
    
    static let instances = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        self.container = NSPersistentContainer(name: "CoreDataContainer")
        container.loadPersistentStores { description, error in
            if let error = error{
                print("Error loading Core Data. \(error)")
            }
        }
        context = container.viewContext
    }
    
    func save(){
        do {
            try context.save()
            print("Saved successfully!")
        }catch let error{
            print("Error saving Core Data. \(error.localizedDescription)")
        }
       
    }
}

class CoreDataRelationshipViewModel: ObservableObject{
     
    let manager = CoreDataManager.instances
    @Published var businesses: [BusinessEntity] = []
    @Published var departments:[DepartmentEntity] = []
    @Published var employees:[EmployeeEntity] = []
    init(){
        getBusiness()
        getDepartments()
        //getEmployees()
    }
    
    func getBusiness(){
        
        let request = NSFetchRequest<BusinessEntity>(entityName: "BusinessEntity")
        //设置排序器
        let sort = NSSortDescriptor(keyPath: \BusinessEntity.name, ascending: true)
        //设置筛选器，name == %@表示通配符，参数为后面填入的字符串
        let filter = NSPredicate(format: "name == %@", "Apple")
        
        request.sortDescriptors = [sort]//依据排序器进行排序
        request.predicate = filter//依据筛选器进行排序
        
        do {
           businesses = try manager.context.fetch(request)
        }catch let error{
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func getDepartments(){
        let request = NSFetchRequest<DepartmentEntity>(entityName: "DepartmentEntity")
        do {
           departments = try manager.context.fetch(request)
        }catch let error{
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func getEmployees(forBusiness business:BusinessEntity){
        let request = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        //过滤器，依据对象进行过滤，只有绑定关系再to one时才能用
        let filter = NSPredicate(format: "business == %@ ", business)
        
        do {
           employees = try manager.context.fetch(request)
        }catch let error{
            print("Error fetching. \(error.localizedDescription)")
        }
    }

    
    func addBusiness(){
        let newBusiness = BusinessEntity(context: manager.context)
        newBusiness.name = "Apple"
        //为新Business添加部门
        //newBusiness.departments = []
        //为新Business添加员工
        //newBusiness.employees = []
        //为部门添加新Business
        //newBusiness.addToDepartments(<#T##value: DepartmentEntity##DepartmentEntity#>)
        //newBusiness.addToEmployees(<#T##value: EmployeeEntity##EmployeeEntity#>)
        save()
    }
    
    func addDepartment(){
        let newDepartment = DepartmentEntity(context: manager.context)
        newDepartment.name  = "Engineering"
        //newDepartment.businesses = [businesses[0]]//一对多关系
        newDepartment.addToEmployees(employees[1])//自动生成的函数
        save()
    }
    
    func addEmployee(){
        let newEmployee = EmployeeEntity(context: manager.context)
        newEmployee.age = 25
        newEmployee.name = "Sarah"
        newEmployee.dateJoined = Date()
        //newEmployee.business = businesses[0]//一对一关系
        //newEmployee.department = departments[0]
        save()
    }
    
    func updateBusiness(){
        let existingBusiness = businesses[2]
        existingBusiness.addToDepartments(departments[1])
        save()
    }
    
    
    //关联关系删除逻辑
    //Nullify-用户所属的部门如果被删除，用户将不属于此部门，即不属于任何部门
    //Cascade-用户所属的部门如果被删除，该部门下的所有员工也将被删除
    //Deny - 如果部门中还有 员工绑定，则无法删除该部门
    func deleteDepartment(){
        let department = departments[2]
        manager.context.delete(department)//删除CoreData数据
        save()
    }
    
    func save(){
        businesses.removeAll()
        departments.removeAll()
        employees.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.manager.save()
            self.getBusiness()
            self.getDepartments()
            //self.getEmployees()
        }
    }
    
}

struct CoreDataRelationshipBootcamp: View {
    
    @StateObject var vm = CoreDataRelationshipViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(spacing:20){
                    Button {
                        vm.getEmployees(forBusiness: vm.businesses[0] )//添加主题
                    } label: {
                        Text("Perform Action")
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.cornerRadius(10))
                            .padding(.horizontal)
                    }
                    
                    ScrollView(.horizontal,showsIndicators: true){
                        HStack(alignment: .top) {
                            ForEach(vm.businesses){ business in
                              BusinessView(entity: business)
                            }
                        }
                    }
                    ScrollView(.horizontal,showsIndicators: true){
                        HStack(alignment: .top) {
                            ForEach(vm.departments){ department in
                              DepartmentView(entity: department)
                            }
                        }
                    }
                    ScrollView(.horizontal,showsIndicators: true){
                        HStack(alignment: .top) {
                            ForEach(vm.employees){ employ in
                              EmployeeView(entity: employ)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Relationship")
        }
    }
}

struct CoreDataRelationshipBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataRelationshipBootcamp()
    }
}

struct BusinessView: View{
    let entity:BusinessEntity
    var body: some View{
        VStack(alignment: .leading,spacing: 20) {
            Text("name:\(entity.name ?? "")")
                .bold()
            //判断是否是DepartmentEntity
            if let departments = entity.departments?.allObjects as? [DepartmentEntity]{
                Text("Department:")
                    .bold()
                ForEach(departments){ department in
                    Text(department.name ?? "")
                }
            }
            if let employees = entity.employees?.allObjects as? [EmployeeEntity]{
                Text("Employees:")
                    .bold()
                ForEach(employees){ employee in
                    Text(employee.name ?? "")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct DepartmentView: View{
    let entity:DepartmentEntity
    var body: some View{
        VStack(alignment: .leading,spacing: 20) {
            Text("name:\(entity.name ?? "")")
                .bold()
            //判断是否是DepartmentEntity
            if let businesses = entity.businesses?.allObjects as? [BusinessEntity]{
                Text("Business:")
                    .bold()
                ForEach(businesses){ business in
                    Text(business.name ?? "")
                }
            }
            if let employees = entity.employees?.allObjects as? [EmployeeEntity]{
                Text("Employees:")
                    .bold()
                ForEach(employees){ employee in
                    Text(employee.name ?? "")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300,alignment: .leading)
        .background(Color.green.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}


struct EmployeeView: View{
    
    let entity:EmployeeEntity
    
    var body: some View{
        
        VStack(alignment: .leading,spacing: 20) {
            Text("name:\(entity.name ?? "")")
                .bold()
            
            Text("Age:\(entity.age)")
            Text("Date joined:\(entity.dateJoined ?? Date())")
            Text("Business:")
                .bold()
            Text(entity.business?.name ?? "")
            
            Text("Department:")
                .bold()
            Text(entity.department?.name ?? "")
        }
        .padding()
        .frame(maxWidth: 300,alignment: .leading)
        .background(Color.green.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}


