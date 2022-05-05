import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioInput ai;
AudioBuffer ab;
AudioPlayer ap;
FFT fft;

//Made by Michele Marchese Andreu C21741655 start
float halfH;
float prev_average = 0;
int num = 1024;
float[] gradiant = new float[num];
int x =1;
float theta;
float speed = 0;
float lerpedSize = 0;
float stars = 100;
float[] posX = new float[num];
float[] posY = new float[num];
float last_time_check;
float time_interval;
int diameter = 16;
float t = 0;
float dt = 0.1f;
float amplitude = 100;
float frequency = 0.5;
PGraphics gc;


void setup(){
  size(1000,1000,P3D);
  minim = new Minim(this);
  ap = minim.loadFile("Hiding in the blue.mp3",1024);
  ap.play();
  ab = ap.mix;
  halfH = height/2;
  last_time_check = millis();
  time_interval = 20000;
  gc = createGraphics(width,height,P2D);
  
  colorInc = 255/(float)ab.size();
  
  w = width+16;
  dx = (TWO_PI / period) * xspace;
  yvalues = new float[1000/xspace];
  
  fft = new FFT( ap.bufferSize(), ap.sampleRate() );
 
  fft.linAverages(bands);
}

void draw(){
  background(0);
  if (millis() >= 0 && millis() <= last_time_check + 64000 ){
    part_3();
  }
  if (millis() >= last_time_check + 64000 && millis() <= last_time_check + 115000){
    part_2();
  }
  if (millis() >= last_time_check + 115000 && millis() <= last_time_check + 180000 ){
    part_4();
  }
  if (millis() >= last_time_check + 180000 ){
    part_1();
  }
}

void part_1(){
  stars();
  spaceship();
  lines();
  planets();
  fire();
  }

void part_2(){
  wave();
  island();
  circles();
  plants();
  }

void spaceship(){
  stroke(0,0,255);
  fill(0,0,255);
  rect(width/2-50,height/2-75,35,175);
  triangle(width/2-50,height/2-75,width/2-15,height/2-75,width/2-15,height/2-125);
  triangle(width/2-50,height/2+100,width/2-75,height/2+100,width/2-50,height/2+15);
  triangle(width/2,height/2-150,width/2+25,height/2-165,width/2+50,height/2-150);
  //fill(0,0,125);
  //stroke(0,0,125);
  rect(width/2-15,height/2-125,15,225);
  fill(0);
  stroke(0,0,255);
  strokeWeight(4);
  rect(width/2,height/2-150,50,250);
  
  strokeWeight(1);
  }
  
void lines(){
  //float sum = 0;
  for(int i = 0; i<ab.size(); i++){
    stroke(120,120,255);
    fill(i%256,255,255);
    line(0 - gradiant[i] * halfH * 2,i*2 ,0 + gradiant[i] * halfH * 2, i*2);
    line(width - gradiant[i] * halfH * 2,i*2 ,width + gradiant[i] * halfH * 2, i*2);
    gradiant[i] = lerp(gradiant[i], ab.get(i), 0.04f);
    //sum += abs(ab.get(i));
    }
  }
  
void planets(){
  float total = 0;
  for(int i = 0; i < ab.size(); i++){
    total += abs(ab.get(i));
    
  }
  float average = total/ (float)ab.size();
  float size = map(average, 0, 0.2f, 200, 0.1f);
  
  noFill();
  strokeWeight(1);
  stroke(lerpedSize%120,lerpedSize%120,255);
  lights();
  
  pushMatrix();
  translate(width * .25f, height* .25f, 0);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  
  lerpedSize = lerp(lerpedSize, size, 0.03F);
  sphere(lerpedSize);
  popMatrix();
  
  pushMatrix();
  translate(width * .75f, height* .75f, 0);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  
  lerpedSize = lerp(lerpedSize, size, 0.03F);
  sphere(lerpedSize);
  popMatrix();
  
  pushMatrix();
  translate(width * .25f, height* .75f, 0);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  
  lerpedSize = lerp(lerpedSize, size, 0.03F);
  box(lerpedSize);
  popMatrix();
  
  pushMatrix();
  translate(width * .75f, height* .25f, 0);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  
  lerpedSize = lerp(lerpedSize, size, 0.03F);
  box(lerpedSize);
  popMatrix();
  
  theta += speed;
  speed = map(width/2,0,width,0,0.05f);
  }
  
