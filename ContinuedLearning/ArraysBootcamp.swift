//
//  ArraysBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/11.
//

import SwiftUI


struct UserModel:Identifiable{
    let id = UUID().uuidString
    let name: String?
    let point: Int
    let isVerified: Bool
}

class ArrayModificationViewModel:ObservableObject{
    
    @Published var dataArray: [UserModel] = []
    @Published var filteredArray: [UserModel] = []
    @Published var mappedArray:[String] = []
    
    init(){
        getUsers()
        updateFilteredArray()
    }
    func updateFilteredArray(){
        //sort
        /*
         //倒序排序
         //方式-1
         filteredArray = dataArray.sorted { user1, user2 in
             return user1.point > user2.point
         }
         //方式-2
         filteredArray = dataArray.sorted(by: {$0.point > $1.point})
         */
        /*
        //filter
        //过滤器
        filteredArray = dataArray.filter({ user in
            return user.isVerified
        })
        filteredArray = dataArray.filter({!$0.isVerified})
        */
        
        //map
//        mappedArray = dataArray.map({ user in
//            return user.name ?? "Error"
//        })
        //属性值必须存在
        //mappedArray = dataArray.map({$0.name})
//        mappedArray = dataArray.compactMap({ user in
//            return user.name
//        })
        
        //同时应用排序，过滤和字典功能
        mappedArray = dataArray
            .sorted(by: {$0.point > $1.point})
            .filter({$0.isVerified})
            .compactMap({$0.name})
    }
    
    func getUsers(){
        let user1 = UserModel(name: "a", point: 5, isVerified: true)
        let user2 = UserModel(name: "b", point: 10, isVerified: false)
        let user3 = UserModel(name: "c", point: 45, isVerified: true)
        let user4 = UserModel(name: "d", point: 235, isVerified: false)
        let user5 = UserModel(name: "e", point: 435, isVerified: true)
        let user6 = UserModel(name: nil, point: 76, isVerified: false)
        let user7 = UserModel(name: "g", point: 58, isVerified: true)
        let user8 = UserModel(name: "h", point: 653, isVerified: true)
        let user9 = UserModel(name: "i", point: 752, isVerified: false)
        let user10 = UserModel(name: "j", point: 85, isVerified: true)
        self.dataArray.append(contentsOf: [
            user1,user2,user3,user4,user5,user6,user7,user8,
            user9,user10
        ])
    }
    
}

struct ArraysBootcamp: View {
    @StateObject var vm = ArrayModificationViewModel()
    var body: some View {
        ScrollView{
            VStack(spacing:10){
                
                ForEach(vm.mappedArray,id:\.self){name in
                    Text(name)
                        .font(.title)
                }
//                ForEach(vm.filteredArray){ user in
//                    VStack(alignment: .leading){
//                        Text(user.name)
//                            .font(.headline)
//                        HStack{
//                            Text("Point:\(user.point)")
//                            Spacer()
//                            if user.isVerified{
//                                Image(systemName: "flame.fill")
//                            }
//                        }
//                    }
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue.cornerRadius(10))
//                    .padding(.horizontal)
//                }
            }
        }
    }
}

struct ArraysBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ArraysBootcamp()
    }
}
