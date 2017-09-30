import hype.*;
import hype.extended.behavior.*;
import hype.extended.colorist.*;
import hype.extended.layout.*;
import hype.interfaces.*;

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim 			minim;
AudioPlayer		myAudio;
FFT				myAudioFFT;

boolean 		showVisualizer 		= false;

int 			myAudioRange		= 11;
int 			myAudioMax 			= 100;

float 			myAudioAmp			= 40.0;
float 			myAudioIndex		= 0.2;
float 			myAudioIndexAmp		= myAudioIndex;
float 			myAudioIndexStep	= 0.35;

float[] myAudioData				= new float [myAudioRange];


HDrawablePool pool;
int poolMax 		= 6;

					// red 		green
color[] palette 	= { #FF0000,	#00FF00, #0000FF, #00FFFF, #FFFF00, #FF00FF};

int oRadiusMin 		= 125;
int oRadiusMax 		= 250;

void setup() {
	size(700, 700, OPENGL);
	H.init(this).background(#000000).use3D(true).autoClear(true);

	minim   = new Minim(this);
	myAudio = minim.loadFile("HECQ_With_Angels_Trifonic_Remix.wav");
	myAudio.loop();

	myAudioFFT = new FFT(myAudio.bufferSize(), myAudio.sampleRate());
	myAudioFFT.linAverages(myAudioRange);
	// myAudioFFT.window(FFT.GAUSS);

	pool = new HDrawablePool(poolMax);
	pool.autoAddToStage()
		.add ( new HSphere() )
		.onCreate (
			new HCallback() {
				public void run(Object obj) {
					int i = pool.currentIndex();

					HDrawable d = (HDrawable) obj;
					d
						.size(10)
						.noStroke()
						.fill(palette[i])
						.anchorAt(H.CENTER)
					;

					HOrbiter3D orb = new HOrbiter3D(width/2, height/2, 0)
						.target(d)
						.zSpeed( random(-2, 2)+0.1 )
						.ySpeed( random(-1, 1)+0.1 )
						.radius(250)
						.zAngle( (int)random(360) )
						.yAngle( (int)random(360) )
					;

					d.extras( new HBundle().num("i", i).obj("o", orb) ) ;

				}
			}
		)
		.requestAll()
	;
}

void draw() {
	myAudioFFT.forward(myAudio.mix);
	myAudioDataUpdate();

	noLights();
	lights();
	H.drawStage();
	sphereDetail(10);
	H.drawStage();
	noLights();

	for (HDrawable d : pool) {
		HBundle tempExtra = d.extras();
		int i = (int)tempExtra.num("i");
		HOrbiter3D o = (HOrbiter3D) tempExtra.obj("o");

		// create lights MAPPED to 3D orbits for sphere in the center

		int fftRadius;

		switch (i) {
			case 0 :
				pointLight(255, 0, 0,   o.x(), o.y(), o.z()); // RED
				fftRadius = (int)map(myAudioData[i], 0, myAudioMax, oRadiusMin, oRadiusMax);
				o.radius(fftRadius);
			break;

			case 1 :
				pointLight(0, 255, 0,   o.x(), o.y(), o.z()); // GREEN
				fftRadius = (int)map(myAudioData[i], 0, myAudioMax, oRadiusMin, oRadiusMax);
				o.radius(fftRadius);
			break;

			case 2 :
				pointLight(0, 0, 255,   o.x(), o.y(), o.z()); // BLUE
				fftRadius = (int)map(myAudioData[i], 0, myAudioMax, oRadiusMin, oRadiusMax);
				o.radius(fftRadius);
			break;

			case 3 :
				pointLight(0, 255, 255, o.x(), o.y(), o.z()); // CYAN
				fftRadius = (int)map(myAudioData[i], 0, myAudioMax, oRadiusMin, oRadiusMax);
				o.radius(fftRadius);
			break;

			case 4 :
				pointLight(255, 255, 0, o.x(), o.y(), o.z()); // YELLOW
				fftRadius = (int)map(myAudioData[i], 0, myAudioMax, oRadiusMin, oRadiusMax);
				o.radius(fftRadius);
			break;

			case 5 :
				pointLight(255, 0, 255, o.x(), o.y(), o.z()); // MAGENTA
				fftRadius = (int)map(myAudioData[i], 0, myAudioMax, oRadiusMin, oRadiusMax);
				o.radius(fftRadius);
			break;
		}
	}


	// draw sphere in the center

	pushMatrix();
		translate(width/2, height/2, 0);
		sphereDetail(75);
		noStroke(); fill(255); sphere(125); noStroke(); noFill();
	popMatrix();


	if (showVisualizer) myAudioDataWidget();
}

void myAudioDataUpdate() {

	for (int i = 0; i < myAudioRange; ++i) {
		float tempIndexAvg 	= (myAudioFFT.getAvg(i) * myAudioAmp) * myAudioIndexAmp;
		float tempIndexCon = constrain(tempIndexAvg, 0, myAudioMax);
		myAudioData[i]		= tempIndexCon;
		myAudioIndexAmp+=myAudioIndexStep;
	}
	myAudioIndexAmp = myAudioIndex;
}

void myAudioDataWidget() {
	noLights();
	hint(DISABLE_DEPTH_TEST);
	noStroke(); fill(0,200); rect(0, height-112, width, 102);

	for (int i = 0; i < myAudioRange; ++i) {
		if 		(i==0) 	fill(#237D26); // base / sub item 0
		else if (i==3) 	fill(#80C41C); // snare / sub item 3
		else			fill(#CCCCCC); // others

		rect(10 + (i*5), (height-myAudioData[i])-11, 4, myAudioData[i]);
	}
	hint(ENABLE_DEPTH_TEST);
}

void stop() {
	myAudio.close();
	minim.stop();
	super.stop();
}










