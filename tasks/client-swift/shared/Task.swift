/*
 * Copyright 2024 ObjectBox Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import ObjectBox
import Foundation

// objectbox: entity , sync
class Task: Identifiable, CustomStringConvertible {
    var id: Id = 0
    var text: String = ""
    var dateCreated: Date?
    var dateFinished: Date?
    var isDone: Bool {
        get {
            return dateFinished != nil && dateFinished?.timeIntervalSince1970 != 0
        }
        set {
            if (newValue) {
                dateFinished = Date()
            } else {
                dateFinished = Date(timeIntervalSince1970: 0)
            }
        }
    }
    
    var description: String {
        return "Task(id: \(id), text: \(text), dateCreated: \(String(describing: dateCreated)), dateFinished: \(String(describing: dateFinished)))"
    }
    
    required init() {
    }
    
    init(id: UInt64, text: String) {
        self.id = id
        self.text = text
        self.dateCreated = Date()
        self.dateFinished = Date(timeIntervalSince1970: 0)
    }
}
