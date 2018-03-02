import tech.lity.rea.skatolo.*;
import tech.lity.rea.skatolo.gui.controllers.*;
import java.awt.Frame;


ControlFrame cf;


Bang saveScanBang, decodeBang;

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

    int width = ardisplay.getWidth();
    int height = ardisplay.getHeight();

    skatolo.addSlider("fx").plugTo(parent, "fx")
	.setPosition(10, 20)
	.setRange(900, 1400)
	.setSize(800,10)
	.setValue(1070)
	;
    skatolo.addSlider("fy").plugTo(parent, "fy")
	.setPosition(10, 40)
	.setRange(900, 1400)
	.setSize(800,10)
	.setValue(1070)
	;

    skatolo.addSlider("cx").plugTo(parent, "cx")
	.setPosition(10, 60)
	.setRange(0, width  *2)
	.setSize(800,20)
	.setValue(width / 2)
	;

    skatolo.addSlider("cy").plugTo(parent, "cy")
	.setPosition(10, 100)
	.setSize(800,20)
	.setRange(-100 , 200)
	.setValue(5)
	;

  }

  public void draw() {
      background(100);
  }

  public Skatolo control() {
    return skatolo;
  }
}
