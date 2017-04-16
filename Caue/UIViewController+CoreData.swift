//
//  UIViewController+CoreData.swift
//  Caue
//
//  Created by Cauê Almeida on 4/15/17.
//  Copyright © 2017 Usuário Convidado. All rights reserved.
//

import CoreData
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // Acesso ao MOC
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}
