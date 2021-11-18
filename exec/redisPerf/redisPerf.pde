
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
import java.awt.image.WritableRaster;
    
import java.awt.image.BufferedImage;
import javax.imageio.stream.*;
import javax.imageio.*;

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
  frameRate(45);
}


void draw() {
    //    background(0);
    rect(mouseX, mouseY, 10, 10);
     
    loadPixels();
    updatePixels();

    // byte[] compressed = jpegCompress();
    jpegCompress();
    //    sendRaw();
    

    println("framerate: " + frameRate);
}

void keyPressed() {
}

void sendRaw(){
    ByteArrayOutputStream bos = new ByteArrayOutputStream();
    ObjectOutput out = null;
    byte[] id = {(byte) 0};
    try {
  	out = new ObjectOutputStream(bos);
	
	// Pixels directly
	out.writeObject(pixels);
	out.flush();
	byte[] yourBytes = bos.toByteArray();
	redis.set(id, yourBytes);
	
    }
    catch(Exception e) {
  	e.printStackTrace();
    }
}



// https://stackoverflow.com/questions/37713773/java-bufferedimage-jpg-compression-without-writing-to-file?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa

//PImage outputImg = null;
BufferedImage bimg = null;

void jpegCompress(){
    try{


	if(bimg == null){
	    //	    outputImg = createImage(width, height, RGB);
	    bimg = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
	}

	// Copy the pixels
	loadPixels();
	WritableRaster wr = bimg.getRaster();
	wr.setDataElements(0, 0, width, height, pixels);

	BufferedImage image =bimg;

	// The important part: Create in-memory stream
	ByteArrayOutputStream compressed = new ByteArrayOutputStream();
	ImageOutputStream outputStream = ImageIO.createImageOutputStream(compressed);
    
    // NOTE: The rest of the code is just a cleaned up version of your code
    
    // Obtain writer for JPEG format
    ImageWriter jpgWriter = ImageIO.getImageWritersByFormatName("jpg").next();
    
    // Configure JPEG compression: 70% quality
    ImageWriteParam jpgWriteParam = jpgWriter.getDefaultWriteParam();
    jpgWriteParam.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);

    float compression = (float) mouseX / (float) width;
    jpgWriteParam.setCompressionQuality(compression);
    
    // Set your in-memory stream as the output
    jpgWriter.setOutput(outputStream);
    
    // Write image as JPEG w/configured settings to the in-memory stream
    // (the IIOImage is just an aggregator object, allowing you to associate
    // thumbnails and metadata to the image, it "does" nothing)
    jpgWriter.write(null, new IIOImage(image, null, null), jpgWriteParam);
    
    // Dispose the writer to free resources
    jpgWriter.dispose();
    
    // Get data for further processing...
    byte[] jpegData = compressed.toByteArray();

    byte[] id2 = {(byte) 1};
    redis.set(id2, jpegData);

    }catch(IOException e){
	System.out.println(e);
	return;
    }
}



Redis redis;

void connect() {
  redis = new Redis(this, "192.168.0.52", 6379);
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
