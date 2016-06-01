import processing.pdf.*;
import java.util.Calendar;
import java.util.ArrayList;

boolean savePDF = false;

PrintWriter textout;

String fileNameStamp;

ArrayList<Line> lineArray;

float bgRandom;

//----------------------------------------------------------------------------------------------------- Class Clock -----------------------------------------------------------------------
class Clock
{
  float angle = 0;
  float radius = random(10, 200);//20*random(10, 200);
  float rotSpeed = random(-1, 1);
   
  float rnoise = random(10, 100);
   
  float scolor = random(0,125);
  float colorSpeed = random(0.1, 0.5);
  int cdir = 1;
     
  int x = 0;
  int y = 0;
   
  float x2 = 0;
  float y2 = 0;
  
  float a = random(0,256);
  float b = random(0,256);
  float c = random(0,256);
  //float d = random(0,256);
  float d = 10;
   
   
  public Clock(int cx, int cy)
  {
    x = cx;
    y = cy;
    fileNameStamp = timestamp();
    if(createText) textout = createWriter(fileNameStamp + "_positions.txt");
  }
   
  public void setCenter(float inx, float iny)
  {
    x = int(inx);
    y = int(iny);
  }
   
  public void tick()
  {
    angle += rotSpeed;
     
    if(angle > 360)
      angle -= 360;
    else if(angle < 0)
      angle += 360;
       
    scolor += colorSpeed * cdir;
     
    if( scolor >= 255 )
      cdir = -1;
    else if( scolor <= 125)
      cdir = 1;
  }
   
  public void display(boolean isDraw)
  {
    float radius2 = 100+radius*noise(angle/100,rnoise);
    x2 = x+radius2*sin(radians(angle));
    y2 = y+radius2*cos(radians(angle));
     
    //stroke(scolor,40);
    colorMode(RGB, 256, 256, 256, 100);
    stroke(a,b,c,d);
    strokeWeight(1);
     
    if(isDraw){
      if(createText) textout.println("_sx_" + (int)x + "_sy_" + (int)y + "_ex_" + (int)x2 + "_ey_" + (int)y2 + "_r_" + (int)a + "_g_" + (int)b + "_b_" + (int)c + "_a_" + (int)d + ",");
      Line myLine = new Line(x,y,x2,y2,a,b,c,d);
      myLine.lineDraw();
      lineArray.add(myLine);
    }
  }
}

//----------------------------------------------------------------------------------------------------- Class Line -----------------------------------------------------------------------
class Line{
  float xs; 
  float ys; 
  float xf; 
  float yf; 
  int mr; 
  int mg; 
  int mb; 
  int ma;
  public Line(float x, float y, float x2, float y2, float r, float g, float b, float a){
    xs=x;  
    ys=y;  
    xf=x2;  
    yf=y2;  
    mr=(int)r;  
    mg=(int)g; 
    mb=(int)b;  
    ma=(int)a;
    
  }
  
  public void lineDraw(){
    //stroke(mr, mg, mb, ma);
    line(xs, ys, xf, yf);
  }
  
  public float x(){ 
    return xs;
  }
  public float y(){ 
    return ys;
  }
  public float x2(){ 
    return xf;
  }
  public float y2(){ 
    return yf;
  }
  public int r(){ 
    return mr;
  }
  public int g(){ 
    return mg;
  }
  public int b(){ 
    return mb;
  }
  public int a(){ 
    return ma;
  }
}

//----------------------------------------------------------------------------------------------------- Settings -----------------------------------------------------------------------

Clock[] cs;
int clockNum = 3;
int pScale = 10;
int fRate = 60;
int windowScaleX = 1000;
int windowScaleY = 1000;
int bgColor = 255;
boolean randomBackground = true;
boolean createText = false;

//----------------------------------------------------------------------------------------------------- Code ---------------------------------------------------------------------------
void setup()
{
  //size(resolution,resolution);
  //fullScreen();
  size(500,500);
  surface.setSize(windowScaleX, windowScaleY);
  if (randomBackground){
    bgRandom = random(0,255);
    background(bgRandom);
  }
  if (!randomBackground) background(bgColor);
  //pixelDensity(2);
  
  lineArray = new ArrayList();

  //background(0,0,0,0);
  cs = new Clock[ clockNum ];
   
  for( int i=0; i<clockNum; i++ )
  {
    cs[i] = new Clock(width/2, height/2);
  }
   
  frameRate( fRate );
}
 
void draw ()
{
  int tickPerFrame = 20;
  for(int i=0; i< tickPerFrame; i++)
  {
    for(int c=0; c< clockNum; c++)
    {
      if( c != 0 )
        cs[c].setCenter(cs[c-1].x2,cs[c-1].y2);
       
      cs[c].tick();
       
      if( c != 0 )
        cs[c].display(true);
      else
        cs[c].display(false);
    }
   
  }
}

//----------------------------------------------------------------------------------------------------- Higher Resolution -----------------------------------------------------------------------

void saveLargeImage(String name){
  Line curLine;
  
  PGraphics p = createGraphics(pScale*windowScaleX,pScale*windowScaleY);
  p.beginDraw();
  p.strokeWeight(5);
  if (randomBackground) p.background(bgRandom);
  if (!randomBackground) p.background(bgColor);
  p.colorMode(RGB, 256, 256, 256, 100);
  for(int i = 0; i < lineArray.size(); i++){
    curLine = lineArray.get(i);
    p.stroke(curLine.r(), curLine.g(), curLine.b(), curLine.a());
    p.line(pScale*curLine.x(), pScale*curLine.y(), pScale*curLine.x2(), pScale*curLine.y2());
  }
  
  p.save(name);
}

//----------------------------------------------------------------------------------------------------- Key Presses -----------------------------------------------------------------------


void keyReleased() {
  if (key == 's' || key == 'S') saveFrame(fileNameStamp+"_##.tif"); 
  if (key == 'x' || key == 'X') saveLargeImage("fullrez_" + fileNameStamp+ (int)random(0,100) +".tif");                        //Higher Resolution
  if (key == 'p' || key == 'P') savePDF = true;
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

void mousePressed() {
  
    setup();
    
}