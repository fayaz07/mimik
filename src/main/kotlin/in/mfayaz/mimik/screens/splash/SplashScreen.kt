package `in`.mfayaz.mimik.screens.splash

import `in`.mfayaz.mimik.MimikApplication
import `in`.mfayaz.mimik.core.AppColors
import `in`.mfayaz.mimik.core.AppConfig
import javafx.application.Application
import javafx.geometry.Pos
import javafx.scene.Node
import javafx.scene.Scene
import javafx.scene.control.Button
import javafx.scene.control.Label
import javafx.scene.image.Image
import javafx.scene.image.ImageView
import javafx.scene.layout.Background
import javafx.scene.layout.VBox
import java.io.InputStream
import kotlin.math.log

private const val stylesheetFile = "splash.css"
private const val baseStyleClass = "splash"

fun SplashScreen(onClick: () -> Unit): Scene {
  val layout = VBox()

  with(layout) {
    alignment = Pos.CENTER

    stylesheets.add(MimikApplication.getStyleResource(stylesheetFile)!!.toExternalForm())
    styleClass.add(baseStyleClass)

    children.apply {
      add(logo())
      add(Label(AppConfig.AppName).apply { styleClass.add("appName") })
    }
  }
  return Scene(layout)
}

private fun logo(): Node? {
  val logo = MimikApplication.getImageResource("logo.png")
  return logo?.let {
    ImageView(Image(it)).apply {
      fitWidth = 200.0
      fitHeight = 200.0
    }
  }
}
