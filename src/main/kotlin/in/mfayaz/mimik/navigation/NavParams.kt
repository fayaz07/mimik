package `in`.mfayaz.mimik.navigation

open class NavParams {
  private var width: Double = 0.0
  private var height: Double = 0.0

  fun setWidth(width: Double) {
    this.width = width
  }

  fun setHeight(height: Double) {
    this.height = height
  }

  fun getWidth(): Double {
    return width
  }

  fun getHeight(): Double {
    return height
  }
}
