//
//  CodableBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/20.
//

import SwiftUI

//Codable = Decodable + Encodable
//如果单独使用Decodable或者Encodable，需要显式定义初始化方法和解码方法
//如果直接使用Codable，则不需要显式定义

struct CustomerModel:Identifiable,
//,Decodable,Encodable
Codable
{
    let id:String
    let name:String
    let points:Int
    let isPremium:Bool
    
    init(id: String, name: String, points: Int, isPremium: Bool) {
        self.id = id
        self.name = name
        self.points = points
        self.isPremium = isPremium
    }
    //Decodable需要添加CodingKeys和特殊的init函数
//    enum CodingKeys: CodingKey {
//        case id
//        case name
//        case points
//        case isPremium
//    }
//
//    init(from decoder: Decoder) throws {
//        //你保存所有Key值的容器
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(String.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.points = try container.decode(Int.self, forKey: .points)
//        self.isPremium = try container.decode(Bool.self, forKey: .isPremium)
//    }
//    //需要补充encode方法如果设置为Encodable
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.id, forKey: .id)
//        try container.encode(self.name, forKey: .name)
//        try container.encode(self.points, forKey: .points)
//        try container.encode(self.isPremium, forKey: .isPremium)
//    }
    
}

class CodableViewModel:ObservableObject{
    @Published var customer:CustomerModel? = nil
    
    init() {
        getData()
    }
    
    func getData(){
        guard let data = getJSONData() else {return}
        self.customer = try? JSONDecoder().decode(CustomerModel.self, from: data)
    }
    func getJSONData()->Data?{
        let customer = CustomerModel(id:"12345", name: "chi", points: 5, isPremium: false)
        let jsonData=try? JSONEncoder().encode(customer)
        
        //普通数据结构转化为json对象返回，模拟网络数据接收
//        let dictionary:[String:Any] = [
//            "id":,
//            "name":,
//            "points":5,
//            "isPremium":true
//        ]
        
//        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary,options: [])
        return jsonData
    }
    //CustomerModel(id: "1", name: "Chi", points: 5, isPremium: true)
}
struct CodableBootcamp: View {
    @StateObject var vm = CodableViewModel()
    var body: some View {
        VStack(spacing: 20) {
            if let customer = vm.customer{
                Text(customer.id)
                Text(customer.name)
                Text("\(customer.points)")
                Text(customer.isPremium.description)
            }
        }
    }
}

struct CodableBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CodableBootcamp()
    }
}
