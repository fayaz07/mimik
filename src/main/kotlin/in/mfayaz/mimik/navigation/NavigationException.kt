package `in`.mfayaz.mimik.navigation

class NavigationException(private val msg: String) : RuntimeException(msg) {
  override fun getLocalizedMessage(): String {
    return msg
  }
}
