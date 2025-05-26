package com.thinksys.habit_tracker

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.net.Uri
import android.util.Log
import android.widget.RemoteViews
import com.google.gson.Gson
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of App Widget functionality.
 */
class HabiticaWidget : AppWidgetProvider() {
    companion object{
        val EXTRA_ITEM = "com.example.android.stackwidget.EXTRA_ITEM"

    }
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
//        // There may be multiple widgets active, so update all of them
//        for (appWidgetId in appWidgetIds) {
//            updateAppWidget(context, appWidgetManager, appWidgetId)
//        }

        updateAppWidget(context, appWidgetManager, appWidgetIds)

    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
        Log.d("HABITSWIDGET", "onEnabled");
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
        Log.d("HABITSWIDGET", "onDisabled");
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        super.onReceive(context, intent)
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: IntArray
) {
    // Get reference to SharedPreferences
    val widgetData = HomeWidgetPlugin.getData(context)
    val habitsList = widgetData.getString("habits_list", "")
//    val model: HabitsModel = Gson().fromJson<HabitsModel>(habitsList.toString(), HabitsModel::class.java)
//    Log.d("HABITSWIDGET value", model[0].habitName.toString());

    //------------------------------------------------------------

    // There may be multiple widgets active, so update all of them
    // update each of the widgets with the remote adapter
    for (widgetId in appWidgetId) {
        // Here we setup the intent which points to the StackViewService which will
        // provide the views for this collection.
        val intent = Intent(context, ListWidgetService::class.java)
        intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)

        // When intents are compared, the extras are ignored, so we need to embed the extras
        // into the data so that the extras will not be ignored.
        intent.setData(Uri.parse(intent.toUri(Intent.URI_INTENT_SCHEME)))
        intent.putExtra("habits_list", habitsList.toString())

        // Construct the RemoteViews object
        val views = RemoteViews(context.packageName, R.layout.habitica_widget)
        views.setRemoteAdapter(R.id.habit_listview, intent)


        // The empty view is displayed when the collection has no items. It should be a sibling
        // of the collection view.
        views.setEmptyView(R.id.habit_listview, R.id.empty_view)

        // This section makes it possible for items to have individualized behavior.
        // It does this by setting up a pending intent template. Individuals items of a collection
        // cannot set up their own pending intents. Instead, the collection as a whole sets
        // up a pending intent template, and the individual items set a fillInIntent
        // to create unique behavior on an item-by-item basis.
        val toastIntent = Intent(context,  ListWidgetService::class.java)

        // Set the action for the intent.
        // When the user touches a particular view, it will have the effect of
        // broadcasting TOAST_ACTION.
       // toastIntent.setAction(ListWidgetService.TOAST_ACTION)
        toastIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
        intent.setData(Uri.parse(intent.toUri(Intent.URI_INTENT_SCHEME)))
        val toastPendingIntent: PendingIntent = PendingIntent.getBroadcast(
            context, 0, toastIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setPendingIntentTemplate(R.id.habit_listview, toastPendingIntent)

        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}
