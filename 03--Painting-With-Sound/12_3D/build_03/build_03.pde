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

boolean 	showVisualizer 		= true;

int 		myAudioRange		= 11;
int 		myAudioMax 			= 100;

float 		myAudioAmp			= 40.0;
float 		myAudioIndex		= 0.2;
float 		myAudioIndexAmp		= myAudioIndex;
float 		myAudioIndexStep	= 0.35;

float[] myAudioData				= new float [myAudioRange];



HDrawablePool pool;

int poolCols	= 7;
int poolRows	= 7;

void setup() {
	size(700, 700, P3D);
	H.init(this).background(#202020).use3D(true).autoClear(true);

	minim   = new Minim(this);
	myAudio = minim.loadFile("HECQ_With_Angels_Trifonic_Remix.wav");
	myAudio.loop();

	myAudioFFT = new FFT(myAudio.bufferSize(), myAudio.sampleRate());
	myAudioFFT.linAverages(myAudioRange);
	// myAudioFFT.window(FFT.GAUSS);

	pool = new HDrawablePool(poolCols*poolRows);
	pool.autoAddToStage()
		.add ( new HBox() )
		.layout (new HGridLayout().startX(110).startY(110).spacing(80, 80).cols(poolCols))
		.onCreate (
			new HCallback() {
				public void run(Object obj) {
					int ranIndex = (int)random(myAudioRange);

					HBox d = (HBox) obj;
					d
						.depth(500)
						.width(50)
						.height(50)
						.noStroke()
						.fill(255, 225)
						.z(-900)
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

	pointLight(0, 149, 168, width/2, 0,       -100); // teal
	pointLight(255, 51, 0,  width/2, height,  -100); // orange
	pointLight(50, 50, 50,  width/2, height/2, 200); // gray

	H.drawStage();

	 for (HDrawable d : pool) {
		HBundle tempExtra = d.extras();
		int i = (int)tempExtra.num("i");

		int fftFillColor	= (int)map(myAudioData[i], 0, myAudioMax, 0, 255);
		int fftZ			= (int)map(myAudioData[i], 0, myAudioMax, -900, 100);
		d.fill(fftFillColor, 225).z(fftZ);
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










