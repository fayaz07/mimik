package `in`.mfayaz.mimik.screens.splash

import `in`.mfayaz.mimik.core.AppColors
import `in`.mfayaz.mimik.navigation.NavController
import `in`.mfayaz.mimik.navigation.NavOptions
import `in`.mfayaz.mimik.navigation.NavParams
import `in`.mfayaz.mimik.navigation.Route
import javafx.animation.FadeTransition
import javafx.application.Application
import javafx.geometry.Pos
import javafx.scene.Scene
import javafx.scene.control.Button
import javafx.scene.control.Label
import javafx.scene.layout.Background
import javafx.scene.layout.VBox
import javafx.stage.Stage
import kotlin.reflect.KAnnotatedElement
import javafx.util.Duration

data class XScreenParams(
  val text: String
): NavParams()

fun XScreen(
  params: XScreenParams
): Scene {
  val layout = VBox()
  layout.alignment = Pos.CENTER

  val label = Label("This is the X Screen, message: ${params.text}")

  layout.background = Background.fill(AppColors.backgroundMain)
  layout.children.apply {
    add(label)

    add(Button("Navigate to Splash Screen").apply {
      setOnAction {
        NavController.popBackStack()
      }
    })
  }

  val scene = Scene(layout)
  return scene
}

fun SplashScreen(onClick: () -> Unit): Scene {
  val layout = VBox()
  layout.alignment = Pos.CENTER

  val label = Label("This is the First Scene")

  layout.children.apply {
    add(label)

    add(Button("Navigate to X Screen").apply {
      setOnAction {
        label.text = "navigated"
        onClick()
      }
    })
  }

  val scene = Scene(layout)
  return scene
}
