# History of mimik

### Code so far (14-11-2024)

#### Struggles with JavaFX

- Target was to build a cross platform application (basically just as Desktop app), so I chose JavaFX as the GUI framework with Kotlin as the programming language. Because I am an android developer (worked with android most of time during my career), wanted to make benefit of the knowledge I have in Kotlin, along with the powerful Coroutines library.
- Initiated a new project in IntelliJ IDEA, and started with the basic setup of the project.
- Created a new JavaFX project, and added the required dependencies in the `build.gradle.kts` file.
- Wanted to explore navigation in JavaFX, searched and found for libraries, didn't found anything interesting and decided to create my own navigation library.
- Created navigation library(very basic one), added examples and tested it(manually).
- Explored testing libraries, same thing happened, didn't found anything except `TestFX`.
- Started writing tests for the navigation library, and faced so many issues, nor stackoverflow or internet was able to help me solve the issues, wasted few days on that.
- No straight path for even updating icons in the app, had to use `ImageView` and `Image` class to load the icons.
- Images were not loading, tried to load images from resources, but failed, finally succeeded.
- Struggled with css, no proper support for scss, had to use css only and that too with inline css in most cases.
- Decided to moved on.

#### Exploring alternative

- Electron was always in my mind, but I wanted the app to be lightweight and fast, so I decided to explore other options.
- Then found `Tauri`, which was `v1` at that time.
- Initiated a new project, and started with the basic setup of the project.
- The project was stale, no updates for few days.
- Tauri released `v2`, and I decided to re-initiate the project with `v2`, but with `deno@v2` this time.
- I wanted a monorepo, found the structure and implementation of monorepo with `deno` weird, so switched back to `npm`.

### Feb 6, 2025

- Tauri is great and Rust is giant too, but unfortunately I don't know Rust and couldn't spend time to learn it
- Switching to `fyne`. If you ask me why `fyne`?, I know `Go` and according to the plan of building `mimik`, I felt I don't need complex UI components. Let's see what is gonna happen.
- Explored `fyne` and it's demo app and felt `fyne` has it's own design system, doesn't feel native
- Back with `Electron`? Uhhh! I have ended up choosing what I wanted to skip right at the start.

### Mar 16, 2025

- Electron was great. I tried to find best template, used the one that was created by community (maybe), electron, vite, typescript & react - awesome.
- I wanted this app to be an offline supported
- Searched for local-storage, yeah the sql databases, found out that the databases are native modules and not directly supported by electron, this was a pain and a bigger pain was to see some SQL library as a paid version
- Had a mess and struggle setting up the `better-sqlite3` library only to find out after few days of successfully setting it up that it doesn't work in release mode. The problem was it was not able to find the native better-sqlite3 module in release mode at all, no matter what configuration I tried.
- I guess this is the reason why native SDK's are the evergreen solutions.
- I feel good that I found this issue, just at the beginning of the project (just built 2 screens)
- Another astonishing thing was, the app size with just these 2 screens is massively huge 200mb 😱 and the extracted archive is around 500mb, seriously? Am I building an IDE.
