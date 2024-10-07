package `in`.mfayaz.mimik

import javafx.application.Application
import javafx.geometry.Rectangle2D
import javafx.scene.Scene
import javafx.scene.layout.StackPane
import javafx.scene.text.Text
import javafx.stage.Screen
import javafx.stage.Stage

class HelloApplication : Application() {

    override fun start(stage: Stage) {
        // Get the dimensions of the primary screen
        val screenBounds: Rectangle2D = Screen.getPrimary().bounds
        val width = screenBounds.width * 0.7 // 70% of screen width
        val height = screenBounds.height * 0.7 // 70% of screen height

        // Create a simple layout
        val root = StackPane()
        val scene = Scene(root, width, height)

        // create a text object and add it to the layout
        val textComponent = Text("Hello")
        root.children.add(textComponent)

        // Set the title and scene of the primary stage
        stage.title = "70% Screen Size Example"
        stage.scene = scene

        // Center the stage on the screen
        stage.x = (screenBounds.width - width) / 2
        stage.y = (screenBounds.height - height) / 2

        stage.show()
    }
}

fun main() {
    Application.launch(HelloApplication::class.java)
}
