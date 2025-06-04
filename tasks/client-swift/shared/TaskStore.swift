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
import os

class TaskStore: ObservableObject {
    
    private var tasksBox: Box<Task>
    private var tasksBoxObserver: Observer?
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: TaskStore.self)
    )

    @Published var tasks: [Task] = []
    
    class MyConnectionListener: SyncConnectionListener {
        var logger: Logger
        
        init(logger: Logger) {
            self.logger = logger
        }
        
        func connected() {
            logger.info("Client connected to Sync server")
        }
        
        func disconnected() {
            logger.info("Client disconnected from Sync server")
        }
    }
    
    init() {
        let store = try! Store.createStore()
        tasksBox = store.box(for: Task.self)
        tasksBoxObserver = tasksBox.subscribe(dispatchQueue: .main) { updatedTasks, error in
            self.tasks = updatedTasks.reversed()
        }
        let client = try! Sync.makeClient(
            store: store,
            urlString: "ws://127.0.0.1:9999",
            credentials: SyncCredentials.makeNone()
        )
        try! client.start()
        client.connectionListener = MyConnectionListener(logger: logger)
    }
    
    func putTask(task: Task) {
        logger.info("Adding task: \(task)")
        try! tasksBox.put(task)
    }
    
    func removeTask(task: Task) {
        logger.info("Removing task: \(task)")
        try! tasksBox.remove(task.id)
    }
    
    func changeTaskStatus(task: Task, isDone: Bool) {
        logger.info("Changing task status from \(task.isDone) to \(isDone) for \(task)")
        task.isDone = isDone
        try! tasksBox.put(task)
    }
    
    deinit {
        tasksBoxObserver = nil
    }
}


extension Store {
    static func createStore() throws -> Store {
        let databaseName = "tasks"
        let appSupport = try FileManager.default.url(for: .applicationSupportDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true)
            .appendingPathComponent(Bundle.main.bundleIdentifier!)
        let directory = appSupport.appendingPathComponent(databaseName)
        try? FileManager.default.createDirectory(at: directory,
                                                 withIntermediateDirectories: true,
                                                 attributes: nil)
        return try Store(directoryPath: directory.path)
    }
}
