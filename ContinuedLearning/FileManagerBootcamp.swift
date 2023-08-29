//
//  FileManagerBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/29.
//

import SwiftUI

class LocalFileManager{
    static let instance = LocalFileManager()
    let folderName = "MyApp_Images"
    init(){
        createFolderIfNeeded()
    }
    
    func createFolderIfNeeded(){
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path else{
            return
        }
        if !FileManager.default.fileExists(atPath: path){
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true,attributes: nil)
                print("Success creating folder.")
            } catch let error {
                print("Error creating folder.\(error)")
            }
        }
    }
    
    func deleteFolder(){
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path else{
            return
        }
        do {
            try FileManager.default.removeItem(atPath: path)
            print("Success deleting folder")
        } catch let error {
            print("Error deleting folder. \(error)")
        }
    }
    
    func saveImage(image:UIImage,name:String)->String{
        //根据图片格式可以对其进行存储（压缩操作）
        guard
            let data = image.jpegData(compressionQuality: 1.0),//获取图片数据，可以设置压缩质量
            let path = getPathForImage(name: name)
        else{
            return "Error getting data."
            
        }
        //IOS数据存储规则https://developer.apple.com/documentation/foundation/optimizing_your_app_s_data_for_icloud_backup/
//        let directory_doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)//存储核心数据，该数据可能只能通过用户产生，无法通过应用产生,返回的是一个数组路径
//        let directory_cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)//存储缓存数据，该数据可以由应用生成或者从网络下载，返回的是一个数组路径
//        let directory_tmp = FileManager.default.temporaryDirectory//存储临时数据，该数据只是被临时应用
        do {
            try data.write(to: path)
            print(path)
            return "Success saving"
        }catch let error{
            return "Error saving. \(error)"
        }
    }
    
    func getImage(name:String)->UIImage? {
        guard
            //判断文件是否存在
            let path = getPathForImage(name: name)?.path,
            FileManager.default.fileExists(atPath: path)
        else{
            print("Error getting path.")
            return nil
        }
        return UIImage(contentsOfFile: path)
    }
    
    
    func deleteImage(name:String)->String{
        guard
            let path = getPathForImage(name: name),
            FileManager.default.fileExists(atPath: path.path)
        else{
            return "Error getting path."
            
        }
        
        do{
            //删除图片
            try FileManager.default.removeItem(at: path)
            return "Successfully deleted"
        }catch let error{
            return "Error deleting image.\(error)"
        }
    }
    
    
    func getPathForImage(name:String)->URL?{
        //取路径数组中的第一个元素
        guard
            let path = FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
            .appendingPathComponent(("\(name).jpg"))
            else {
                print("Error getting path.")
                return nil
            }
        return path
    }
}

class FileManagerViewModel:ObservableObject{
    
    @Published var image: UIImage? = nil
    let imageName: String = "dog"
    let manager = LocalFileManager.instance
    @Published var infoMessage:String = ""
    init(){
        getImageFromAssetsFolder()
        //getImageFromFileManager()
    }
    
    func getImageFromFileManager(){
        image = manager.getImage(name: imageName)
    }
    
    func getImageFromAssetsFolder(){
        image = UIImage(named: imageName)
    }
    
    func saveImage(){
        guard let image = image else{return}
        infoMessage = manager.saveImage(image: image, name: imageName)
    }
    func deleteImage(){
        infoMessage = manager.deleteImage(name: imageName)
        manager.deleteFolder()
    }
}

struct FileManagerBootcamp: View {
    
    @StateObject var vm = FileManagerViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = vm.image{
                    Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200,height: 200)
                    .clipped()
                    .cornerRadius(10)
                }
                HStack{
                    Button {
                        vm.saveImage()
                    } label: {
                        Text("Save to FM")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .padding(.horizontal)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        vm.deleteImage()
                    } label: {
                        Text("Delete from FM")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .padding(.horizontal)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
                Text(vm.infoMessage)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.purple)
                Spacer()
            }
            .navigationTitle("Filr Manager")
        }
    }
}

struct FileManagerBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        FileManagerBootcamp()
    }
}
