//
//  DragGestureBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/10.
//

import SwiftUI


struct DragGestureBootcamp: View {
    
    @State var offset:CGSize = .zero//.zero = CGSize(width:0,height:0)
    
    var body: some View {
        ZStack {
            
            VStack{
                Text("\(offset.width)")
                Spacer()
            }
            
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 300,height: 500)
                .offset(offset)
                .scaleEffect(getScaleAmount())//放大/缩小
                .rotationEffect(Angle(degrees: getRotationAmount()))//旋转效果
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            withAnimation(.spring()) {
                                offset = value.translation
                            }
                            
                        })
                        .onEnded({ value in
                            withAnimation(.spring()) {
                                offset = .zero
                            }
                        })
            )
        }
    }
    
    func getScaleAmount() -> CGFloat{
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = abs(offset.width)
        let percentage = currentAmount / max
        
        return 1.0 - min(percentage , 0.5) * 0.5//取最小值，限制在50%以上
    }
    
    func getRotationAmount()->Double{
        let max = UIScreen.main.bounds.width/2
        let currentAmount = offset.width
        let percentage = currentAmount / max
        let percentageAsDouble = Double(percentage)
        let maxAngle: Double = 10
        return percentageAsDouble * maxAngle
    }
}

struct DragGestureBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DragGestureBootcamp()
    }
}