void fire(){
  float total = 0;
  for(int i = 0; i < ab.size(); i++){
    total += abs(ab.get(i));
    
  }
  float average = total/ (float)ab.size();
  float size = map(average, 0, 0.2f, 200, 0.1f);
  //lerpedSize = lerp(lerpedSize, size, 0.03F);
  noFill();
  stroke(0,0,255);
  strokeWeight(3);
  if(size>=0){
    lerpedSize = lerp(lerpedSize, size, 0.03F);
    triangle(width/2-50,height/2+100,width/2,height/2+100,width/2-25,height/2+100+lerpedSize);
    triangle(width/2-35,height/2+100,width/2-15,height/2+100,width/2-25,height/2+100+lerpedSize/3);
    }
  else{
    lerpedSize = lerp(lerpedSize, -size, 0.03F);
    triangle(width/2-50,height/2+100,width/2,height/2+100,width/2-25,height/2+100-lerpedSize);
    triangle(width/2-35,height/2+100,width/2-15,height/2+100,width/2-25,height/2+100-lerpedSize/3);
    }
  
  }
  
void stars(){
  fill(200);
  noStroke();
  for (int i = 0; i < stars; i++) {
    posX[i] = random(0, width);
    posY[i] = random(0, height);
    circle(posX[i], posY[i], 4);
  }
  delay(20);
}

void wave(){
  float total = 0;
  for(int i = 0; i < ab.size(); i++){
    total += abs(ab.get(i));
    
  }
  float average = total/ (float)ab.size();
  float size = map(average, 0, 0.2f, 200, 0.1f);
  lerpedSize = lerp(lerpedSize, size, 0.03F);
  noFill();
  strokeWeight(3);
  stroke(0,0,255);
  for(int i = 0; i < width/diameter+10; i++){
    ellipse(i*diameter, 750+(amplitude*sin(frequency*(t+i))*lerpedSize/100), diameter,diameter);
    }
   t += dt;
  }

void island(){
  rect(width/2-250,height/5+50,500,200);
  rect(width/2-350,height/5+50,100,100);
  rect(width/2+250,height/5+50,100,100);
  fill(0,0,255);
  stroke(0,0,145);
  rect(width/2-120,height/5-50,30,100);
  fill(0,0,145);
  circle(width/2-140,height/5-50,70);
  circle(width/2-70,height/5-50,70);
  circle(width/2-105,height/5-90,70);
  }

void circles(){
  float total = 0;
  for(int i = 0; i < ab.size(); i++){
    total += abs(ab.get(i));
    
  }
  float average = total/ (float)ab.size();
  float size = map(average, 0, 0.2f, 200, 0.1f);
  lerpedSize = lerp(lerpedSize, size, 0.03F);
  fill(70,70,255);
  strokeWeight(1);
  noStroke();
  lights();
  
  pushMatrix();
  translate(0, 0, 0);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  
  lerpedSize = lerp(lerpedSize, size, 0.03F);
  sphere(lerpedSize);
  popMatrix();
  
  pushMatrix();
  translate(width, 0, 0);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  
  lerpedSize = lerp(lerpedSize, size, 0.03F);
  sphere(lerpedSize);
  popMatrix();
  }

void plants(){
  float total = 0;
  for(int i = 0; i < ab.size(); i++){
    total += abs(ab.get(i));
    
  }
  float average = total/ (float)ab.size();
  float size = map(average, 0, 0.2f, 200, 0.1f);
  lerpedSize = lerp(lerpedSize, abs(size), 0.03F);
  fill(0,0,255);
  stroke(0,0,255);
  rect(width/2+100,height/5+50,25,220);
  rect(width/2-290,height/5+50,25,170);
  rect(width/2+270,height/5+50,25,140);
  triangle(width/2+100,height/5+270,width/2+125,height/5+270,width/2+112.5f,height/5+270+lerpedSize);
  triangle(width/2-290,height/5+220,width/2-265,height/5+220,width/2-277.5f,height/5+220+lerpedSize);
  triangle(width/2+270,height/5+190,width/2+295,height/5+190,width/2+282.5f,height/5+190+lerpedSize);
  }

//Made by Michele Marchese Andreu C21741655 end


//Kornelijas code starts
int xspace = 16;                
int w; 
float theta2 = 0.0;
float period = 500.0;  
float dx;  //function of period n xspace
float[] yvalues;  //store height value

int bands = 256; 
float[] spectrum = new float[bands];
float[] sum = new float[bands];

float unit;
int groundLineY;
PVector center;

//int x;
//int y;
float outsideRadius = 150;
float insideRadius = 100;

float lerpedAverage=0;
float[] lerpedBuffer = new float[1024];
float colorInc;

