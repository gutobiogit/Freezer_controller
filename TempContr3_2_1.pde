#include <LiquidCrystal.h>
#include <Time.h>

//********************** LCD  *******************************
// which digital pin to connect
#define Luz_Fundo  6
//cria um objeto tipo LiquidCrystal que chamei de "lcd" nos pinos citados:
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

//********************** TEMPERATURA  ***********************
// which analog pin to connect
#define THERMISTORPIN A0         
#define THERMISTORPIN1 A1
#define THERMISTORPIN2 A2
// resistance at 25 degrees C
#define THERMISTORNOMINAL 10000      
// temp. for nominal resistance (almost always 25 C)
#define TEMPERATURENOMINAL 25   
// how many samples to take and average, more takes longer
// but is more 'smooth'
#define NUMSAMPLES 5
// The beta coefficient of the thermistor (usually 3000-4000)
#define BCOEFFICIENT 3950
// the value of the 'other' resistor
#define SERIESRESISTOR 10000    


boolean(pino);
 
int samples[NUMSAMPLES];
//************************** TIMER ***********************************

time_t tibe = 0;
//**************************  RELE  ***************************************

#define WTEMP 1 //temp. of freezer wall
#define TEMPERATURA 3
#define ESTERESE 2
#define relayPin 7 
 
