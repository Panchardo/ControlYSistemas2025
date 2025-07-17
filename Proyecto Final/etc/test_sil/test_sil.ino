// Unión para convertir float a 4 bytes
typedef union {
  float number;
  uint8_t bytes[4];
} FLOATUNION_t;

// Constante del controlador
const float Kp = 10.0, Ki = 1.0; float I = 0.0;

FLOATUNION_t rUnion, yUnion, uUnion;

void setup() {
  Serial.begin(115200);
}

void loop() {
  // Esperar a que lleguen los 8 bytes de entrada
  if (Serial.available() >= 8) {
    // Leer referencia (r)
    for (int i = 0; i < 4; i++) {
      rUnion.bytes[i] = Serial.read();
    }

    // Leer salida de planta (y)
    for (int i = 0; i < 4; i++) {
      yUnion.bytes[i] = Serial.read();
    }

    // Calcular u = Kp * (r - y)
    float error = rUnion.number - yUnion.number;
    I +=  error*0.001;
    float u = Kp * error + Ki*I;
    uUnion.number = u;
    // Enviar header (opcional para sincronización)
    Serial.write('A');  // También podrías omitirlo

    // Enviar u (4 bytes como float)
    for (int i = 0; i < 4; i++) {
      Serial.write(uUnion.bytes[i]);
    }

    // Terminador opcional
  //   Serial.println("");  // Si lo usás, Simulink debe esperarlo
    
  }

  // Opcional: pequeño delay si querés controlar ritmo
  delay(1); // Ajustalo al paso de muestreo de Simulink (ej. 10ms)
}
