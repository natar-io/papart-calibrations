// PapARt library
import fr.inria.papart.procam.*;
import fr.inria.papart.multitouch.*;
import fr.inria.papart.multitouch.detection.*;
import fr.inria.papart.procam.camera.*;
import org.bytedeco.javacpp.*;
import org.reflections.*;
import tech.lity.rea.svgextended.*;

import TUIO.*;
import toxi.geom.*;
import org.bytedeco.javacpp.opencv_core.IplImage;
import org.bytedeco.javacv.RealSenseFrameGrabber;
import processing.video.*;
import org.openni.*;

import tech.lity.rea.colorconverter.*;
import org.bytedeco.javacv.Frame;
import org.bytedeco.javacv.*;
import de.voidplus.redis.*;
import java.awt.Robot;
 
Redis redis;
Papart papart;
TouchDetectionDepth fingerDetection;

String prefix;
int display = 99;

MyApp app = null;
Robot robot;

public void setup() {
  // application only using a camera
  // screen rendering
    connect();
    prefix = "evt:" + Integer.toString(display) + ":";
    //  papart = Papart.seeThrough(this, 3f);

    papart = Papart.projection(this, 2f);
    fingerDetection = papart.loadTouchInput().initHandDetection();
 
    app = new MyApp();
    papart.startTracking();



    
    try{
	robot = new Robot();
    } catch(Exception e){
	println(e);
    }
}

void mouseEntered(){
    if(app == null){
	return;
    }
    noCursor();
    try{
    app.captureKeyboard();
    app.captureMouse();
    } catch(Exception e){
	e.printStackTrace();
    }
    //    println("Entered");
}
void mouseExited(){
    if(app == null){
	return;
    }

    cursor();
    app.releaseKeyboard();
    app.releaseMouse();
    //    println("Exited");
}


void settings() {
  // the application will be rendered in full screen, and using a 3Dengine.
    // fullScreen(P3D);
    size(640 *2, 480 * 2, P3D);
}



void draw() {
    if(capMouse){
	robot.mouseMove(width/2, height/2);
    }
}



void connect() {
  redis = new Redis(this, "127.0.0.1", 6379);
  // redis.auth("156;2Asatu:AUI?S2T51235AUEAIU");
}

// void mouseDragged(){
//     mouseMoved();
// }

// void mouseMoved(){
//     redis.set(prefix + "mouse:x", Integer.toString(mouseX));
//     redis.set(prefix +"mouse:y", Integer.toString(mouseY));
// }
// void mouseWheel(MouseEvent event) {
//   float e = event.getCount();
//   redis.set(prefix +"mouse:wheel", Float.toString(e));
// }

// void mousePressed(){
//     // Boolean.toString(mousePressed));
//     println("pressed");
//     redis.set(prefix +"mouse:pressed", Boolean.toString(true));
//     redis.set(prefix +"mouse:pressedButton", Integer.toString(mouseButton));
// }


// void mouseReleased(){
//     redis.set(prefix +"mouse:pressed", Boolean.toString(false));
//     redis.set(prefix +"mouse:pressedButton", Integer.toString(mouseButton));
// }

boolean capMouse = false;

public void keyPressed(KeyEvent e) {
    //   redis.sadd(prefix +"key:pressed",  Integer.toString(e.getKeyCode()));

    if (e.isAltDown() ){
	if(key == 'c'){
	    capMouse = !capMouse;
	}
    }

    
    // if(key == 'C'){
    // 	app.captureKeyboard();
    // }
    // if(key == 'R'){
    // 	app.releaseKeyboard();
    // }
    // if(key == 'c'){
    // 	app.captureMouse();
    // 	noCursor();
    // }
    // if(key == 'r'){
    // 	app.releaseMouse();
    // 	cursor();
    // }
    
}

public void keyReleased(KeyEvent e) {
    //    redis.sadd(prefix +"key:released",  Integer.toString(e.getKeyCode()));
}	


public class MyApp extends PaperTouchScreen {

  public void settings() {
    // the size of the draw area is 297mm x 210mm.
    setDrawingSize(800 /2 , 600 /2);
    // loads the marker that are actually printed and tracked by the camera.
    loadMarkerBoard(Papart.markerFolder + "A4-default-aruco.svg", 800/2, 600/2);

    // the application will render drawings and shapes only on the surface of the sheet of paper.
    setDrawOnPaper();
    
    setQuality(2);
  }

  public void setup() {
     // Disable the filtering
     // setDrawingFilter(0);
     // setTrackingFilter(0, 0);


  // String[] vm = new String[]{
  //          "/usr/bin/vglrun",
  //          "/usr/bin/processing-java",
  //          "--sketch=/home/ditrop/sketchbook/glow/",
  //          "--output=/home/ditrop/sketchbook/glow/build",
  //          "--force",
  //          "--run"
  //      };

      

  // String[] vm = new String[]{
  //          "/usr/bin/libreoffice"
  //      };

  
      // String[] vm = new String[]{
      // 	  "/usr/bin/vglrun",
      // 	  "/opt/genymotion/player",
      // 	  "--vm-name",
      // 	  "Custom Phone - 7.0.0 - API 24 - 768x1280"
      // };
      //  vglrun env LD_PRELOAD=/usr/lib64/libdlfaker.so:/usr/lib64/libvglfaker.so /opt/genymotion/player --vm-name 6d5e75b2-2356-43b4-a758-78f60e8335cd

      // DISPLAY=:99 vglrun env LD_PRELOAD=/usr/lib64/libdlfaker.so:/usr/lib64/libvglfaker.so /opt/genymotion/player --vm-name 6d5e75b2-2356-43b4-a758-78f60e8335cd


      
      // String[] vm = new String[]{
      //       "VBoxManage",
      //       "startvm",
      //       "Win7"
      //   };


  String[] vm = new String[]{
           "/usr/bin/vglrun",
           "google-chrome-stable"
  };
      
  //  runProgram(vm);
      
     // FireFox paperScreen...
  runProgram("firefox");
       // runProgram("google-chrome-stable"); 
 }

  public void drawOnPaper() {
      setLocation(300, 0, 0);
      background(0, 0, 0);
      // appInteractWithMouse();
      drawApp();
      // Touch touch = createTouchFromMouse();


      fill(255);
      TouchList fingerTouchs = getTouchListFrom(fingerDetection);
      drawTouch(fingerTouchs);

      if(fingerTouchs.size() > 0){
	  try{
	      // sendTouchs(fingerTouchs);
	      sendTouch(fingerTouchs.get(0));

	  } catch(Exception e ){
	      println("Exception " + e);
	  }
      }
      //      rect(touch.position.x, touch.position.y, 5, 5);
      
  }
    
    void drawTouch(TouchList fingerTouchs){
	fill(255, 0, 20);
        for (Touch t : fingerTouchs) {
	    PVector p = t.position;
	    ellipse(p.x, p.y, 10, 10);
	}

    }


    
}

