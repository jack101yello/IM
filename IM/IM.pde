// Server application
/*
To do:
- Fix sending from the client to the server
  - The message doesn't print to the server

Notes:
I've removed logged messages so that only one will appear onscreen
This feature may be added back once network functionality works
*/

import processing.net.*;
Server server;

Message message;

// The 5 logged messages
String[] savedMessage = new String[5];
String tempSave;

void setup() {
  size(640, 360);
  server = new Server(this, 4444); // Creates a new server on port 4444
  message = new Message();
  for(int i = 0; i < savedMessage.length; i++) {
    savedMessage[i] = " ";
  }
}

void draw() {
  background(255);
  stroke(0);
  line(0, height*3/4, width, height*3/4);
  message.getMessage();
  message.show();
  message.type();
  message.oldMessages();
}

class Message {
  char[] mess = new char[0];
  String messStr;

  void show() { // Displays the text currently being typed to the screen
    defaults();
    messStr = new String(mess); // Converts the char array to a string for printing to the screen
    text(messStr, width/2, height*7/8);
  }
  
  void send() { // Send the most recent message to the client
    server.write(savedMessage[0]);
  }
  
  void type() { // Inputs commands from the user
    if(keyPressed) {
      mess = append(mess, key);
      keyPressed = false;
      
      if((key == DELETE || key == BACKSPACE) && mess.length - 1 > 0) {
        mess = subset(mess, 0, mess.length - 2);
      }
      else if((key == ENTER || key == RETURN) && mess.length - 1 > 0) {
        logMessages(); // This has been adapted to only move the current message to the first save slot
        send();
        mess = subset(mess, 0, 0);
      key = '_';
      }
    }
  }
  
  void logMessages() { // Moves each message to the next save slot
    /* Commented out so that only one message will be saved
    for(int i = 4; i > 0; i--) {
      savedMessage[i] = savedMessage[i-1];
    }
    */
    savedMessage[0] = messStr;
  }
  
  void getMessage() {
    Client client = server.available();
    if(client != null) {
      tempSave = client.readString();
      if(savedMessage[0] != tempSave) {
        savedMessage[0] = tempSave;
        send();
      }
    }
  }
  
  void oldMessages() {
    defaults();
    text(savedMessage[0], width/2, height*27/40);
    //text(savedMessage[1], width/2, height*21/40);
    //text(savedMessage[2], width/2, height*15/40);
    //text(savedMessage[3], width/2, height*9/40);
    //text(savedMessage[4], width/2, height*3/40);
  }
}

void defaults() { // Sets text settings to the defaults
  stroke(0);
  fill(0);
  textAlign(CENTER);
  textSize(30);
}