//
//  GeometryReaderBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/10.
//

import SwiftUI

struct GeometryReaderBootcamp: View {
    
    func getPercentage(geo: GeometryProxy) ->Double {
        let maxDistance = UIScreen.main.bounds.width / 2
        let currentX = geo.frame(in: .global).midX//得到当前物体的X的中点坐标,.global表示以全域范围为坐标系
        return Double(1 - (currentX / maxDistance))//物体位于屏幕中间时，不进行转动
    }
    
    var body: some View {
        //会非常耗费计算资源，尽可能的减少geometry的使用
        ScrollView(.horizontal,showsIndicators: false) {
            HStack{
                ForEach(0..<20){ index in
                    GeometryReader{ geometry in
                      RoundedRectangle(cornerRadius: 20)
                            .rotation3DEffect(
                                Angle(degrees: getPercentage(geo: geometry)*40),
                                axis: (x:0.0,y:1.0,z:0.0))
                    }
                    .frame(width: 300,height: 300)
                    .padding()
                }
            }
        }
        
        
//        GeometryReader { geometry in
//            //geometry能拿到屏幕实际尺寸，会根据手机方向改变
//            HStack(spacing: 0){
//                Rectangle()
//                    .fill(Color.red)
//                    .frame(width: geometry.size.width * 0.6666)
//                Rectangle()
//                    .fill(Color.blue)
//            }
//            .ignoresSafeArea()
//        }
        
    }
}

struct GeometryReaderBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReaderBootcamp()
    }
}
