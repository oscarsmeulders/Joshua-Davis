import hype.*;
import hype.extended.behavior.*;
import hype.extended.colorist.*;
import hype.extended.layout.*;
import hype.interfaces.*;

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim 		minim;
AudioPlayer	myAudio;
FFT			myAudioFFT;

boolean 	showVisualizer 		= false;

int 		myAudioRange		= 11;
int 		myAudioMax 			= 100;

float 		myAudioAmp			= 40.0;
float 		myAudioIndex		= 0.2;
float 		myAudioIndexAmp		= myAudioIndex;
float 		myAudioIndexStep	= 0.35;

float[] myAudioData				= new float [myAudioRange];



HDrawablePool pool;

					// base						// snare
color [] palette = {#000000,#666666,#666666,	#FFFFFF, #666666,#666666,#666666,#666666,#666666,#666666,#666666};

int poolCols	= 5;
int poolRows	= 5;
int poolDepth	= 5;

void setup() {
	size(700, 700, P3D);
	H.init(this).background(#FF3300).use3D(true).autoClear(true);

	minim   = new Minim(this);
	myAudio = minim.loadFile("HECQ_With_Angels_Trifonic_Remix.wav");
	myAudio.loop();

	myAudioFFT = new FFT(myAudio.bufferSize(), myAudio.sampleRate());
	myAudioFFT.linAverages(myAudioRange);
	// myAudioFFT.window(FFT.GAUSS);

	pool = new HDrawablePool(poolCols*poolRows*poolDepth);
	pool.autoAddToStage()
		.add ( new HSphere() )
		.layout (new HGridLayout().startX(-300).startY(-300).startZ(-300).spacing(150, 150, 150).rows(poolRows).cols(poolCols))
		.onCreate (
			new HCallback() {
				public void run(Object obj) {
					int ranIndex = (int)random(myAudioRange);

					HSphere d = (HSphere) obj;
					d
						.size(10)
						.strokeWeight(0)
						.noStroke()
						.fill(palette[ranIndex], 255)
						.anchorAt(H.CENTER)
						.extras( new HBundle().num("i", ranIndex) )
					;
				}
			}
		)
		.requestAll()
	;
}

void draw() {
	myAudioFFT.forward(myAudio.mix);
	myAudioDataUpdate();

	lights();
	sphereDetail(20);

	pushMatrix();
		translate(width/2, height/2, -900);
		rotateY( radians(frameCount) );
		H.drawStage();

		stroke (#333333); fill(#242424, 50); box(600); noStroke(); noFill(); 

	popMatrix();

	for (HDrawable d : pool) {
		HBundle tempExtra = d.extras();
		int i = (int)tempExtra.num("i");

		int fftSize;

		if (i==0) 		fftSize = (int)map(myAudioData[i], 0, myAudioMax, -350, 350);
		else if (i==3)	fftSize = (int)map(myAudioData[i], 0, myAudioMax, 50, 350);
		else			fftSize = (int)map(myAudioData[i], 0, myAudioMax, 2, 150);

		d.size(fftSize);
	}

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










