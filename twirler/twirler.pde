import processing.pdf.*;
import java.util.Calendar;

boolean savePDF = false;

class Clock
{
  float angle = 0;
  float radius = random(10, 200);
  float rotSpeed = random(-1, 1);
   
  float rnoise = random(10, 100);
   
  float scolor = random(0,125);
  float colorSpeed = random(0.1, 0.5);
  int cdir = 1;
   
  int x = 0;
  int y = 0;
   
  float x2 = 0;
  float y2 = 0;
   
   
  public Clock(int cx, int cy)
  {
    x = cx;
    y = cy;
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
    stroke(256*(mouseX/1080), 256*(mouseY/1920), 256*(mouseY/1080), 40);
    strokeWeight(1);
     
    if(isDraw)
      line(x,y,x2,y2);
  }
}
 
Clock[] cs;
int clockNum = 4;
 
void setup()
{
  fullScreen();
  //size(1920, 1080);
  background(50);
  cs = new Clock[ clockNum ];
   
  for( int i=0; i<clockNum; i++ )
  {
    cs[i] = new Clock(width/2, height/2);
  }
   
  frameRate( 20 );
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

void keyReleased() {
  if (key == 's' || key == 'S') saveFrame(timestamp()+"_##.png");
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