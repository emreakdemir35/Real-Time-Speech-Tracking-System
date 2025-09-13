#include <Wire.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);

int cursor_col = 0;
int cursor_row = 0;

unsigned long lastUpdateTime = 0;       // timestamp of last received byte
const unsigned long CLEAR_DELAY = 5000; // 5 seconds inactivity

void setup() {
  Serial.begin(9600);
  lcd.init();
  lcd.backlight();
}

void loop() {
  // Check for incoming bytes
  while (Serial.available() > 0) {
    char inByte = Serial.read();

    lcd.setCursor(cursor_col, cursor_row);
    lcd.write(inByte);

    // Update cursor position
    cursor_col++;
    if (cursor_col >= 16) {
      cursor_col = 0;
      cursor_row++;
      if (cursor_row >= 2) {
        cursor_row = 0;      // wrap back to top
        lcd.clear();         // optional: clear screen if full
      }
    }

    // Update last activity time
    lastUpdateTime = millis();
  }

  // Check if CLEAR_DELAY has passed since last byte
  if (millis() - lastUpdateTime > CLEAR_DELAY) {
    lcd.clear();
    cursor_col = 0;
    cursor_row = 0;
    lastUpdateTime = millis(); // reset timer after clearing
  }
}
