# engelsburg_app

Eine App von Dario Trombello, die Informationen über das Engelsburg-Gymnasium übersichtlich zusammenstellt. Programmiert mit der Flutter SDK von Google.

## Erste Schritte

Wenn du Hilfe beim Einstieg in Flutter benötigst, schau dir die Online-[Dokumentation](https://flutter.dev/docs) an. Flutter ist ein Projekt von Google, mit dem Ziel schnell und einfach Apps einer einzigen Codebase für iOS und Android Geräte zu exportieren. Flutter ist genau wie viele für Flutter verfügbaren Plug-Ins in der Entwicklungsphase und es können daher noch einige Fehler auftreten.
Wenn du an diesem Projekt beitragen möchtest, kannst du das tun, indem du Pull-Requests einreichst.

## App kompilieren

Zum Kompilieren der App für Android muss erst eine Keystore-Datei zum Signieren erstellt werden.

Benutze unter MacOS/Linux den Befehl:
```
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```

Benutze unter Windows den Befehl:
```
keytool -genkey -v -keystore C:/Users/<Benutzername>/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```

Erstelle dann unter dem Ordner `engelsburg_app/android/key.properties` eine Datei mit folgendem Inhalt:
```
storePassword=<Passwort vom vorherigen Schritt>
keyPassword=<Passwort vom vorherigen Schritt>
keyAlias=key
storeFile=<Pfad der Keystore-Datei. Beispiel: C:/Users/<Benutzername>/key.jks>
```
ACHTUNG: Veröffentliche beide Dateien unter keinen Umständen! Wenn du einen Pull-Request einreichst oder diese Repository woanders über Git hochlädst, wird die Datei key.properties automatisch vom Hochladen ausgenommen.


## License

Copyright 2018-2020 Dario Trombello

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