void part_3(){
  float sum = 0;
  gc.beginDraw();
  gc.background(0);
  gc.fill(0,0,0);
  
  gc.stroke(random(0,30),random(0,100),random(0,255));
  for(int i = 0; i < ab.size(); i++)
  {
    lerpedBuffer[i] = lerp(lerpedBuffer[i], ab.get(i), 0.06f);
    
    gc.stroke(10, 20, colorInc*i,90);
    gc.line(i, halfH-lerpedBuffer[i]*halfH * 5.0f, i, halfH+lerpedBuffer[i]*halfH*2 * 5.0f);
    //line(i,halfH,i, halfH+ab.get(i)*halfH);
    sum += abs(ab.get(i));
  }
   fill(160,160,255);
  drawship();
  calcWave();
  renderWave(); 
  renderWave2();
  renderWave3();
  sky();

  float average = sum / (float)ab.size();
  lerpedAverage = lerp(lerpedAverage,average, 0.1f);
}

void calcWave() {

   for(int i = 0 ; i < ab.size(); i++)
  {
  theta2 += 1;
  float x = theta;
  for (int z = 0; z < yvalues.length; z++) {
    yvalues[z] = sin(x)*200*lerpedBuffer[i]*3;
    x+=dx;
  }
  }
}



void renderWave() {
  noStroke();
  fill(255);

  for (int x = 0; x < yvalues.length; x++) {
    fill(10,50,205);
    ellipse(x*xspace, height-150+yvalues[x], 100, 6);
  }
}
void renderWave2() {
  noStroke();
  fill(255);

  for (int x = 0; x < yvalues.length; x++) {
    fill(10,100,255);
    ellipse(x*xspace, height-170+yvalues[x], 100, 6);
  }
}
void renderWave3() {
  noStroke();
  fill(255);

  for (int x = 0; x < yvalues.length; x++) {
    fill(10,40,185);
    ellipse(x*xspace, height-100+yvalues[x], 100, 50);
  }
}



void drawship(){
  gc.beginDraw();
  gc.stroke(10,80,190);
  gc.fill(0,140,200);
  gc.triangle(350,700,750,700,500,850);
  gc.fill(40,180,200);
  gc.triangle(250,670,350,700,500,850);
  gc.triangle(540,700,750,700,870,670);
  gc.rect(500,400,10,300);
  gc.fill(120,200,240);
  gc.triangle(510,400,650,450,510,550);
  gc.endDraw();
  image(gc,0,0);
}




void sky(){
  noStroke();
  fill(180,180,255);
  circle(124,200,2);
  circle(674,300,2);
  circle(24,250,2);
  circle(100,60,3);
  circle(800,230,3);
  circle(900,20,3);
}
//Kornelijas code ends

//Made by Finn Reynolds C21469622
float fps = 30;
float smoothingFactor = 0.25;
//int bands = 256; 
//float[] spectrum = new float[bands];
//float[] sum = new float[bands];
//float unit;
//int groundLineY;
//PVector center;
int sphereRadius;

float spherePrevX;
float spherePrevY;

int yOffset;

boolean initialStatic = true;
float[] extendingSphereLinesRadius;


void part_4(){
  unit = height / 120; 
  strokeWeight(unit / 4);
  groundLineY = height * 3/4;
  center = new PVector(width / 10, height * 3/4);
  
  fft.forward(ap.mix);
 
  spectrum = new float[bands];
 
  for(int i = 0; i < fft.avgSize(); i++)
  {
    spectrum[i] = fft.getAvg(i) / 2;
 

    sum[i] += (abs(spectrum[i]) - sum[i]) * smoothingFactor;
  }
 

  fill(0,0,255);
  
  rect(0, 0, width, height);
  noFill();
 
  drawAll(sum);
}

void drawStatic() {
 
  if (initialStatic) {
    extendingSphereLinesRadius = new float[241];
 
    for (int angle = 0; angle <= 240; angle += 4) {
      extendingSphereLinesRadius[angle] = map(random(1), 0, 1, sphereRadius, sphereRadius * 7);
    }
 
    initialStatic = false;
  }
  

  for (int angle = 0; angle <= 240; angle += 4) {

    float x = round(cos(radians(angle + 150)) * sphereRadius + center.x);
    float y = round(sin(radians(angle + 150)) * sphereRadius + groundLineY - yOffset);
 
    float xDestination = x;
    float yDestination = y;
    

    for (int i = sphereRadius; i <= extendingSphereLinesRadius[angle]; i++) {
      float x2 = cos(radians(angle + 150)) * i + center.x;
      float y2 = sin(radians(angle + 150)) * i + groundLineY - yOffset;
 
      if (y2 <= getGroundY(x2)) { 
        xDestination = x2;
        yDestination = y2;
      }
    }
    
    stroke(255);
 
    if (y <= getGroundY(x)) {
      line(x, y, xDestination, yDestination);
    }
  }
}


