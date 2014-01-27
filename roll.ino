
void setup() {
  
  pinMode(13,OUTPUT);
  pinMode(10,OUTPUT);
  Serial.begin(115200);  
}

void loop() {  
    // read all analog ports, split by " "
    //int reading = analogRead(2);
    if(analogRead(2) > 10 )
    {
      digitalWrite(13,HIGH);
      Serial.print("Snare\n");
    }
    else
    {
      digitalWrite(13,LOW);
    }
    
    if(analogRead(1) > 10)
    {
      digitalWrite(10,HIGH);
      Serial.print("Kick\n");
    }
    else
    {
      digitalWrite(10,LOW);
    }
    
 
  
  
  
  
  // frame is marked by LF
  
}
