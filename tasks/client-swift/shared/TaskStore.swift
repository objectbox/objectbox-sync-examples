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
#if os(macOS)
// Experimental mesh sync (peer-to-peer, no server): macOS only, because the local SwiftPM override in
// local-packages/objectbox-swift-spm provides a macOS-only, mesh-enabled ObjectBox framework plus this
// Nearby-based transport add-on. See that directory's README.md.
import ObjectBoxMeshSync
#endif

class TaskStore: ObservableObject {
    
    // Connects to a server running on localhost at port 9999 using an unecrypted connection
    private let serverURL = "ws://127.0.0.1:9999"
    
    private var tasksBox: Box<Task>
    private var tasksBoxObserver: Observer?
#if os(macOS)
    // Must match the mesh ID of the other apps in this example (the Android app uses the same one);
    // nodes with a different mesh ID ignore each other.
    private static let meshId = "io.objectbox.example.sync.tasks"
    private var meshLogTimer: Timer?
#endif
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
    
    class MyChangeListener: SyncChangeListener {
        var logger: Logger
        
        init(logger: Logger) {
            self.logger = logger
        }
        
        func changed(_ changes: [obx_schema_id : SyncChange]) {
            for (schemaId, change) in changes {
                logger.info("Received change for entity id \(schemaId): \(change.puts.count) puts, \(change.removals.count) removals")
            }
        }
    }
    
    init() {
        let store = try! Store.createStore()
        tasksBox = store.box(for: Task.self)
        tasksBoxObserver = tasksBox.subscribe(dispatchQueue: .main) {
            updatedTasks,
            error in
            self.tasks = updatedTasks.reversed()
        }

        let configuration = Sync.Configuration(store: store, url: serverURL)
        configuration.credentials = [SyncCredentials.makeNone()]

#if os(macOS)
        // Attach a peer-to-peer mesh sync over Google Nearby, restricted to Wi-Fi LAN (no Bluetooth).
        // The server at serverURL stays unreachable on purpose, so anything that arrives here came in
        // over the mesh. The mesh starts and stops together with the sync client.
        configuration.mesh = try! AppleMeshSync.createConfig(meshId: Self.meshId, mediums: [.wifiLAN])
#endif

        let client = try! Sync.makeClient(configuration: configuration)
        try! client.start()

        client.connectionListener = MyConnectionListener(logger: logger)
        client.changeListener = MyChangeListener(logger: logger)

#if os(macOS)
        startMeshLogging(client: client)
#endif
    }

#if os(macOS)
    /// Logs the mesh state, connected peers and a few counters every 5 seconds; all messages are
    /// prefixed with "Mesh:" (and logged publicly) so they can be filtered in Console/`log show`.
    private func startMeshLogging(client: SyncClient) {
        guard let mesh = client.mesh else {
            logger.error("Mesh: no mesh attached to the sync client")
            return
        }
        logger.info("Mesh: started, meshId=\(Self.meshId, privacy: .public)")
        let timer = Timer(timeInterval: 5, repeats: true) { [logger] _ in
            let peers = mesh.connectedPeerCount
            let discovered = (try? mesh.statsValue(.peersDiscovered)) ?? 0
            let sent = (try? mesh.statsValue(.txLogsSent)) ?? 0
            let applied = (try? mesh.statsValue(.txLogsApplied)) ?? 0
            logger.info("Mesh: state=\(mesh.stateString, privacy: .public) peers=\(peers, privacy: .public) peersDiscovered=\(discovered, privacy: .public) txLogsSent=\(sent, privacy: .public) txLogsApplied=\(applied, privacy: .public)")
        }
        RunLoop.main.add(timer, forMode: .common)
        meshLogTimer = timer
    }
#endif
    
    func putTask(task: Task) {
        logger.info("Adding task: \(task)")
        try! tasksBox.put(task)
    }
    
    func removeTask(task: Task) {
        logger.info("Removing task: \(task)")
        try! tasksBox.remove(task.id)
    }
    
    func changeTaskStatus(task: Task, isDone: Bool) {
        task.isDone = isDone
        try! tasksBox.put(task)
        logger.info("Changed task isDone to \(isDone): \(task)")
    }
    
    deinit {
        tasksBoxObserver = nil
#if os(macOS)
        meshLogTimer?.invalidate()
#endif
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
