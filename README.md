# DBToolSwift
DBToolSwift是对数据库操作的面向对象的封装，使用Swift runtime机制实现对sqlite的数据库的增、删、改、查等基本操作省去大量时间编写SQL语句

  使用:把DBTool.swift拖入项目中使用即可

    使用
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
    
    //打印
    create sql ->CREATE TABLE IF NOT EXISTS Person(ID INTEGER PRIMARY KEY AUTOINCREMENT,_age TEXT,_name TEXT)
    insert sql ->INSERT INTO Person(_age,_name) VALUES ('19','小明')
    insert sql ->INSERT INTO Person(_age,_name) VALUES ('10','小红')
    insert sql ->INSERT INTO Person(_age,_name) VALUES ('12','小小')
    insert sql ->INSERT INTO Person(_age,_name) VALUES ('23','小黑')
    select sql ->SELECT * FROM Person WHERE  1=1
    [name='小明',age='19']
    [name='小红',age='10']
    [name='小小',age='12']
    [name='小黑',age='23']
    delete sql ->DELETE FROM Person WHERE  _age >= '23' 
    select sql ->SELECT * FROM Person WHERE  1=1
    [name='小明',age='19']
    [name='小红',age='10']
    [name='小小',age='12']
    update sql ->UPDATE Person SET _age = '18' WHERE  _name = '小小' 
    select sql ->SELECT * FROM Person WHERE  1=1
    [name='小明',age='19']
    [name='小红',age='10']
    [name='小小',age='18']
    select sql ->SELECT * FROM Person WHERE  name <= '12'
    [name=小红,age=10]
    drop sql ->DROP TABLE 'Person'

