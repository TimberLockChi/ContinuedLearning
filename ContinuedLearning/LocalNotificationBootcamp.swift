//
//  LocalNotificationBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/11.
//

import SwiftUI
import UserNotifications
import CoreLocation


class NotificationManager{
    static let instance = NotificationManager()//Singleton
    
    func requestAuthorization(){
        let options: UNAuthorizationOptions = [.alert,.sound,.badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) {(success,error) in
            if let error = error{
                print("Error:\(error)")
            }else{
                print("Success:\(success)")
            }
        }
    }
    
    func scheduleNotification(){
        let content = UNMutableNotificationContent()
        content.title = "This is my first notification"
        content.subtitle = "This was so easy!"
        content.sound = .default
        content.badge = 1//标记，app右上角显示数字，应该需要自增
        
        
        //time
        let trigerTime = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)//timeInterval请求后的时间延时
        //calender
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 10
        dateComponents.weekday = 6//设置星期几
        let trigerCal = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)//根据dateComponents设定的时间触发提醒
        //location
        let coordinates = CLLocationCoordinate2D(
            latitude: 40.00, longitude: 50.00
        )
        let region = CLCircularRegion(
            center: coordinates,//中心
            radius: 100,//半径
            identifier: UUID().uuidString
        )
        
        region.notifyOnExit = false//离开区域范围提示
        region.notifyOnEntry = true//进入区域范围提示
        
        let triggerLoc = UNLocationNotificationTrigger(region: region, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: triggerLoc)
        
        UNUserNotificationCenter.current().add(request)//发出请求
    }
    
    func cancleNotification(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()//去除还未执行的请求
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()//去除已经送达的请求
    }
    
}


struct LocalNotificationBootcamp: View {
    var body: some View {
        VStack(spacing: 40){
            Button("Request permission"){
                NotificationManager.instance.requestAuthorization()
            }
            Button("Request notification"){
                NotificationManager.instance.scheduleNotification()
            }
            Button("Cancle notification"){
                NotificationManager.instance.cancleNotification()
            }
        }
        .onAppear{
            UIApplication.shared.applicationIconBadgeNumber = 0//清除未读
        }
    }
}

struct LocalNotificationBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        LocalNotificationBootcamp()
    }
}
