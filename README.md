# Zielsetzung:
Verstehen wie Bare Metal Programming funktioniert indem ich:
1. on board LED ohne SDK zum Blinken bringe
2. ursprunglichen Projekt realisiere: Ulrtaschallsensor wird hinter der Badtür platziert - wenn Entfernung < 20 cm ---> Tür ist auf --> BEEEEP!!! Das soll menem Freund helfen zu lernen, dass er Badtür schließen soll xD

# Projektstruktur
Aktueller Arbeitsverzeichnis ist "no_sdk" Folder

**Notes:**
HC-SR04 - 5V
- Sendedauer 10microSeconds!!!
Raspi Pico - 3.3V!
GP26,27,28 are not 5V safe ???