package com.bingo.widgetshot

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.RectF
import java.io.ByteArrayOutputStream

class Merger(param: Map<String, Any>) {
    private val mergeParam: MergeParam

    init {
        val color = param["color"] as String
        val width = param["width"] as Double
        val height = param["height"] as Double
        val format = param["format"] as Int
        val quality = param["quality"] as Int
        val imageParams = (param["imageParams"] as List<Map<*, *>>).map {

            val image: ByteArray = it["image"] as ByteArray
            val dx: Double = it["dx"] as Double
            val dy: Double = it["dy"] as Double
            val width: Double = it["width"] as Double
            val height: Double = it["height"] as Double

            return@map ImageParam(image, dx, dy, width, height)

        }
        mergeParam = MergeParam(color, width, height, format, quality, imageParams)
    }


    fun mergeToMemory(): ByteArray {
        val resultBitmap =
            Bitmap.createBitmap(mergeParam.width.toInt(), mergeParam.height.toInt(), Bitmap.Config.ARGB_8888)

        val canvas = Canvas(resultBitmap)

        canvas.drawColor(Color.parseColor(mergeParam.color))


        mergeParam.imageParams.forEach {
            val image = BitmapFactory.decodeByteArray(it.image, 0, it.image.size)

            canvas.drawBitmap(
                image, null, RectF(
                    it.dx.toFloat(), it.dy.toFloat(),
                    (it.dx + it.width).toFloat(), (it.dy + it.height).toFloat()
                ), null
            )
        }

        val stream = ByteArrayOutputStream()
        val format: Bitmap.CompressFormat =
            if (mergeParam.format == FormatJPEG) Bitmap.CompressFormat.JPEG else Bitmap.CompressFormat.PNG
        resultBitmap.compress(format, mergeParam.quality, stream)
        return stream.toByteArray()
    }

}