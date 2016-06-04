//
//  DBTool.swift
//  DBToolSwift
//
//  Created by caodong on 16/6/4.
//  Copyright © 2016年 caodong. All rights reserved.
//

import Foundation

let DBNAME = "db.data";

let instance = DBTool()

class DBTool
{
    
    var db:COpaquePointer = nil
    
    /**
     得到工具类对象
     
     - returns: 工具类对象
     */
    class func shareDBTool() -> DBTool
    {
        return instance;
    }
    /**
     打开数据库
     
     - returns: true 打开成功 false 打开失败
     */
    private func openDB()->Bool
    {
        let paths:[String] =  NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        let path = "\(paths[0])/\(DBNAME)";
//        print("db path = \(path)");
        if sqlite3_open(path.cStringUsingEncoding(NSUTF8StringEncoding)!, &db) != SQLITE_OK
        {
            sqlite3_close(db)
            //print("打开失败")
            return false
        }
        //print("打开成功")
        return true
    }
    /**
     执行sql
     
     - returns: true 执行成功 false 执行失败
     */
    private func execSql(sql:String)->Bool
    {
        
        if openDB()
        {
            if sqlite3_exec(db, sql.cStringUsingEncoding(NSUTF8StringEncoding)!, nil, nil, nil) == SQLITE_OK
            {
                sqlite3_close(db);
               // print("执行成功")
                return true
            }
        }
        sqlite3_close(db)
        //print("执行失败")
        return false
    }
    /**
     得到表名
     
     - parameter cls: 实体类class
     
     - returns: 表名
     */
    private func getTableName(cls: AnyClass!)->String
    {
        let tableNameChar = class_getName(cls)
        let tableName:String = String.fromCString(tableNameChar)!
        let range:Range? = tableName.rangeOfString(".")
        if (range != nil)
        {
            return tableName.substringFromIndex(range!.endIndex)
        }
        return tableName
    }
    /**
     创建表
     
     - parameter cls: 实体类class
     */
    func createTable(cls: AnyClass!)
    {
        var sql:String = "CREATE TABLE IF NOT EXISTS "
        sql = sql.stringByAppendingString(self.getTableName(cls))
        sql = sql.stringByAppendingString("(ID INTEGER PRIMARY KEY AUTOINCREMENT,")
        var count: UInt32 = 0
        let ivars = class_copyIvarList(Person.self, &count)
        
        for i in 0 ..< Int(count)
        {
            let ivar = ivars[i]
            let name = ivar_getName(ivar);
            let strName = String.fromCString(name);
            sql = sql.stringByAppendingString("_\(strName!) TEXT")
            if i != (Int(count) - 1)
            {
               sql = sql.stringByAppendingString(",")
            }
        }
        free(ivars)
        sql = sql.stringByAppendingString(")")
        self .execSql(sql)
        print("create sql ->\(sql)")
    }
    
