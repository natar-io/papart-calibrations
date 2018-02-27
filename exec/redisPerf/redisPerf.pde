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

void settings() {
  // fullScreen(P3D);
  size(1600, 600);
}

void setup() {
  connect();
}


void draw() {
    background(0);
    rect(mouseX, mouseY, 10, 10);
     
    loadPixels();
    updatePixels();
    byte[] id = {(byte) 0};
    
    ByteArrayOutputStream bos = new ByteArrayOutputStream();
    ObjectOutput out = null;
    try {
	out = new ObjectOutputStream(bos);   
	out.writeObject(pixels);
	out.flush();
	byte[] yourBytes = bos.toByteArray();
	
	redis.set(id, yourBytes);
  }
    catch(Exception e) {
	e.printStackTrace();
  }
    println("Yo");
}

void keyPressed() {
}


Redis redis;

void connect() {
  redis = new Redis(this, "127.0.0.1", 6379);
  // redis.auth("156;2Asatu:AUI?S2T51235AUEAIU");
}

public byte[] intToBytes(int my_int) throws IOException {
  ByteArrayOutputStream bos = new ByteArrayOutputStream();
  ObjectOutput out = new ObjectOutputStream(bos);
  out.writeInt(my_int);
  out.close();
  byte[] int_bytes = bos.toByteArray();
  bos.close();
  return int_bytes;
}


public int bytesToInt(byte[] int_bytes) throws IOException {
  ByteArrayInputStream bis = new ByteArrayInputStream(int_bytes);
  ObjectInputStream ois = new ObjectInputStream(bis);
  int my_int = ois.readInt();
  ois.close();
  return my_int;
}