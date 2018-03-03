import fr.inria.papart.procam.camera.*;


public class MyApp  extends PaperScreen {

    TrackedView boardView;

    // 5cm
    PVector captureSize = new PVector(300, 200);
    PVector origin = new PVector(0, 0);
    int picSize = 64; // Works better with power  of 2

    int w = (int) (188), h = (int) (125);
    
    void settings(){
	setDrawingSize(300, 200);
	loadMarkerBoard(Papart.markerFolder + "A4-default.svg", 300, 200);

	// same with setDrawAroundPaper();
	setDrawOnPaper();
    }

    void setup() {
	boardView = new TrackedView(this);
	boardView.setCaptureSizeMM(captureSize);

	boardView.setImageWidthPx(w);
	boardView.setImageHeightPx(h);
	// boardView.setImageWidthPx(300);
	// boardView.setImageHeightPx(200);
	conv = createImage(w, h, RGB);
	eroded = createImage(w, h, RGB);

        boardView.setTopLeftCorner(origin);
	boardView.init();
    }

    PImage conv, eroded;
    
    // Same with drawAroundPaper().
    void drawOnPaper() {
        clear();
	//        setLocation(63, 45, 0);

        stroke(100);
        noFill();
        strokeWeight(2);

	line(0, 0, origin.x, origin.y);
	rect((int) origin.x, (int) origin.y,
             (int) captureSize.x, (int)captureSize.y);
	
        PImage out = boardView.getViewOf(cameraTracking);
	
	if(out != null){
	    //	    image(out, 120, 40, picSize, picSize);

	    PImage img = out;
	    int xstart = 0;
	    int ystart = 0;
	    int xend = out.width;
	    int yend = out.height;
	    int matrixsize = 5;
	    conv.loadPixels();
	    // Begin our loop for every pixel in the smaller image
	    for (int x = xstart; x < xend; x++) {
		for (int y = ystart; y < yend; y++ ) {
		    color c = convolution(x, y, matrix5conv, matrixsize, img);
		    int loc = x + y*img.width;
		    conv.pixels[loc] = c;
		}
	    }
	    // ready for rendering
	    conv.updatePixels();
	    //	    image(conv, 0, 0, 300/2, 200/2);
	    
	    eroded.loadPixels();


	    noStroke();
	    
	    for (int x = xstart; x < xend; x++) {
		for (int y = ystart; y < yend; y++ ) {
		    color c = erosion(x, y, matrix3erode, 3, conv);
		    int loc = x + y*img.width;
		    eroded.pixels[loc] = c;
		    if(red(eroded.pixels[loc]) >= max
		       ||  green(eroded.pixels[loc]) >= max
		       ||  blue(eroded.pixels[loc]) >= max
		       ){
			fill(eroded.pixels[loc], 150);
			float dx = (float) x  / (float) w * drawingSize.x;
			float dy =(float) y  / (float) h * drawingSize.y;
			ellipse(dx, dy, 10, 10);
		    }
		}
	    }
	    eroded.updatePixels();
	    //	    image(eroded, 300/2, 0, 300/2, 200/2);
	    
	    if(cap){
		cap = false;
		out.save(sketchPath() + "/out.png");
		conv.save(sketchPath() + "/conv.png");
		eroded.save(sketchPath() + "/eroded.png");
		println("Image saved");
	    }
	}
    }
}

boolean cap = false;
void keyPressed(){

    if(key == 'c'){
	cap = true;
    }
}
