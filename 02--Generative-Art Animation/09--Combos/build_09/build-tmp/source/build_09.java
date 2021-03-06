import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import hype.*; 
import hype.extended.behavior.*; 
import hype.extended.colorist.*; 
import hype.extended.layout.*; 
import hype.interfaces.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class build_09 extends PApplet {







HOscillator rX, rY, rZ;

ArrayList texList;
PImage[] pickedTex = new PImage[6];

int numCubes =20;
PVector[] pickedLoc = new PVector[numCubes];

float minScale = 40;
float maxScale = 100;
float[] boxSize = new float[numCubes];

public void setup() {
	
	H.init(this).background(0xffFFFFFF).use3D(true);
	

	// load in texture images
	PImage t1 = loadImage("tex1.png"); // 1
	PImage t2 = loadImage("tex2.png"); // 2
	PImage t3 = loadImage("tex3.png"); // 3
	PImage t4 = loadImage("tex4.png"); // 4

	// push textures to array
	texList = new ArrayList();
	texList.add(t1);
	texList.add(t2);
	texList.add(t3);
	texList.add(t4);

	for (int i=0; i < pickedTex.length; i++) {
		pickedTex[i] = (PImage)texList.get( (int)random(texList.size()) );
	
		boxSize[i] = random(minScale, maxScale);

	}

	println( pickedTex);

	textureMode(NORMAL);

	for (int i = 0; i < numCubes; i++) {
		// picked location
		PVector pt = new PVector();
		// middle of the screen pick a random x pos
		pt.x = (width/2) + (int)random(-200,200);
		pt.y = (height/2) + (int)random(-200,200);
		// 
		pt.z = (int)random(-100,100);
		// use array of 10 PVectors
		pickedLoc[i] = pt;

	}



	rX = new HOscillator()
		.range(-360,360)
		.speed(0.1f)
		.freq(5)
	;

	rY = new HOscillator()
		.range(-360,360)
		.speed(0.1f)
		.freq(5)
	;

	rZ = new HOscillator()
		.range(-360,360)
		.speed(0.1f)
		.freq(5)
	;
}

public void draw() {
	H.drawStage();

	// next raw value
	rX.nextRaw();
	rY.nextRaw();
	rZ.nextRaw();

	for (int i = 0; i < numCubes; ++i) {

	pushMatrix();

		// translate to the center of the stage
		translate( pickedLoc[i].x, pickedLoc[i].y, pickedLoc[i].z );
		// uses processing rotates
		rotateX( radians(rX.curr()) );
		rotateY( radians(rY.curr()) );
		rotateZ( radians(rZ.curr()) );
		buildCube(i);

	popMatrix();
	}
}

public void buildCube(int i) {

	strokeWeight(4); stroke(0xff000000);
	

		// Create a beginShape for each side

		// +Z "front" face
		beginShape(QUADS);
			texture( pickedTex[0] );
			vertex(-boxSize[i], -boxSize[i], boxSize[i], 0, 0);
			vertex( boxSize[i], -boxSize[i], boxSize[i], 1, 0);
			vertex( boxSize[i], boxSize[i], boxSize[i], 1, 1);
			vertex(-boxSize[i], boxSize[i], boxSize[i], 0, 1);
		endShape();

		// -Z "back" face
		beginShape(QUADS);
			texture( pickedTex[1] );
			vertex( boxSize[i], -boxSize[i], -boxSize[i], 0, 0);
			vertex(-boxSize[i], -boxSize[i], -boxSize[i], 1, 0);
			vertex(-boxSize[i],  boxSize[i], -boxSize[i], 1, 1);
			vertex( boxSize[i],  boxSize[i], -boxSize[i], 0, 1);
		endShape();

		// +Y "bottom" face
		beginShape(QUADS);
			texture( pickedTex[2] );
			vertex(-boxSize[i],  boxSize[i],  boxSize[i], 0, 0);
			vertex( boxSize[i],  boxSize[i],  boxSize[i], 1, 0);
			vertex( boxSize[i],  boxSize[i], -boxSize[i], 1, 1);
			vertex(-boxSize[i],  boxSize[i], -boxSize[i], 0, 1);
		endShape();

		// -Y "top" face
		beginShape(QUADS);
			texture( pickedTex[3] );
			vertex(-boxSize[i], -boxSize[i], -boxSize[i], 0, 0);
			vertex( boxSize[i], -boxSize[i], -boxSize[i], 1, 0);
			vertex( boxSize[i], -boxSize[i],  boxSize[i], 1, 1);
			vertex(-boxSize[i], -boxSize[i],  boxSize[i], 0, 1);
		endShape();

		// +X "right" face
		beginShape(QUADS);
			texture( pickedTex[4] );
			vertex( boxSize[i], -boxSize[i],  boxSize[i], 0, 0);
			vertex( boxSize[i], -boxSize[i], -boxSize[i], 1, 0);
			vertex( boxSize[i],  boxSize[i], -boxSize[i], 1, 1);
			vertex( boxSize[i],  boxSize[i],  boxSize[i], 0, 1);
		endShape();

		// -X "left" face
		beginShape(QUADS);
			texture( pickedTex[5] );
			vertex(-boxSize[i], -boxSize[i], -boxSize[i], 0, 0);
			vertex(-boxSize[i], -boxSize[i],  boxSize[i], 1, 0);
			vertex(-boxSize[i],  boxSize[i],  boxSize[i], 1, 1);
			vertex(-boxSize[i],  boxSize[i], -boxSize[i], 0, 1);
		endShape();


	endShape();

}




  public void settings() { 	size(600, 500, P3D); 	smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "build_09" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
