import java.awt.Robot;
import java.awt.event.InputEvent;

import fr.inria.guimodes.Mode;
import de.voidplus.redis.*;

import java.nio.*;
import java.io.*;

void settings() {
  // fullScreen(P3D);
    size(800, 600);
}

Redis redis;
void setup() {
  connect();
}

void draw() {
    rect(mouseX, mouseY, 10, 10);
}

void mouseMoved(){
    redis.set("mouse:x", Integer.toString(mouseX));
    redis.set("mouse:y", Integer.toString(mouseY));
}

void mousePressed(){
    redis.set("mouse:pressed", Boolean.toString(true)); // Boolean.toString(mousePressed));
    redis.set("mouse:pressedButton", Integer.toString(mouseButton));
}

void mouseReleased(){
    redis.set("mouse:pressed", Boolean.toString(false));
    redis.set("mouse:pressedButton", Integer.toString(mouseButton));
}

void keyPressed() {
    redis.sadd("key:pressed",  Integer.toString(key));
}
void keyReleased() {
    redis.sadd("key:released",  Integer.toString(key));
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  redis.set("mouse:wheel", Float.toString(e));
}



void connect() {
    // redis = new Redis(this, "127.0.0.1", 6379);
  redis = new Redis(this, "54.37.10.254", 6379);
  // redis.auth("156;2Asatu:AUI?S2T51235AUEAIU");
}
