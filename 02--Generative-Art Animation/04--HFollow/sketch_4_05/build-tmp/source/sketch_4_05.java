import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import hype.*; 
import hype.extended.behavior.*; 
import hype.extended.colorist.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_4_05 extends PApplet {





// import hype.extended.layout.*;
// import hype.interfaces.*;

HFollow mf;
HRect r1;
HPixelColorist colors;

public void setup() {
	
	H.init(this).background(0xff202020).autoClear(false);
	

	colors = new HPixelColorist("sintra.jpg")
	.fillOnly()
	//.strokeOnly()
	//.fillAndStroke()
	;

	r1 = new HRect(100).rounding(40);
	r1
		.strokeWeight(2)
		.stroke(0xff000000, 150)
		.fill(0xff111111)
		.loc(width/2, height/2)
		.anchorAt(H.CENTER)
		.rotation(45)
	;

	H.add(r1);

	// - new HFollow(float ease)

	mf = new HFollow()
		.target(r1)
		.ease(0.5f)
		.spring(0.95f)
		;
}

public void draw() {

	colors.applyColor(r1);

	H.drawStage();
	
}
  public void settings() { 	size(640, 640); 	smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_4_05" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
