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

					// base orange				// snare blue
color [] palette = {#FF3300,#FF620C,#FF9519,	#0095A8, #FFC725,#F8EF33,#FFFF33,#CCEA4A,#9AD561,#64BE7A,#2EA893};

int poolCols	= 5;
int poolRows	= 5;
int poolDepth	= 5;

void setup() {
	size(700, 700, P3D);
	H.init(this).background(#202020).use3D(true).autoClear(true);

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
						.strokeWeight(10)
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
	H.drawStage();
	sphereDetail(20);

	pushMatrix();
		translate(width/2, height/2, -900);
		rotateY( radians(frameCount) );
		H.drawStage();
	popMatrix();

	 // for (HDrawable d : pool) {
	//	HBundle tempExtra = d.extras();
	//	int i = (int)tempExtra.num("i");

	//	int fftFillColor	= (int)map(myAudioData[i], 0, myAudioMax, 0, 255);
	//	int fftZ			= (int)map(myAudioData[i], 0, myAudioMax, -900, 100);
	//	d.fill(fftFillColor, 225).z(fftZ);
	// }

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









