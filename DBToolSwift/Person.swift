//
//  Person.swift
//  DBToolSwift
//
//  Created by caodong on 16/6/3.
//  Copyright © 2016年 caodong. All rights reserved.
//

import Foundation
import UIKit

class Person :NSObject
{
    var name:String = ""
    var age:Int = 1

    init(name:String,age:Int)
    {
        self.name = name
        self.age = age
    }
    override var description: String
    {
        return "[name=\(self.name),age=\(self.age)]"
    }

}





