//
//  HapticsBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/11.
//

import SwiftUI

class HapticManager {
    static let instance = HapticManager()//Singleton
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style:UIImpactFeedbackGenerator.FeedbackStyle){
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

struct HapticsBootcamp: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("success") {HapticManager.instance.notification(type: .success)}
            Button("warning") {HapticManager.instance.notification(type: .warning)}
            Button("error") {HapticManager.instance.notification(type: .error)}
            Divider()
            Button("soft"){
                HapticManager().impact(style: .soft)
            }
            Button("light"){
                HapticManager().impact(style: .light)
            }
            Button("medium"){
                HapticManager().impact(style: .medium)
            }
            Button("rigid"){
                HapticManager().impact(style: .rigid)
            }
            Button("heavy"){
                HapticManager().impact(style: .heavy)
            }
        }
    }
}

struct HapticsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        HapticsBootcamp()
    }
}
