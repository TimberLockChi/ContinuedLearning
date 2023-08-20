//
//  TypeailasBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/20.
//

import SwiftUI

struct MovieModel{
    let title: String
    let director: String
    let count:Int
}

typealias TVModel = MovieModel//设置别名

struct TypeailasBootcamp: View {
    
    @State var item: TVModel = TVModel(title: "Title", director: "Joe", count: 5)
    
    var body: some View {
        VStack{
            Text(item.title)
            Text(item.director)
            Text("\(item.count)")
        }
        
    }
}

struct TypeailasBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TypeailasBootcamp()
    }
}
