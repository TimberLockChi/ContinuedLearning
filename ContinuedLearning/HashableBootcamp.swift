//
//  HashableBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/11.
//
import SwiftUI
//Identifiable也可以实现hash，但是必须要添加一个标识ID，如果不想让ID暴露给外界，可以用Hash，用其内部的属性值作为唯一ID
struct MyCustomModel:Hashable{
    //let id = UUID().uuidString
    let title: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }//hash方法
}

struct HashableBootcamp: View {
    
    let data:[MyCustomModel] = [
        MyCustomModel(title: "1"),
        MyCustomModel(title: "2"),
        MyCustomModel(title: "3"),
        MyCustomModel(title: "4"),
        MyCustomModel(title: "5")
    ]
    
    var body: some View {
        ScrollView{
            VStack(spacing:40){
                ForEach(data,id:\.self){item in
                    Text(item.hashValue.description)
                        .font(.headline)
                }
            }
        }
    }
}

struct HashableBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        HashableBootcamp()
    }
}
