uint8_t TRIGGER = 8; // [SIGNAL SENDEN]
uint8_t ECHO = 7; // [SIGNAL EMPFANGEN] reflektierter Ultraschallsignall kommt zum Sensor zurück 
uint8_t BUZZER = 9; // zum + Pol des Buzzers!!!
unsigned long duration;

void setup() {
  pinMode(TRIGGER, OUTPUT); 
  pinMode(ECHO, INPUT); 
  pinMode(BUZZER, OUTPUT);

  Serial.begin(9600); 

}

void loop() {
//  kurz auf LOW um Störungen des Signals zu vermeiden
  digitalWrite(TRIGGER, LOW);
  delayMicroseconds(2);

  digitalWrite(TRIGGER, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIGGER, LOW);

  // pulseIn -> Zeit messen, bis das Signal zurückkommt
  // pulseIn [Works on pulses from 10 microseconds to 3 minutes in length]
  duration = pulseIn(ECHO, HIGH);
  // Entfernung in cm berechnen
  // Zeit/2 -> nur eine Strecke
  int Entfernung = (duration / 2) * 0.0343;
  delay(500);

// Debugging
  Serial.print("Entfernung in cm: ");
  Serial.println(Entfernung);

  if (Entfernung < 20){
    digitalWrite(BUZZER, HIGH);
    delay(1000);
    digitalWrite(BUZZER, LOW);
    delay(1000);
  }

}
