package io.objectbox.example.sync

import android.content.Context

/**
 * Dependencies container class as recommended by Android
 * ["Manual dependency injection" docs](https://developer.android.com/training/dependency-injection/manual#dependencies-container).
 */
class AppContainer(context: Context) {

    val objectBox = ObjectBox(context)

}