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

package io.objectbox.example.sync;

import android.content.Context;
import android.util.Log;

import java.util.Arrays;
import java.util.List;

import androidx.annotation.NonNull;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import io.objectbox.Box;
import io.objectbox.BoxStore;
import io.objectbox.BoxStoreBuilder;
import io.objectbox.android.Admin;
import io.objectbox.config.ValidateOnOpenModePages;
import io.objectbox.exception.FileCorruptException;
import io.objectbox.query.QueryBuilder;
import io.objectbox.sync.Sync;
import io.objectbox.sync.SyncChange;
import io.objectbox.sync.SyncCredentials;
import io.objectbox.sync.listener.SyncLoginListener;

/**
 * Keeps BoxStore reference and provides current list of Task objects.
 */
public class ObjectBox {

    private static final String SYNC_SERVER_URL = "ws://10.0.2.2";

    private static ObjectBox instance;

    private BoxStore boxStore;
    private Box<Task> taskBox;

    private final MutableLiveData<List<SyncChange>> syncChangesLiveData = new MutableLiveData<>();

    void init(Context context) {
        BoxStoreBuilder storeBuilder = MyObjectBox.builder()
                .name("tasks-synced")
                .validateOnOpen(ValidateOnOpenModePages.WithLeaves)  // Additional DB page validation
                .validateOnOpenPageLimit(20)
                .androidContext(context.getApplicationContext());
        try {
            boxStore = storeBuilder.build();
        } catch (FileCorruptException e) { // Demonstrate handling issues caused by devices with a broken file system
            Log.w(App.TAG, "File corrupt, trying previous data snapshot...", e);
            // Retrying requires ObjectBox 2.7.1+
            storeBuilder.usePreviousCommit();
            boxStore = storeBuilder.build();
        }

        Log.i(App.TAG, "Starting client with: " + SYNC_SERVER_URL);
        SyncLoginListener loginListener = new SyncLoginListener() {
            @Override
            public void onLoggedIn() {
                Log.i(App.TAG, "logged in");
            }

            @Override
            public void onLoginFailed(long syncLoginCode) {

            }
        };

        // Note: given BoxStore keeps a reference to Sync client
        Sync.client(boxStore, SYNC_SERVER_URL, SyncCredentials.none())
                .changeListener(syncChanges -> {
                    Log.i(App.TAG, "Changes: " + syncChanges.length);
                    syncChangesLiveData.postValue(Arrays.asList(syncChanges));
                })
                .loginListener(loginListener)
                .buildAndStart();

        // Enable ObjectBox Admin on debug builds.
        // https://docs.objectbox.io/data-browser
        if (BuildConfig.DEBUG) {
            Log.i(App.TAG, String.format("Using ObjectBox %s (%s)",
                    BoxStore.getVersion(), BoxStore.getVersionNative()));
            new Admin(boxStore).start(context.getApplicationContext());
        }

        taskBox = boxStore.boxFor(Task.class);
    }

    public LiveData<List<Task>> getTasksLiveData(TasksFilter filter) {
        QueryBuilder<Task> builder = taskBox.query();
        switch (filter) {
            case OPEN:
                builder.apply(Task_.dateFinished.equal(0));
                builder.orderDesc(Task_.dateCreated);
                break;
            case DONE:
                builder.apply(Task_.dateFinished.notEqual(0));
                builder.orderDesc(Task_.dateFinished);
                break;
            case ALL:
            default:
                builder.orderDesc(Task_.dateCreated);
                break;
        }
        return new ObjectBoxSyncLiveData<>(builder.build(), syncChangesLiveData);
    }

    public void addTask(String text) {
        taskBox.put(new Task(text));
    }

    public void removeTask(long id) {
        taskBox.remove(id);
    }

    public void changeTaskDone(@NonNull Task task, boolean isDone) {
        task.setDone(isDone);
        taskBox.put(task);
    }

    public static synchronized ObjectBox get() {
        if (instance == null) {
            instance = new ObjectBox();
        }
        return instance;
    }
}
