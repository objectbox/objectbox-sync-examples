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

import SwiftUI

struct TasksListItem: View {
    var taskText: String
    var isDone: Bool
    let onDelete: () -> Void
    let onTaskStatusChange: (Bool) -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                onTaskStatusChange(!isDone)
            }) {
                Image(systemName: isDone ? "checkmark.square" : "square")
            }
            .buttonStyle(BorderlessButtonStyle())
            Text(taskText)
            Spacer()
            Button(action: onDelete) {
                Image(systemName: "trash")
                .foregroundColor(.red)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var task = Task.sampleData[0]
    TasksListItem(
        taskText: task.text,
        isDone: task.isDone,
        onDelete: {},
        onTaskStatusChange: { isDone in }
    )
}
