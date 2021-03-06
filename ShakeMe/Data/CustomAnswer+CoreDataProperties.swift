//
//  CustomAnswer+CoreDataClass.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 10/10/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//
//

import CoreData

extension CustomAnswer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomAnswer> {
        return NSFetchRequest<CustomAnswer>(entityName: "CustomAnswer")
    }

    @NSManaged public var date: Date?
    @NSManaged public var identifier: String?
    @NSManaged public var text: String?

    func toAnswer() -> Answer {
        return Answer(text: text ?? "", date: date, identifier: identifier)
    }

    convenience init(text: String, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entity(forEntityName: "CustomAnswer", in: context)!
        self.init(entity: entity, insertInto: context)
        self.text = text
    }

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        date = Date()
        identifier = UUID().uuidString
    }

}
