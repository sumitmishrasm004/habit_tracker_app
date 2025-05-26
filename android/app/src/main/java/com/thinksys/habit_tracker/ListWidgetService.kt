package com.thinksys.habit_tracker

import android.content.Intent
import android.widget.RemoteViewsService


class ListWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent?): RemoteViewsFactory {
        return ListRemoteViewsFactory(applicationContext, intent!!)
    }

}