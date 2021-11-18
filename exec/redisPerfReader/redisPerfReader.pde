import fr.inria.papart.procam.*;
import fr.inria.papart.multitouch.*;
import tech.lity.rea.svgextended.*;
import org.bytedeco.javacpp.*;
import org.reflections.*;
import processing.video.*;
import TUIO.*;
import toxi.geom.*;
import fr.inria.papart.depthcam.*;
import fr.inria.papart.procam.display.*;

import fr.inria.guimodes.Mode;
import de.voidplus.redis.*;

import java.nio.*;
import java.io.*;

boolean useDebug = true;
boolean useCam = false;

void settings(){
    // fullScreen(P3D);
    size(600, 600);
}

 void setup(){
     connect();
}


void draw(){
  background(255);
    loadPixels();
    byte[] id = {(byte) 0};
    byte[] yourBytes = redis.get(id);
    
    ByteArrayInputStream bis = new ByteArrayInputStream(yourBytes);
    ObjectInput in = null;
    try {
	in = new ObjectInputStream(bis);
	Object o = in.readObject(); 
  	int[] px = (int[]) o;
	println("Read " + pixels.length);

//for(int i = 0; i < 10000; i++){
  //pixels[i] = px[i];
 // print(px[i] + " " );
   System.arraycopy(px, 0, pixels, 0, px.length -1);
//}
    } catch (IOException ex) {
	println("unpack issue " + ex);
    } catch (Exception ex) {
	println("unpack issue2 " + ex);
    }
    finally {
	try {
	    if (in != null) {
		in.close();
	    }
	} catch (IOException ex) {
	    println("Reading issue");
	    // ignore close exception
	}
    }
    updatePixels();
}

void keyPressed() {
}

Redis redis;

void connect(){
    redis = new Redis(this, "192.168.0.52", 6379);
    //    redis = new Redis(this, "127.0.0.1", 6379);
    // redis.auth("156;2Asatu:AUI?S2T51235AUEAIU");
}
