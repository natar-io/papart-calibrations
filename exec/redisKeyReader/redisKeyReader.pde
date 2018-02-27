import java.awt.Robot;
import java.awt.event.InputEvent;
import java.util.Set;

import fr.inria.guimodes.Mode;
import de.voidplus.redis.*;

import java.nio.*;
import java.io.*;

// For virtual devices, we can send directly to the API ?
// https://www.virtualbox.org/sdkref/interface_i_mouse.html

// DISPLAY=:1 processing-java --sketch=/home/jiii/ownCloud/sketches/redisKeyReader/ --output=/home/jiii/ownCloud/sketches/redisKeyReader/build --force --run


// debug does not move the mouse, just a virtual pointer (square).
boolean debug = true;

void settings() {
  // fullScreen(P3D);
    // if(debug){
    // 	size(800, 600);
    // } else {
    size(200, 200);
	//    }
}

Robot robot;
Redis redis;

void setup() {
    try{
	robot = new Robot();
    } catch(Exception e){
	e.printStackTrace();
	
    }
    connect();
    
    redis.del("key:pressed");
    redis.del("key:released");
    redis.del("mouse:x");
    redis.del("mouse:y");
    redis.del("mouse:pressed");
    redis.del("mouse:pressedButton");
}

boolean previousPressed = false;

void draw() {
    keyboard();
    mouse();
}

void keyboard(){
    Set<String> keysPressed = redis.smembers("key:pressed");
    Set<String> keysReleased = redis.smembers("key:released");
	
    if(debug){
	if(!keysPressed.isEmpty()){
	    for(String key : keysPressed){
		print(key + " ");
	    }
	    print("\n");
	}
	if(!keysReleased.isEmpty()){
	    print("Key Release list: ");
	    for(String key : keysReleased){
		print(key + " ");
	    }
	    print("\n");
	}
    }

    for(String key : keysPressed){
	int k = Integer.parseInt(key);
	// press
	robot.keyPress(k);
	// remove from press list 
	redis.srem("key:pressed", key);
    }

    for(String key : keysReleased){
	int k = Integer.parseInt(key);
	// release
	robot.keyRelease(k);
	// remove from press list 
	redis.srem("key:released", key);
    }
}

void mouse(){
    String xStr = redis.get("mouse:x");
    String yStr = redis.get("mouse:y");
    if(xStr != null && yStr != null){
	int x = Integer.parseInt(xStr);
	int y = Integer.parseInt(yStr);
	robot.mouseMove(x, y);
    }
    
    String pStr = redis.get("mouse:pressed");
    String bStr = redis.get("mouse:pressedButton");

    //    println("mouse: " + xStr + " " + yStr + " pressed ?: " + pStr + " " + bStr);
    if(pStr != null && bStr != null){
	boolean pressed = Boolean.parseBoolean(pStr);
	int button = Integer.parseInt(bStr);
	
	if(pressed != previousPressed){
	    int mask = InputEvent.BUTTON1_MASK;
	    if(button == LEFT){
		mask =InputEvent.BUTTON1_MASK;
	    }
	    if(button == RIGHT){
		mask =InputEvent.BUTTON2_MASK;
	    }
	    if(button == CENTER){
		mask =InputEvent.BUTTON3_MASK;
	    }
	    
	    if(pressed){
		robot.mousePress(mask);
	    }else {
		robot.mouseRelease(mask);
	    }
	    
	    redis.del("mouse:Pressed");
	    redis.del("mouse:pressedButton");
	    previousPressed = pressed;
	}
    }
    
    String wheelString = redis.get("mouse:wheel");
    if(wheelString!= null){
	float wheel = Float.parseFloat(wheelString);
	robot.mouseWheel((int)wheel);
	redis.del("mouse:wheel");
    }
}



void connect() {
  redis = new Redis(this, "127.0.0.1", 6379);
  // redis.auth("156;2Asatu:AUI?S2T51235AUEAIU");
}

