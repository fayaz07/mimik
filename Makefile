build_jar:
  ./gradlew clean build

build_mac:
  jpackage --input build/libs/ \
    --name Mimik \
    --main-jar mimik-1.0.0.jar \
    --main-class in.mfayaz.mimik.Launcher \
    --type dmg \
    --dest build/macos/ \
    --app-version 1.0 \
    --vendor "Mohammad Fayaz" \
    --icon src/main/resources/images/icons/icon-apple.icns
