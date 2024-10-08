package `in`.mfayaz.mimik.navigation

import javafx.scene.Scene
import javafx.stage.Screen
import javafx.stage.Stage
import java.util.*

data class NavOptions(
  val replace: Boolean = false,
  val params: NavParams = NavParams()
)

object NavController {
  private val backstack: Stack<String> = Stack()
  private val routes: MutableMap<String, (params: NavParams) -> Scene> = mutableMapOf()
  private val history: MutableMap<String, Scene> = mutableMapOf()
  private lateinit var stage: Stage
  private lateinit var initialRoute: String

  fun setStage(stage: Stage, initialRoute: String, setMaxSize: Boolean = true) {
    if (::stage.isInitialized) {
      throw NavigationException("Attempt to initialise multiple stages, which is not allowed")
    }
    this.stage = stage
    this.initialRoute = initialRoute

    if (setMaxSize) {
      val bounds = Screen.getPrimary().visualBounds
      val maxWidth = bounds.width
      val maxHeight = bounds.height

      stage.width = maxWidth
      stage.height = maxHeight
    }
    navigate(initialRoute)
  }

  fun addRoute(route: Route, builder: (params: NavParams) -> Scene) {
    routes[route.id] = builder
  }

  fun backstack() = backstack

  fun replace(route: String) {
    navigate(route, NavOptions(replace = true))
  }

  fun navigate(route: String, options: NavOptions = NavOptions()) {
    if (::stage.isInitialized.not()) {
      throw NavigationException("Attempt to navigate without initialising stage")
    }
    if (routes.containsKey(route).not()) {
      throw NavigationException("Route $route not found")
    }

    val scene = routes[route]!!.invoke(options.params)

    // if replace is false, add to backstack
    if (options.replace) {
      backstack.pop()
    } else {
      stage.scene?.let {
        history[route] = it
      }
    }
    backstack.push(route)
    stage.scene = scene
  }

  fun popBackStack() {
    if (backstack.isEmpty()) {
      // navigate to initial route
      navigate(initialRoute)
      return
    }

    val route = backstack.pop()
    if (history.containsKey(route).not()) {
      // this should never happen
      throw NavigationException("Route $route not found in history")
    }

    val scene = history[route]
    stage.scene = scene
  }
}
