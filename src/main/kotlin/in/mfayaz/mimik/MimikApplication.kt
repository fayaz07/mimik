package `in`.mfayaz.mimik

import `in`.mfayaz.mimik.core.AppConfig
import `in`.mfayaz.mimik.core.Routes
import `in`.mfayaz.mimik.navigation.NavController
import `in`.mfayaz.mimik.navigation.Route
import `in`.mfayaz.mimik.screens.splash.SplashScreen
import javafx.application.Application
import javafx.scene.image.Image
import javafx.stage.Stage
import java.io.InputStream
import java.net.URL

class MimikApplication : Application() {

  override fun start(primaryStage: Stage?) {
    if (primaryStage == null) return

    setIcon(primaryStage)

    with(NavController) {
      register(Route(Routes.SPLASH_SCREEN)) {
        SplashScreen {
          replace(Routes.HOME_SCREEN)
        }
      }
      setStage(primaryStage, Routes.SPLASH_SCREEN)
    }

    primaryStage.title = AppConfig.AppName
    primaryStage.show()
  }

  private fun setIcon(stage: Stage) {
//    addIcon(stage, "icons/icon-16x16.png")
//    addIcon(stage, "icons/icon-24x24.png")
//    addIcon(stage, "icons/icon-32x32.png")
//    addIcon(stage, "icons/icon-48x48.png")
//    addIcon(stage, "icons/icon-64x64.png")
//    addIcon(stage, "icons/icon-128x128.png")
    addIcon(stage, "icons/icon-256x256.png")
//    addIcon(stage, "icons/icon-512x512.png")
//    addIcon(stage, "icons/icon-1024x1024.png")
  }

  private fun addIcon(stage: Stage, path: String) {
    val icon = getImageResource(path)
    icon?.let {
      stage.icons.add(Image(it))
      println(stage.icons.size)
    }
  }

  companion object {
    @JvmStatic
    fun main(args: Array<String>) {
      launch(MimikApplication::class.java)
    }

    private val currentClass = MimikApplication::class.java
    private const val IMAGE_RESOURCES_PATH = "/images/"
    private const val STYLES_RESOURCES_PATH = "/styles/"

    fun getStyleResource(path: String): URL? {
      return currentClass.getResource("$STYLES_RESOURCES_PATH$path")
    }

    fun getImageResource(path: String): InputStream? {
      return currentClass.getResourceAsStream("$IMAGE_RESOURCES_PATH$path")
    }
  }
}