//************************* SETUP ****************************************** 
void setup(void) {
  Serial.begin(9600);
  analogReference(EXTERNAL);
  analogWrite(9,90);
  lcd.begin(16, 2); // Iniciando o objeto "lcd" de 2 linhas e 16 colunas
  pinMode(Luz_Fundo,OUTPUT); //define o pino como saída
  digitalWrite(Luz_Fundo,HIGH); // Liga a luz do display
  //desenha simbolo grau
  byte graus[8] = { 
  0b00000, 
  0b00100,
  0b10001,
  0b10001,
  0b00100,
  0b00000,
  0b00000,
  0b00000
};
  lcd.createChar(1, graus);// cria caracter graus
  
  //count to 10 to startup
  for (int a =1; a < 11; a++)
  {
    lcd.setCursor(0,0); // seta o cursor para: (coluna = 0, linha = 0)
    lcd.print("AGUARDE.... ");
    lcd.setCursor(11,0);
    lcd.print(a);
    delay(1000);
  }
    lcd.setCursor(0,0); // seta o cursor para: (coluna = 0, linha = 0)
    lcd.print("SITIO JATAI");
    delay(3000);
    lcd.setCursor(0,1); // seta o cursor para: (coluna = 0, linha = 1)
    lcd.print("ver. 3.2.1");
    delay(3000);
  
}
//************************************  LOOP ***************************************************************************************************
void loop(void) {
  uint8_t i;
  float average;


  
 //****************************************************  Leitura Termistor 1  **********************************************************************
  // take N samples in a row, with a slight delay
  for (i=0; i< NUMSAMPLES; i++) {
   samples[i] = analogRead(THERMISTORPIN);
   delay(10);
  }
 
  // average all the samples out
  average = 0;
  for (i=0; i< NUMSAMPLES; i++) {
     average += samples[i];
  }
  average /= NUMSAMPLES;
 
  //Serial.print("Average analog reading "); 
  //Serial.println(average);
 
  // convert the value to resistance
  average = 1023 / average - 1;
  average = SERIESRESISTOR / average;
  // Serial.print("Thermistor resistance "); 
  // Serial.println(average);
  float temp1;
  float steinhart;
  steinhart = average / THERMISTORNOMINAL;     // (R/Ro)
  steinhart = log(steinhart);                  // ln(R/Ro)
  steinhart /= BCOEFFICIENT;                   // 1/B * ln(R/Ro)
  steinhart += 1.0 / (TEMPERATURENOMINAL + 273.15); // + (1/To)
  steinhart = 1.0 / steinhart;                 // Invert
  steinhart -= 273.15;                         // convert to C
  temp1 = steinhart;
  Serial.print("Temperature "); 
  Serial.print(temp1);
  Serial.println(" *C");
  
 //****************************************************  Leitura Termistor 2  **********************************************************************
    // take N samples in a row, with a slight delay
  for (i=0; i< NUMSAMPLES; i++) {
   samples[i] = analogRead(THERMISTORPIN1);
   delay(10);
  }
 
  // average all the samples out
  average = 0;
  for (i=0; i< NUMSAMPLES; i++) {
     average += samples[i];
  }
  average /= NUMSAMPLES;
 
  //Serial.print("Average analog reading "); 
  //Serial.println(average);
 
  // convert the value to resistance
  average = 1023 / average - 1;
  average = SERIESRESISTOR / average;
  // Serial.print("Thermistor resistance "); 
  // Serial.println(average);
  float temp2;
  steinhart = 0; //reset value
  steinhart = average / THERMISTORNOMINAL;     // (R/Ro)
  steinhart = log(steinhart);                  // ln(R/Ro)
  steinhart /= BCOEFFICIENT;                   // 1/B * ln(R/Ro)
  steinhart += 1.0 / (TEMPERATURENOMINAL + 273.15); // + (1/To)
  steinhart = 1.0 / steinhart;                 // Invert
  steinhart -= 273.15;                         // convert to C
  temp2 = steinhart;
  Serial.print("Temperatura 2 "); 
  Serial.print(temp2);
  Serial.println(" *C");
  
 //****************************************************  Leitura Termistor 3  **********************************************************************
    // take N samples in a row, with a slight delay
  for (i=0; i< NUMSAMPLES; i++) {
   samples[i] = analogRead(THERMISTORPIN2);
   delay(10);
  }
 
  // average all the samples out
  average = 0;
  for (i=0; i< NUMSAMPLES; i++) {
     average += samples[i];
  }
  average /= NUMSAMPLES;
 
  //Serial.print("Average analog reading "); 
  //Serial.println(average);
 
  // convert the value to resistance
  average = 1023 / average - 1;
  average = SERIESRESISTOR / average;
  // Serial.print("Thermistor resistance "); 
  // Serial.println(average);
  float temp3;
  steinhart = 0; //reset value
  steinhart = average / THERMISTORNOMINAL;     // (R/Ro)
  steinhart = log(steinhart);                  // ln(R/Ro)
  steinhart /= BCOEFFICIENT;                   // 1/B * ln(R/Ro)
  steinhart += 1.0 / (TEMPERATURENOMINAL + 273.15); // + (1/To)
  steinhart = 1.0 / steinhart;                 // Invert
  steinhart -= 273.15;                         // convert to C
  temp3 = steinhart;
  Serial.print("Temperatura 3 "); 
  Serial.print(temp3);
  Serial.println(" *C");
  //*************************  RELE  *********************************************************************************
  if (temp2<=(TEMPERATURA-ESTERESE))
   {digitalWrite(relayPin, LOW);
    digitalWrite(13, LOW);
    pino=0;
   }//if temperature is lower than temperature- esteresis set relay and builtin led off
  
  
  if (temp3>=WTEMP)
   {
     if (temp2>=(TEMPERATURA+ESTERESE))
      {
        digitalWrite(relayPin, HIGH);
        digitalWrite(13, HIGH);
        pino=1;
      }//if temperature is higher than temperature+ esteresis set relay and builtin led on
   }
   else
    {
     digitalWrite(relayPin, LOW);
     digitalWrite(13, LOW);
     pino=0;
    }; 
 
//************************************************** LCD  ********************************************************************************
  lcd.setCursor(0,0); // seta o cursor para: (coluna = 0, linha = 0)
  lcd.print("Externa: ");
  lcd.setCursor(9,0);
  lcd.print(temp1);
  lcd.write(1);
  lcd.print(" ");

  lcd.setCursor(0,1); // seta para linha 1, ou seja, a linha de baixo
  lcd.print("Metal:          ");
  lcd.setCursor(8,1);
  lcd.print(temp2);
  lcd.write(1);
  lcd.print(" ");
  delay (7000);
  if (pino == 0)
  {  
    lcd.setCursor(0,1);
    lcd.print("DESLIGADO/");
    lcd.setCursor(10,1);
    lcd.print(temp3);
    lcd.write(1);
    lcd.print(" ");
    lcd.print(minute(tibe));
    lcd.print(":");
    lcd.print(second(tibe));
    Serial.println("Pino==0");
    Serial.print(minute(tibe));
    Serial.print(":");
    Serial.print(second(tibe));
    setTime(0);
    
    delay (7000);
  }
 if (pino == 1)
  { 
    tibe=now();
    lcd.setCursor(0,1);
    lcd.print("LIGADO/");
    lcd.setCursor(7,1);
    lcd.print(temp3);
    lcd.write(1);
    lcd.print(" ");
    lcd.print(minute(tibe));
    lcd.print(":");
    lcd.print(second(tibe));
    Serial.println("Pino==1");
    Serial.print(minute(tibe));
    Serial.print(":");
    Serial.print(second(tibe));
    delay (7000);
  };
  
  Serial.println();
}

;
