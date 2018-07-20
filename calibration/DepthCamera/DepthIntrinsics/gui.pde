import tech.lity.rea.skatolo.*;
import tech.lity.rea.skatolo.gui.controllers.*;
import java.awt.Frame;


ControlFrame cf = null;

void initGui(){

    cf = new ControlFrame();
}

// the ControlFrame class extends PApplet, so we
// are creating a new processing applet inside a
// new frame with a skatolo object loaded
public class ControlFrame extends PApplet {
    int w, h;
    Skatolo skatolo;

    public void settings(){
        size(1000, 300);
    }

    public ControlFrame() {
	super();
	PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    }

    public void setup() {
	frameRate(25);
	skatolo = new Skatolo(this);

	// add a horizontal sliders, the value of this slider will be linked
	// to variable 'sliderValue'

	initFocals();

	skatolo.addSlider("irFx").plugTo(parent, "irFx")
	    .setPosition(10, 20)
	    .setRange(400, 600)
	    .setSize(800,10)
	    .setValue(irDevice.getFx());
	    ;

	skatolo.addSlider("irFy").plugTo(parent, "irFy")
	    .setPosition(10, 40)
	    .setRange(400, 600)
	    .setSize(800,10)
	    .setValue(irDevice.getFx());
	    ;


	skatolo.addSlider("irCx").plugTo(parent, "irCx")
	    .setPosition(10, 60)
	    .setRange(640 / 2 - 100, 640 / 2 + 100)
	    .setSize(800,10)
	    .setValue(irDevice.getCx());
	    ;

	skatolo.addSlider("irCy").plugTo(parent, "irCy")
	    .setPosition(10, 80)
	    .setRange(480 / 2 - 100, 480 / 2 + 100)
	    .setSize(800,10)
	    .setValue(irDevice.getCy());
	    ;


	skatolo.addSlider("rgbFx").plugTo(parent, "rgbFx")
	    .setPosition(10, 120)
	    .setRange(400, 600)
	    .setSize(800,10)
	    .setValue(rgbDevice.getFx());
	    ;

	skatolo.addSlider("rgbFy").plugTo(parent, "rgbFy")
	    .setPosition(10, 140)
	    .setRange(400, 600)
	    .setSize(800,10)
	    .setValue(rgbDevice.getFx());
	    ;


	skatolo.addSlider("rgbCx").plugTo(parent, "rgbCx")
	    .setPosition(10, 160)
	    .setRange(640 / 2 - 100, 640 / 2 + 100)
	    .setSize(800,10)
	    .setValue(rgbDevice.getCx());
	    ;

	skatolo.addSlider("rgbCy").plugTo(parent, "rgbCy")
	    .setPosition(10, 180)
	    .setRange(480 / 2 - 100, 480 / 2 + 100)
	    .setSize(800,10)
	    .setValue(rgbDevice.getCy());
	    ;

	skatolo.addSlider("rx").plugTo(parent, "rx")
	    .setPosition(10, 200)
	    .setRange(-PI/32, PI/32)
	    .setSize(800,10)
	    .setValue(0);
	;
	
	skatolo.addSlider("ry").plugTo(parent, "ry")
	    .setPosition(10, 210)
	    .setRange(-PI/32, PI/32)
	    .setSize(800,10)
	    .setValue(0);
	;
	skatolo.addSlider("rz").plugTo(parent, "rz")
	    .setPosition(10, 220)
	    .setRange(-PI/32, PI/32)
	    .setSize(800,10)
	    .setValue(0);
	;


	skatolo.addSlider("tx").plugTo(parent, "tx")
	    .setPosition(10, 230)
	    .setRange(-30, 30)
	    .setSize(800,10)
	    .setValue(-25);
	;
	skatolo.addSlider("ty").plugTo(parent, "ty")
	    .setPosition(10, 240)
	    .setRange(-30, 30)
	    .setSize(800,10)
	    .setValue(0);
	;
	skatolo.addSlider("tz").plugTo(parent, "tz")
	    .setPosition(10, 250)
	    .setRange(-30, 30)
	    .setSize(800,10)
	    .setValue(0);
	;

	    
    }

    public void draw() {
	background(100);
    }

    public Skatolo control() {
	return skatolo;
    }
}
