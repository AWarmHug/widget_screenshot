package com.bingo.widgetshot

const val FormatPng=0
const val FormatJPEG=1


data class MergeParam(
    val color: Int?,
    val width: Double,
    val height: Double,
    val format:Int,
    val quality:Int=90,
    val imageParams: List<ImageParam>
)


data class ImageParam(
    val image: ByteArray,
    val dx: Double,
    val dy: Double,
    val width: Double,
    val height: Double
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as ImageParam

        if (!image.contentEquals(other.image)) return false
        if (dx != other.dx) return false
        if (dy != other.dy) return false
        if (width != other.width) return false
        if (height != other.height) return false

        return true
    }

    override fun hashCode(): Int {
        var result = image.contentHashCode()
        result = 31 * result + dx.hashCode()
        result = 31 * result + dy.hashCode()
        result = 31 * result + width.hashCode()
        result = 31 * result + height.hashCode()
        return result
    }
}