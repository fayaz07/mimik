package `in`.mfayaz.mimik

import `in`.mfayaz.mimik.navigation.NavController
import `in`.mfayaz.mimik.navigation.NavOptions
import `in`.mfayaz.mimik.navigation.Route
import `in`.mfayaz.mimik.screens.splash.SplashScreen
import `in`.mfayaz.mimik.screens.splash.XScreen
import `in`.mfayaz.mimik.screens.splash.XScreenParams
import javafx.application.Application
import javafx.stage.Stage

class MimikApplication : Application() {

    override fun start(primaryStage: Stage?) {
        if (primaryStage == null) return

        NavController.addRoute(
            Route("splash")
        ) {
            SplashScreen {
                NavController.navigate("x", options = NavOptions(params = XScreenParams("Hello from Splash")))
            }
        }

        NavController.addRoute(
            Route("x")
        ) { params ->
            XScreen(params as XScreenParams)
        }

        NavController.setStage(primaryStage, "splash")

        primaryStage.title = "Mimik"

        primaryStage.show()
    }

    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            launch(MimikApplication::class.java)
        }
    }
}
