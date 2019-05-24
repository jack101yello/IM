// This is NOT the file in the Git Repo
// Client application
/*
To do:
- Have user type in the IP they're trying to connect to

Notes:
When the client sends a message to the server, the message appears on the server but not on the client
*/

import processing.net.*;
Client client;
String IP;
boolean loggedIn;

Message message;

// The 5 logged messages
String[] savedMessage = new String[5];

void setup() {
  size(640, 320);
  loggedIn = false;
  message = new Message();
  for(int i = 0; i < savedMessage.length; i++) {
    savedMessage[i] = " ";
  }
}

void signIn() {
  text("What IP would you like to connect to?", width/2, height/2);
  message.show();
  message.type();
  if(key == ENTER || key == RETURN) {
    IP = message.messStr;
    message.mess = subset(message.mess, 0, 0);
    client = new Client(this, IP, 4444);
    loggedIn = true;
  }
}

void draw() {
  background(255);
  stroke(0);
  if(!loggedIn) {
    signIn();
  }
  else {
    line(0, height*3/4, width, height*3/4);
    message.show();
    message.type();
    message.setMessage();
    message.oldMessages();
  }
}

class Message {
  char[] mess = new char[0];
  String messStr;

  void show() { // Displays the text to the screen
    defaults();
    messStr = new String(mess); // Converts the char array to a string for printing to the screen
    text(messStr, width/2, height*7/8);
  }
  
  void type() { // Inputs commands from the user
    if(keyPressed) {
      mess = append(mess, key);
      keyPressed = false;
      
      if((key == DELETE || key == BACKSPACE) && mess.length - 1 > 0) {
        mess = subset(mess, 0, mess.length - 2);
      }
      else if((key == ENTER || key == RETURN) && mess.length - 1 > 0) {
        if(loggedIn) { // The enter key should run the login method if the user is not signed-in yet.
          sendToServer();
          mess = subset(mess, 0, 0);
          key = '_';
        }
      }
    }
  }
  
  void sendToServer() { // Sends the message being typed to the server
    client.write(messStr);
  }
  
  void setMessage() { // Sets the displayed message to be the input from the server
    if(client.available() != 0) {
      savedMessage[0] = client.readString();
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