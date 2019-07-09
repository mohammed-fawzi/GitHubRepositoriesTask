//
//  CoreDataManager.swift
//  RepositoriesTask
//
//  Created by mohamed fawzy on 8July//2019.
//  Copyright © 2019 mohamed fawzy. All rights reserved.
//

import Foundation
import CoreData


//Singletone design pattern could cause problems with concurrency better use dependency injection but in case of this app it will be enough
class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RepositoriesTask")
        container.loadPersistentStores { (storeDescription, error) in
            if error != nil {
                fatalError(error!.localizedDescription)
            }
        }
        // this app is not intended to use undo functionality so disable this reduce application resource requirement
        container.viewContext.undoManager = nil
        return container
    } ()
    
    private init() {
    }
    
    
    func save()  {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            }
            catch {
                print("error: ", error)
            }
        }
    }
    
    
}

extension CoreDataManager {
    func fetchAllRepositories() -> [Repository]{
        let request : NSFetchRequest<CDRepository> = CDRepository.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "addedDate", ascending: true)]
        do {
            let cdRepos = try container.viewContext.fetch(request)
            var result = [Repository]()
            for cdRepo in cdRepos {
                let repo = Repository(fromCDRepository: cdRepo)
                result.append(repo)
            }
            return result
            
        }catch {
            print("error", error.localizedDescription)
        }
        return []
    }
    
    func saveRepositories(_ repos: [Repository]) {
        for repo in repos {
            if !isExist(id: repo.id) {
                let cdRepo = CDRepository(context: container.viewContext)
                cdRepo.id = Int64(repo.id)
                cdRepo.name = repo.name
                cdRepo.repoDescription = repo.description
                cdRepo.url = repo.url?.path
                cdRepo.addedDate = Date()
            }else {continue}
        }

        save()
    }
    
    
    func isExist(id: Int) -> Bool {
        let fetchRequest: NSFetchRequest<CDRepository> = CDRepository.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        
        do {
             let res = try container.viewContext.fetch(fetchRequest)
            return res.count > 0 ? true : false
        } catch  {
            return false
        }
        
    }
    

}

