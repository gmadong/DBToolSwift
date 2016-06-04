//
//  AppDelegate.swift
//  DBToolSwift
//
//  Created by caodong on 16/6/3.
//  Copyright © 2016年 caodong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {

        let tool:DBTool = DBTool.shareDBTool()
        tool .createTable(Person.self)
        let p:Person = Person(name: "小明",age: 19)
        tool .insertObj(p)
        let p1:Person = Person(name: "小红",age: 10)
        tool .insertObj(p1)
        let p2:Person = Person(name: "小小",age: 12)
        tool .insertObj(p2)
        let p3:Person = Person(name: "小黑",age: 23)
        tool .insertObj(p3)
        
        var persons:NSArray = tool .selectAll(Person.self);
        for p in persons
        {
            print((p as! Person).description)
        }
        
        tool .deleteRecord(Person.self, key: "age", isGreaterEqualValue: "23")
        persons = tool .selectAll(Person.self);
        for p in persons
        {
            print((p as! Person).description)
        }
        
        p2.age = 18
        tool .update(p2, key: "name", isEqualValue: "小小")
        persons = tool .selectAll(Person.self);
        for p in persons
        {
            print((p as! Person).description)
        }
        
        persons = tool .select(Person.self, key: "age", isLessEqualValue: "12")
        for p in persons
        {
            print((p as! Person).description)
        }
        
        tool .dropTable(Person.self)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

