// PapARt library
import fr.inria.papart.procam.*;
import fr.inria.papart.procam.camera.*;
import org.bytedeco.javacpp.*;
import org.reflections.*;
import TUIO.*;
import toxi.geom.*;
import org.bytedeco.javacpp.opencv_core.IplImage;
import org.bytedeco.javacv.RealSenseFrameGrabber;
import processing.video.*;

import org.bytedeco.javacv.Frame;
import org.bytedeco.javacv.*;

import fr.inria.papart.compositor.AppRunner;

Camera camera;
AppRunner runner;

int resX = 800;
int resY = 600;

void settings(){
    size(resX, resY, OPENGL);
    // size(resX, resY, OPENGL);
}


public void setup() {
    if (surface != null) {
	surface.setResizable(true);
    }

    // runner = new AppRunner();
    // runner.start();
    connect();
    // camera = CameraFactory.createCamera(Camera.Type.FFMPEG, "/dev/video1");

	startCamera();
}

boolean cameraStarted = false;
void startCamera(){
    try{
	cameraStarted = true;
	println("Starting camera");
	camera = CameraFactory.createCamera(Camera.Type.FFMPEG, ":99", "x11grab");
	//	camera = CameraFactory.createCamera(Camera.Type.FFMPEG, ":99.0+0,0", "x11grab");
	camera.setSize(resX, resY);
	camera.setParent(this);	
	camera.start();
	//camera.setThread();
    } catch(CannotCreateCameraException cce){
	println("Cannot create the camera...");
    }
}

String prefixPub = "evt:99";

// PImage videoOut;
void draw() {


    // if(runner.ready && !cameraStarted){

     // }
    background(0);

    if(cameraStarted){
	camera.grab();
	
	PImage im = camera.getPImage();
	if(im != null){
	    image(im, 0, 0, width, height);
	}
    }
}


import de.voidplus.redis.*;
Redis redis;
void connect() {
  redis = new Redis(this, "127.0.0.1", 6379);
  // redis.auth("156;2Asatu:AUI?S2T51235AUEAIU");
}

void mouseDragged(){
    mouseMoved();
}

void mouseMoved(){

    JSONObject ob = new JSONObject();
    ob.setString("name", "mouseEvent");
    ob.setInt("x", (int) (mouseX - pmouseX));
    ob.setInt("y", (int) (mouseY - pmouseY));
    // ob.setBoolean("pressed", t.pressed);
    redis.publish(prefixPub, ob.toString());
    
    redis.set("mouse:x", Integer.toString(mouseX));
    redis.set("mouse:y", Integer.toString(mouseY));
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  redis.set("mouse:wheel", Float.toString(e));
}

void mousePressed(){
    // Boolean.toString(mousePressed));
    println("pressed");
    redis.set("mouse:pressed", Boolean.toString(true));
    redis.set("mouse:pressedButton", Integer.toString(mouseButton));

    JSONObject ob = new JSONObject();
    ob.setString("name", "mouseEvent");
    ob.setBoolean("pressed", true);
    redis.publish(prefixPub, ob.toString());
}


void mouseReleased(){
    redis.set("mouse:pressed", Boolean.toString(false));
    redis.set("mouse:pressedButton", Integer.toString(mouseButton));

    JSONObject ob = new JSONObject();
    ob.setString("name", "mouseEvent");
    ob.setBoolean("pressed", false);
    redis.publish(prefixPub, ob.toString());
}

public void keyPressed(KeyEvent e) {
    redis.sadd("key:pressed",  Integer.toString(e.getKeyCode()));
}

public void keyReleased(KeyEvent e) {
    redis.sadd("key:released",  Integer.toString(e.getKeyCode()));
}

// void keyPressed() {
//     redis.sadd("key:pressed",  Integer.toString(key));
// }
// void keyReleased() {
//     redis.sadd("key:released",  Integer.toString(key));
// }

// [1] 21298



	// sudo Xephyr -ac -br -noreset -screen 1024x768 :1
	// -mouse evdev,,,device=/dev/input/by-id/usb-_Multimedia_Air_Mouse_Keyboard-if01-event-mouse
        // -mouse evdev,,,device=/dev/input/by-id/usb-_Multimedia_Air_Mouse_Keyboard-if01-mouse
	// -keybd evdev,,,device=/dev/input/by-id/usb-_Multimedia_Air_Mouse_Keyboard-event-kbd
	// -host-cursor  -softCursor
	
	// https://wiki.archlinux.org/index.php/Xephyr
	// Xephyr -br -ac -noreset -softCursor -screen 800x600 :1
	// DISPLAY=:1 xdotool mousemove 200 200
	// DISPLAY=:1 pcmanfm

	// xvfb-run -s "-ac -screen 0 800x600x16 -fbdir /tmp" -n 1  -w 5 firefox
	// DISPLAY=:1  openbox
	// or other WM -> to change window sizes. 
	
	// DISPLAY=:2 processing-java --sketch=/home/jiii/ownCloud/sketches/redisKeyReader/ --output=/home/jiii/ownCloud/sketches/redisKeyReader/build --force --run
	// xvfb-run -s "-ac -screen 0 800x600x16 -fbdir /tmp -mouse evdev" -n 2  -w 5 firefox &


	
