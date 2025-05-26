package com.thinksys.habit_tracker

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.util.Log
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import androidx.core.content.ContextCompat
import com.google.gson.Gson
import java.util.*

internal class ListRemoteViewsFactory(context: Context, intent: Intent) :
    RemoteViewsService.RemoteViewsFactory {
    //    private val mWidgetItems: MutableList<String> = ArrayList<String>()
    private val mContext: Context
    private val mAppWidgetId: Int
    private var model: HabitsModel

    init {
        mContext = context
        mAppWidgetId = intent.getIntExtra(
            AppWidgetManager.EXTRA_APPWIDGET_ID,
            AppWidgetManager.INVALID_APPWIDGET_ID
        )
        val habitsList = intent.getStringExtra("habits_list")
        model = Gson().fromJson<HabitsModel>(habitsList.toString(), HabitsModel::class.java)
//        Log.d("HABITSWIDGET habits", habitsList.toString());
    }

    // Initialize the data set.
    override fun onCreate() {

        // In onCreate() you setup any connections / cursors to your data source. Heavy lifting,
        // for example downloading or creating content etc, should be deferred to onDataSetChanged()
        // or getViewAt(). Taking more than 20 seconds in this call will result in an ANR.
//        for (i in model) {
//            mWidgetItems.add("Item ${i.habitName}")
//        }
        // We sleep for 3 seconds here to show how the empty view appears in the interim.
        // The empty view is set in the ListWidgetProvider and should be a sibling of the
        // collection view.
//        try {
//            Thread.sleep(3000)
//        } catch (e: InterruptedException) {
//            e.printStackTrace()
//        }
    }

    override fun onDestroy() {
        // In onDestroy() you should tear down anything that was setup for your data source,
        // eg. cursors, connections, etc.
        model.clear()
    }


    // Given the position (index) of a WidgetItem in the array, use the item's text value in
    // combination with the app widget item XML file to construct a RemoteViews object.
    override fun getViewAt(position: Int): RemoteViews {

        val rv = RemoteViews(mContext.packageName, R.layout.habitica_widget_item)
        val stringColorCode = model[position].habitColor.toString()
        Log.d("HabitsColor" ,stringColorCode)
        try {
            val longValue = stringColorCode.toLong()
            rv.setInt(R.id.habit_item, "setBackgroundColor", longValue.toInt())

        } catch (e: NumberFormatException) {
            // Handle the case where the string cannot be converted to a Long
            e.printStackTrace()
        }

//        rv.setInt(
//            R.id.habit_item,
//            "setBackgroundColor",
//            mContext.resources.getColor(R.color.light_blue_600)
//        );

        rv.setTextViewText(R.id.habit_name, model[position].habitName)
        rv.setTextViewText(
            R.id.habit_value,
            "${model[position].habitCompletedValue ?: 0}/${model[position].goal.toString()} ${model[position].goalUnit}"
        )

        // Next, we set a fill-intent which will be used to fill-in the pending intent template
        // which is set on the collection view in ListWidgetProvider.
        val extras = Bundle()
        extras.putInt(HabiticaWidget.EXTRA_ITEM, position)
        val fillInIntent = Intent()
        fillInIntent.putExtras(extras)
        // Make it possible to distinguish the individual on-click
        // action of a given item
        rv.setOnClickFillInIntent(R.id.habit_name, fillInIntent)

        // You can do heaving lifting in here, synchronously. For example, if you need to
        // process an image, fetch something from the network, etc., it is ok to do it here,
        // synchronously. A loading view will show up in lieu of the actual contents in the
        // interim.
//        try {
//            Log.d("Loading view", position.toString())
//            Thread.sleep(500)
//        } catch (e: InterruptedException) {
//            e.printStackTrace()
//        }

        // Return the remote views object.
        return rv
    }

    override fun getCount(): Int {
        return model.size
    }


    // You can create a custom loading view (for instance when getViewAt() is slow.) If you
    // return null here, you will get the default loading view.
    override fun getLoadingView(): RemoteViews? {
        // You can create a custom loading view (for instance when getViewAt() is slow.) If you
        // return null here, you will get the default loading view.
        //TODO: implement loader
        return null;
    }

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun hasStableIds(): Boolean {
        return true
    }

    override fun onDataSetChanged() {
        // This is triggered when you call AppWidgetManager notifyAppWidgetViewDataChanged
        // on the collection view corresponding to this factory. You can do heaving lifting in
        // here, synchronously. For example, if you need to process an image, fetch something
        // from the network, etc., it is ok to do it here, synchronously. The widget will remain
        // in its current state while work is being done here, so you don't need to worry about
        // locking up the widget.
    }

    private fun getClipPercentageForPosition(position: Int): Double {
        // Implement your logic to generate a dynamic clip percentage based on position
        // For example, you can use a list of percentages or generate percentages dynamically.
        // Here, I'm using a simple example with alternating clip percentages.
        return if (position % 2 == 0) {
            0.5
        } else {
            0.2
        }
    }
    private fun getDynamicColorForPosition(position: Int): Int {
        // Implement your logic to generate a dynamic color based on position
        // For example, you can use a list of colors or generate colors dynamically.
        // Here, I'm using a simple example with alternating colors.
        return if (position % 2 == 0) {
            ContextCompat.getColor(mContext, R.color.light_blue_600)
        } else {
            ContextCompat.getColor(mContext, R.color.light_blue_900)
        }
    }
}