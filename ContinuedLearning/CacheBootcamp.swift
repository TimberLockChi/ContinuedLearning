//
//  CacheBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/29.
//

import SwiftUI

//缓存管理层
class CacheManager{
    
    static let instance = CacheManager()//单例
    private init(){
        //只能在此类中初始化CacheManger，不能在外部创建新对象
    }
    
    var imageCache: NSCache<NSString,UIImage> = {
        let cache = NSCache<NSString,UIImage>()//必须明确指定缓存的Key和Value
        cache.countLimit = 100 //设置缓存最大可以放置的object数量
        cache.totalCostLimit = 1024 * 1024 * 100 //可以占用的最大缓存空间，如果当前缓存空间被占满，则会清空所有缓存空间并存储新的内容
        return cache
    }()//注意此写法，需要通过闭包来初始化
    
    func add(image:UIImage,name:String)->String{
        imageCache.setObject(image, forKey: name as NSString) //强制类型转换
        return "Add to Cache!"
    }
    
    func remove(name:String)->String{
        imageCache.removeObject(forKey: name as NSString)
        return "Removed from cache!"
    }
    
    func get(name:String) -> UIImage? {
        //不存在可以返回nil
        return imageCache.object(forKey: name as NSString)
    }
    
}

//数据模型层
class CacheViewModel:ObservableObject{
    
    @Published var startingImage : UIImage? = nil
    @Published var cachedImage: UIImage? = nil
    @Published var infoMessage:String = ""
    
    let imageName: String = "dog"
    let manager = CacheManager.instance
    
    init(){
        getImageFromAssetsFolder()
    }
    
    func getImageFromAssetsFolder(){
        startingImage = UIImage(named: imageName)
    }
    
    func saveToCache(){
        guard let image = startingImage else {return}
        infoMessage = manager.add(image: image, name: imageName)
    }
    
    func removeFromCache(){
        infoMessage = manager.remove(name: imageName)
    }
    
    func getFromCache(){
        if let returnImage = manager.get(name: imageName){
            cachedImage = returnImage
            infoMessage = "Got image from Cache"
        }else{
            cachedImage = nil
            infoMessage = "Image not found in Cache"
        }
    }
    
}

struct CacheBootcamp: View {
    
    @StateObject var vm = CacheViewModel()
    
    
    
    var body: some View {
        NavigationView {
            VStack{
                
                if let image = vm.startingImage{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200,height: 200)
                        .clipped()
                        .cornerRadius(10)
                }
                
                Text(vm.infoMessage)
                    .font(.headline)
                    .foregroundColor(.purple)
                
                HStack {
                    Button {
                        vm.saveToCache()
                    } label: {
                        Text("Save Cache")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    Button {
                        vm.removeFromCache()
                    } label: {
                        Text("Delete from Cache")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
                
                Button {
                    vm.getFromCache()
                } label: {
                    Text("Get from Cache")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                
                if let image = vm.cachedImage{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200,height: 200)
                        .clipped()
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .navigationTitle("Cache Bootcamp")
        }
    }
}

struct CacheBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CacheBootcamp()
    }
}
