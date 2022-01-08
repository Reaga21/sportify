
# MOB | Sportify

Eine mobile Flutter-Applikation.

Projektarbeit angefertigt für das Modul Mobile Systeme im WS21/22
Projektmitarbeiter: Klaas Pelzer, Andrea Robitzsch

## Screencast

![Screencast Gif](https://github.com/Reaga21/sportify/blob/master/Screencast_Sportify.gif)

## Über die App Sportify

Die App Sportify stellt eine kompetetive Schrittzähler-App dar und richtet sich an Nutzer jeden Alters, die ihre Schritte zählen und mit Ihren Freunden innerhalb der App teilen und vergleichen möchten.
Die Schritte mit den eigenen Freunden zu teilen und zu vergleichen generiert eine Motivation selber mehr tägliche Schritte zu machen.

Mit der Sportify App können:
* Schritte mit dem Pedometer Sensor im eigenen Smartphone getrackt und gespeichert werden
* Personen, die ebenfalls die Sportify App nutzen, gesucht und als Freunde in der App hinzufügt werden
* Eigene am Tag getrackte Schritte mit den Freunden geteilt werden
* Die eigenen Schritte und eine Rankingliste der Schritte der Freunde auf dem Startbildschirm übersichtlich      dargestellt werden
* Das eigene Benutzerprofil, wie Benutzerbild, -name und Email-Adresse geändert werden.

## Getting Started
0. Internetverbindung herstellen.
1. App anhand der APK installieren und öffnen.
2. Mit einer gültigen Email-Adresse und einem zulässigen Passwort bei der Sportify Anmelden oder Registrieren.
3. Bei der ersten Installation der App muss gegebenenfals der App erlaubt werden auf körperliche Aktivität (dem Sensor des Handys) zuzugreifen.
4. Sie werden auf den Login-Bildschirm weitergeleitet und müssen sich entweder neu registrieren oder mit einem bereits bestehenden Account anmelden.

# Codeaufbau:

Die Codedateien der App befinden sich im "lib"-Ordner des Projektordners "Sportify".
Im "Lib"-Ordner befinden sich die Ordner "Assets" sowie "src" und die main.dart Datei, die den Einstiegspunkt der App darstellt. Im "asset"-Ordner liegen Ressourcen-Dateien, wie zum Beispiel in der App verwendete Bilddateien.
Im "src"-Ordner befinden sich die eigentlichen Quelldateien. Der "src"-Ordner unterteilt sich in die Ordner: "model", "util" und "views".<br>
Im Ordner "model" befinden sich alle Klassen, der in der App verwendeten Datenmodelle.
Im "util"-Ordner befinden sich Hilfsfunktionen.
Der "views"-Ordner umfasst die einzelnen Ansichten (Screens) der App. Dieser Ordner unterteilt sich dementsprechend in Unterordner "home", "loading", "login" und "registration". In all diesen Ordnern befindet sich die .dart Datei der entsprechenden Ansicht. Da die unterschiedlichen Tabs des Home-Screens mittels einer BottomNavigationBar gesteuert werden, unterteilt sich der "home"-Ordner in die home_page.dart (Einstieg des Home-Screens) und den Unterordnern der einzelnen aus dem Home-Screen ansteuerbaren Tabs ("friends", "profile", "statistics", "stepOverview"). In den Tabs "friends" und "statistics" ergibt sich eine analoge Struktur. Der "friends"-Screen weist zwei unterschiedliche Tabs auf, die mittels einer TabBar gesteuert werden. Der "statistics"-Screen umfasst drei unterschiedliche Tabs (die einzelnden Diagramme), die mittels eines PageControllers gesteuert werden.<br>
Die Dateien der Unittests ("step_model_test.dart") und Widgettests ("step_box_test.dart") befinden sich im Ordner "test".<br>
Für das automatisierte Testen bei Pullrequests wird Githubworkflow verwendet.