void drawAll(float[] sum) {
 
  sphereRadius = 30 * round(unit);

  spherePrevX = 0;
  spherePrevY = 0;

  yOffset = round(sin(radians(150)) * sphereRadius);

  drawStatic();
 

  float x = 0;
  float y = 0;
  int surrCount = 1;
  
   boolean direction = false;
 
  while (x < width * 1.5 && x > 0 - width / 2) {

    float surroundingRadius;
 
    float surrRadMin = sphereRadius + sphereRadius * 1/2 * surrCount;
    float surrRadMax = surrRadMin + surrRadMin * 1/8;

    float surrYOffset;
 
    float addon = frameCount * 1.5;
 
    if (direction) {
      addon = addon * 1.5;
    }

    for (float angle = 0; angle <= 240; angle += 1.5) {
 
      surroundingRadius = map(sin(radians(angle * 20 + addon)), -0.5, 3, surrRadMin, surrRadMax); 
 
      surrYOffset = sin(radians(150)) * surroundingRadius;

      x = round(cos(radians(angle + 20)) * surroundingRadius + center.x);
      y = round(sin(radians(angle + 32)) * surroundingRadius + getGroundY(x) - surrYOffset);

      
      fill(map(surroundingRadius, surrRadMin, surrRadMax, 100, 255));
      circle(x, y, 3 * unit / 50);
      noFill();
    }

    direction = !direction;
 
    surrCount += 1;
  }
  

  float extendingLinesMin = sphereRadius * 1.3;
  float extendingLinesMax = sphereRadius * 3.5; 
 
  float xDestination;
  float yDestination;
 
  for (int angle = 0; angle <= 240; angle++) {

    float extendingSphereLinesRadius = map(noise(angle * 0.3), 0, 1, extendingLinesMin, extendingLinesMax);
 
   
    if (sum[0] != 0) {
      if (angle >= 0 && angle <= 30) {
        extendingSphereLinesRadius = map(sum[240 - round(map((angle), 0, 30, 0, 80))], 0, 0.8, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax * 1.5); 
      }
 
      else if (angle > 30 && angle <= 90) {
        extendingSphereLinesRadius = map(sum[160 - round(map((angle - 30), 0, 60, 0, 80))], 0, 3, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax * 1.5); 
      }
 
      else if (angle > 90 && angle <= 120) {
        extendingSphereLinesRadius = map(sum[80 - round(map((angle - 90), 0, 30, 65, 80))], 0, 40, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax * 1.5); 
      }
 
      else if (angle > 120 && angle <= 150) {
        extendingSphereLinesRadius = map(sum[0 + round(map((angle - 120), 0, 30, 0, 15))], 0, 40, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax * 1.5); 
      }
 
      else if (angle > 150 && angle <= 210) {
        extendingSphereLinesRadius = map(sum[80 + round(map((angle - 150), 0, 60, 0, 80))], 0, 3, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax * 1.5); 
      }
 
      else if (angle > 210) {
        extendingSphereLinesRadius = map(sum[160 + round(map((angle - 210), 0, 30, 0, 80))], 0, 0.8, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax * 1.5); 
      }
    }
    
     x = round(cos(radians(angle + 150)) * sphereRadius + center.x);
    y = round(sin(radians(angle + 150)) * sphereRadius + groundLineY - yOffset);

    xDestination = x;
    yDestination = y;

    for (int i = sphereRadius; i <= extendingSphereLinesRadius; i++) {
      int x2 = round(cos(radians(angle + 150)) * i + center.x);
      int y2 = round(sin(radians(angle + 150)) * i + groundLineY - yOffset);
 
      if (y2 <= getGroundY(x2)) { 
        xDestination = x2;
        yDestination = y2;
      }
    }
    
      stroke(map(extendingSphereLinesRadius, extendingLinesMin, extendingLinesMax, 200, 255));
 
    if (y <= getGroundY(x))  {
      line(x, y, xDestination, yDestination);
    }
  }


  for (int groundX = 0; groundX <= width; groundX++) {

    float groundY = getGroundY(groundX);

    
    fill(255);
    circle(groundX, groundY, 1.8 * unit / 10.24);
    noFill();
  }
}

float getGroundY(float groundX) {

  float angle = 1.1 * groundX / unit * 10.24;

  float groundY = sin(radians(angle + frameCount * 2)) * unit * 1.25 + groundLineY - unit * 1.25;

  return groundY;
}
//Made by Finn Reynolds C21469622
//Parts of this code were created by kassianh