    /**
     删除表
     
     - parameter cls: 实体类class
     */
    func dropTable(cls:AnyClass!)
    {
        let sql:String = "DROP TABLE \(self.getTableName(cls))"
        self .execSql(sql)
        print("drop sql -> \(sql)")
        
    }
    /**
     删除记录
     
     - parameter cls:    实体类class
     - parameter params: 条件
     */
    func deleteRecord(cls:AnyClass!,params:String?)
    {
        var params = params;
        if (params==nil)
        {
            params = " 1=1"
        }
        let sql:String = "DELETE FROM \(self.getTableName(cls)) WHERE \(params!)"
        self .execSql(sql)
        print("delete sql ->\(sql)")
     
    }
    /**
     删除全部记录
     
     - parameter cls: 实体类class
     */
    func deleteRecordAll(cls:AnyClass!)
    {
        self .deleteRecord(cls, params: nil)
    }
    /**
     删除记录(相等)
     
     - parameter cls:      实体类class
     - parameter ivarName: 实体对象属性名
     - parameter value:    对应值
     */
    func deleteRecord(cls:AnyClass!,key ivarName:String?,isEqualValue value:String)
    {
        var params = "";
        if ivarName==nil
        {
            params = " 1=1"
        }
        else
        {
            params = " _\(ivarName!)=\(value)";
        }
        self .deleteRecord(cls, params: params)
    }
    /**
     删除记录(大于)
     
     - parameter cls:      实体类class
     - parameter ivarName: 实体对象属性名
     - parameter value:    对应值
     */
    func deleteRecord(cls:AnyClass!,key ivarName:String?,isGreaterValue value:String)
    {
        var params = "";
        if ivarName==nil
        {
            params = " 1=1"
        }
        else
        {
            params = " _\(ivarName!)>\(value)";
        }
        self .deleteRecord(cls, params: params)
    }
    /**
     删除记录(大于等于)
     
     - parameter cls:      实体类class
     - parameter ivarName: 实体对象属性名
     - parameter value:    对应值
     */
    func deleteRecord(cls:AnyClass!,key ivarName:String?,isGreaterEqualValue value:String)
    {
        var params = "";
        if ivarName==nil
        {
            params = " 1=1"
        }
        else
        {
            params = " _\(ivarName!)>=\(value)";
        }
        self .deleteRecord(cls, params: params)
    }
    /**
     删除记录(小于)
     
     - parameter cls:      实体类class
     - parameter ivarName: 实体对象属性名
     - parameter value:    对应值
     */
    func deleteRecord(cls:AnyClass!,key ivarName:String?,isLessValue value:String)
    {
        var params = "";
        if ivarName==nil
        {
            params = " 1=1"
        }
        else
        {
            params = " _\(ivarName!)<\(value)";
        }
        self .deleteRecord(cls, params: params)
    }
    /**
     删除记录(小于等于)
     
     - parameter cls:      实体类class
     - parameter ivarName: 实体对象属性名
     - parameter value:    对应值
     */
    func deleteRecord(cls:AnyClass!,key ivarName:String?,isLessEqualValue value:String)
    {
        var params = "";
        if ivarName==nil
        {
            params = " 1=1"
        }
        else
        {
            params = " _\(ivarName!)<=\(value)";
        }
        self .deleteRecord(cls, params: params)
    }
    /**
     删除记录(like)
     
     - parameter cls:      实体类class
     - parameter ivarName: 实体对象属性名
     - parameter value:    对应值(自己加对应%)
     */
    func deleteRecord(cls:AnyClass!,key ivarName:String?,isLikeValue value:String)
    {
        var params = "";
        if ivarName==nil
        {
            params = " 1=1"
        }
        else
        {
            params = " _\(ivarName!)  LIKE  \(value)";
        }
        self .deleteRecord(cls, params: params)
    }
    /**
     查询数据 当params=nil时查询全部
     
     - parameter cls:    实体类class
     - parameter params: 条件
     
     - returns: 查询列表
     */
    func select(cls:AnyClass!,params:String?) -> NSArray
    {
        var params = params;
        if (params==nil)
        {
            params = " 1=1"
        }
        let sql:String = "SELECT * FROM \(self.getTableName(cls)) WHERE \(params!)"
         print("select sql ->\(sql)")
        let data:NSMutableArray = NSMutableArray()
        if openDB()
        {
            var statement:COpaquePointer = nil
           if sqlite3_prepare_v2(db, sql.cStringUsingEncoding(NSUTF8StringEncoding)!, -1, &statement, nil) == SQLITE_OK
           {
               var count: UInt32 = 0
               let ivars = class_copyIvarList(Person.self, &count)
            
               while sqlite3_step(statement) == SQLITE_ROW
               {
                  let obj = cls.alloc()
                
                   for i in 1 ..< Int(count+1)
                   {
                        let ivar = ivars[i-1]
                        let name = ivar_getName(ivar);
                        let strName = String.fromCString(name);
                    
                        let value:UnsafePointer<UInt8> = sqlite3_column_text(statement, Int32(i))
                        let valueStr = String.fromCString(UnsafePointer<CChar>(value))
                        obj .setValue(valueStr, forKeyPath: strName!)
                    
                    }
                   data.addObject(obj)
                
               }
               free(ivars)
            
           }
            sqlite3_close(db);
            sqlite3_finalize(statement);

        }
        return data
    }
    /**
     查询全部数据
     
     - parameter cls: 实体类class
     
     - returns: 查询列表
     */
    func selectAll(cls:AnyClass!) -> NSArray
    {
       return self .select(cls, params: nil);
    }
    /**
     查询数据( 相等)
     
     - parameter cls:      实体类class
     - parameter ivarName: 实体对象属性名
     - parameter value:    对应值
     
     - returns: 查询列表
     */
    func select(cls:AnyClass!,key ivarName:String?,isEqualValue value:String) -> NSArray
    {
        var params = "";
        if ivarName==nil
        {
            params = " 1=1"
        }
        else
        {
            params = " _\(ivarName!)  =  \(value)";
        }

        return self.select(cls, params: params)
    }
    /**
     查询数据( 大于)
     
     - parameter cls:      实体类class
     - parameter ivarName: 实体对象属性名
     - parameter value:    对应值
     
     - returns: 查询列表
     */
    func select(cls:AnyClass!,key ivarName:String?,isGreaterValue value:String) -> NSArray
    {
        var params = "";
        if ivarName==nil
        {
            params = " 1=1"
        }
        else
        {
            params = " _\(ivarName!)  >  \(value)";
        }
        
        return self.select(cls, params: params)
    }
    /**
     查询数据( 大于等于)
     
     - parameter cls:      实体类class
     - parameter ivarName: 实体对象属性名
     - parameter value:    对应值
     
     - returns: 查询列表
     */
    func select(cls:AnyClass!,key ivarName:String?,isGreaterEqualValue value:String) -> NSArray
    {
        var params = "";
        if ivarName==nil
        {
            params = " 1=1"
        }
        else
        {
            params = " _\(ivarName!)  >=  \(value)";
        }
        
        return self.select(cls, params: params)
    }
    /**
     查询数据(小于)
     
     - parameter cls:      实体类class
     - parameter ivarName: 实体对象属性名
     - parameter value:    对应值
     
     - returns: 查询列表
     */
    func select(cls:AnyClass!,key ivarName:String?,isLessValue value:String) -> NSArray
    {
        var params = "";
        if ivarName==nil
        {
            params = " 1=1"
        }
        else
        {
            params = " _\(ivarName!)  <  \(value)";
        }
        
        return self.select(cls, params: params)
    }
    /**
     查询数据(小于等于)
     
     - parameter cls:      实体类class
     - parameter ivarName: 实体对象属性名
     - parameter value:    对应值
     
     - returns: 查询列表
     */
    func select(cls:AnyClass!,key ivarName:String?,isLessEqualValue value:String) -> NSArray
    {
        var params = "";
        if ivarName==nil
        {
            params = " 1=1"
        }
        else
        {
            params = " _\(ivarName!)  <=  \(value)";
        }
        
        return self.select(cls, params: params)
    }
    /**
     查询数据(Like)
     
     - parameter cls:      实体类class
     - parameter ivarName: 实体对象属性名
     - parameter value:    对应值(自己加%)
     
     - returns: 查询列表
     */
    func select(cls:AnyClass!,key ivarName:String?,isLikeValue value:String) -> NSArray
    {
        var params = "";
        if ivarName==nil
        {
            params = " 1=1"
        }
        else
        {
            params = " _\(ivarName!)  LIKE  \(value)";
        }
        
        return self.select(cls, params: params)
    }
    /**
     插入一条记录
     
     - parameter obj: 实体对象
     */
    func insertObj(obj:NSObject)
    {
        var sql = "INSERT INTO \(self.getTableName(obj.classForKeyedArchiver))("
        var sqlValues = "("
        
        var count: UInt32 = 0
        let ivars = class_copyIvarList(Person.self, &count)
        
        for i in 0 ..< Int(count)
        {
            let ivar = ivars[i]
            let name = ivar_getName(ivar);
            let strName = String.fromCString(name);
            sql = sql.stringByAppendingString("_\(strName!)")
            sqlValues = sqlValues.stringByAppendingString("'\(obj.valueForKeyPath(strName!)!)'")
            
            if i != (Int(count) - 1)
            {
                sql = sql.stringByAppendingString(",")
                sqlValues = sqlValues.stringByAppendingString(",")
            }
        }
        free(ivars)
        sql = "\(sql)) VALUES \(sqlValues))"
        print("insert sql ->\(sql)")
        self.execSql(sql)
        
    }
    /**
     更新一条记录
     
     - parameter obj:      实体对象
     - parameter ivarName: 实体对象属性名
     - parameter value:    条件值
     */
    func update(obj:NSObject,key ivarName:String?,isEqualValue value:String)
    {
        var sql:String = "UPDATE \(self.getTableName(obj.classForKeyedArchiver)) SET "
        var count: UInt32 = 0
        let ivars = class_copyIvarList(Person.self, &count)
        
        for i in 0 ..< Int(count)
        {
            let ivar = ivars[i]
            let name = ivar_getName(ivar);
            let strName = String.fromCString(name);
            if ivarName != strName
            {
                sql = sql.stringByAppendingString("_\(strName!) = '\(obj.valueForKeyPath(strName!)!)'")
                sql = sql.stringByAppendingString(" ,")
            }
        }
        free(ivars)
        sql = (sql as NSString).substringToIndex((sql as NSString).length-1)
        var params = "";
        if ivarName==nil
        {
            params = " 1=1"
        }
        else
        {
            params = " _\(ivarName!) = '\(value)'";
        }
        sql = "\(sql) WHERE \(params)"
        print("insert sql ->\(sql)")
        self.execSql(sql)
    }

}


        