class Particle{
  PImage skin;
  float posX;
  float posY;
  float size;
  float timeLeft;
  float speedX;
  float speedY;
  
  void draw(){
    
  }
}

class StringParticle extends Particle{
  String text;
  color c;
  
  StringParticle(String s,float posX,float posY,float size,color c){
    text=s;
    this.c=c;
    this.posX=posX;
    this.posY=posY;
    this.size=size;
    timeLeft=size/40*120;
    particles.add(this);
  }
  
  void draw(){
    float tintValue=timeLeft/90.0*255;
    fill(c, tintValue);
    textSize(size);
    text(text,posX,posY);
    if(timeLeft>0)timeLeft--;
    else particles.remove(this);
  }
}

class fireExplosion extends Particle{
  
  fireExplosion(PImage skin,float x,float y){
    posX=x;
    posY=y;
    this.skin=skin;
    size=random(10,26);
    float angle=random(TWO_PI);
    float speed=random(0.5,4);
    speedX=cos(angle)*speed;
    speedY=sin(angle)*speed;
    particles.add(this);
  }
  
  void draw(){
    image(skin,posX,posY,size*2,size*2);
    posX=posX+speedX;
    posY=posY+speedY;
    size=size-24.0/120;
    if(size<=0)particles.remove(this);
  }
}

class shurikenParticle extends Particle{
  float angle;
  
  shurikenParticle(PImage skin,float x,float y,float sx,float sy){
    posX=x;
    posY=y;
    this.skin=skin;
    size=random(16,30);
    float angle1=random(TWO_PI);
    float speed=random(1,4);
    speedX=cos(angle1)*speed+sx/2;
    speedY=sin(angle1)*speed+sy/2;
    angle=0;
    particles.add(this);
  }
  
  void draw(){
    pushMatrix();
    translate(posX, posY);
    angle=(angle+6*TWO_PI/120)%HALF_PI;
    rotate(angle);
    image(skin,0,0,size*2,size*2);
    popMatrix();
    
    posX=posX+speedX;
    posY=posY+speedY;
    if(posX+size/2>1000 || posX-size/2<0)speedX=-speedX;
    if(posY+size/2>1000 || posY-size/2<0)speedY=-speedY;
    
    size=size-18.0/120;
    if(size<=0)particles.remove(this);
  }
}

class mouseParticle extends Particle{
  
  mouseParticle(PImage skin,float x,float y){
    posX=x;
    posY=y;
    this.skin=skin;
    size=random(4,14);
    float angle=random(TWO_PI);
    float speed=random(0.8);
    speedX=cos(angle)*speed;
    speedY=sin(angle)*speed;
    particles.add(this);
  }
  void draw(){
    image(skin,posX,posY,size*2,size*2);
    posX=posX+speedX;
    posY=posY+speedY;
    size=size-10.0/120;
    if(size<=0)particles.remove(this);
  }
}

class clickParticle extends Particle{
  int timer;
  clickParticle(PImage skin,float x,float y){
    posX=x;
    posY=y;
    this.skin=skin;
    size=40;
    timer=120;
    particles.add(this);
  }
  
  void draw(){
    float tintValue=timer/120.0*255;
    tint(255, tintValue);
    image(skin,posX,posY,size*1.1,size*1.1);
    tint(255,255);
    timer--;
    if(timer<=0)particles.remove(this);
  }
}

class waterExplosion extends Particle{
  
  waterExplosion(PImage skin,float x,float y,float speedDown){
    posX=x;
    posY=y;
    this.skin=skin;
    size=random(4,30);
    float angle=random(TWO_PI);
    float speed=random(1,3);
    speedX=cos(angle)*speed;
    speedY=sin(angle)*speed+speedDown;
    particles.add(this);
  }
  
  void draw(){
    image(skin,posX,posY,size*2,size*2);
    speedY=speedY+9.0/120;
    posX=posX+speedX;
    posY=posY+speedY;
    size=size-30.0/120;
    if(size<=0)particles.remove(this);
  }
}

class magnetParticle extends Particle{
  
  magnetParticle(PImage skin,float x,float y){
    posX=x;
    posY=y;
    this.skin=skin;
    size=80;
    particles.add(this);
  }
  
  void draw(){
    float tintValue=(1-(size-80)/160)*255;
    tint(255, tintValue);
    image(skin,posX,posY,size*1.1,size*1.1);
    tint(255,255);
    posX=posX+speedX;
    posY=posY+speedY;
    size=size+240/120;
    if(size>=240)particles.remove(this);
  }
}

class screenSlit extends Particle{
  float angle;
  float timer;
  
  screenSlit(float x,float y,float x2,float y2){
    posX=(x+x2)/2;
    posY=(y+y2)/2;
    angle=(atan2((y2-y),(x2-x))+HALF_PI)%PI-HALF_PI;
    size=(float)Math.sqrt(Math.pow(x2-x,2)+Math.pow(y2-y,2));
    if(size>260)size=260;
    if(random(100)<50)size=size*random(1);
    timer=120;
    particles.add(this);
  }
  
  void draw(){
    float tintValue=timer/30*255;
    pushMatrix();
    translate(posX, posY);
    rotate(angle);
    tint(255, tintValue);
    image(slit,0,0,size*1.1,size*1.1);
    tint(255,255);
    popMatrix();
    if(timer<=0)particles.remove(this);
    timer--;
  }
}
