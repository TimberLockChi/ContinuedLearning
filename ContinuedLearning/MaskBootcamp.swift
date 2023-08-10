//
//  MaskBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/10.
//

import SwiftUI

struct MaskBootcamp: View {
    
    @State var rating: Int = 0
    
    var body: some View {
        ZStack{
            starView
                .overlay {
                    overlayView//根据评分裁剪出一个长方形覆盖在星星组件上
                        .mask(starView)//根据starView的样式为添加一层蒙板
                }
        }
    }
    
    private var overlayView:some View{
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.yellow)
                    .frame(width: CGFloat(rating) / 5 * geometry.size.width)
                    
            }
        }
        .allowsHitTesting(false)//用户无法点击overlay
    }
    
    private var starView: some View{
        HStack{
            ForEach(1..<6){index in
                Image(systemName: "star.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        withAnimation(.easeInOut){
                            rating = index
                        }
                    }
            }
        }
    }
    
}

struct MaskBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        MaskBootcamp()
    }
}
