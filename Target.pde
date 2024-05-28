class Target {
  Point pos;
  float size;
  float maxSize;
  int pointReward;
  float leftTime;
  float maxTime;
  float angle;
  int saveCode=1;
  boolean spamer=true;
  boolean unique=false;
  boolean firstSlotter=true;

  Target(float x, float y, float size, float maxT, int reward) {
    pos=new Point(x, y);
    this.size=size;
    maxSize=size;
    maxTime=maxT;
    leftTime=maxT;
    pointReward=reward;
  }

  void draw() {
    size=(maxTime-leftTime)/maxTime*maxSize;
    pushMatrix();
    translate(pos.posX, pos.posY);
    if (random(100)<60/1.2)angle=random(TWO_PI);
    rotate(angle);
    image(fireTarget, 0, 0, size*1.1, size*1.1);
    popMatrix();
    if (leftTime>=0)leftTime--;
    else {
      targets.remove(this);
      mode=0;
      ingame=false;
      particlesSpawn();
      
    }
    checkHit();
  }
  void drawInGauntlet(float posX, float posY, int n) {
    float x=posX+25*n;
    float y=posY;
    if(n>9){
      x=x-250;
      y=y+25;
    }
    image(fireTarget, x, y, 20, 20);
  }
  
  void particlesSpawn(){
    for (int i=0; i<40; i++) {
      if (random(100)>30) {
        fireExplosion r=new fireExplosion(redParticle, pos.posX, pos.posY);
      } else {
        fireExplosion o=new fireExplosion(orangeParticle, pos.posX, pos.posY);
      }
    }
    if(ingame){StringParticle s=new StringParticle("+"+pointReward, pos.posX, pos.posY,40,#cd974b);}
  }

  void checkHit() {
    if (pos.distance(mousePos)<size/2 && firstFrameClick && mousePressed) {
      activateHit();
    }
  }

  void activateHit() {
    points=points+(int)(pointReward*pointMulti);
    targets.remove(this);
    particlesSpawn();
  }

  void spawn() {
    Target t=new Target(random(700)+150, random(700)+150, 140, 240, 10);
    targets.add(t);
  }
  Target clone(){
    Target t1=new Target(pos.posX,pos.posY,140,240,10);
    return t1;
  }
  void passive(){}
}

class RainDrop extends Target {
  float speedDown;

  RainDrop(float x) {
    super(x, -50, 110, 480, 15);
    saveCode=2;
    speedDown=300.0/120;
  }

  void draw() {

    image(rainTarget, pos.posX, pos.posY, size*1.1, size*1.1);
    speedDown=speedDown+300.0/120/120;
    if (pos.posY<1000+size/2)pos.posY=pos.posY+speedDown;
    else {
      targets.remove(this);
      ingame=false;
      mode=0;
      speedDown=-speedDown;
      particlesSpawn();
    }
    checkHit();
  }
  
  void particlesSpawn(){
    for (int i=0; i<60; i++) {
      waterExplosion b=new waterExplosion(blueParticle, pos.posX, pos.posY, speedDown);
    }
    if(ingame){StringParticle s=new StringParticle("+"+pointReward, pos.posX, pos.posY,40,#325BC6);}
  }

  void activateHit() {
    points=points+(int)(pointReward*pointMulti);
    targets.remove(this);
    particlesSpawn();
  }
  void spawn() {
    RainDrop t=new RainDrop(random(900)+50);
    targets.add(t);
  }
  Target clone(){
    RainDrop t1=new RainDrop(pos.posX);
    return t1;
  }
  void drawInGauntlet(float posX, float posY, int n) {
    float x=posX+25*n;
    float y=posY;
    if(n>9){
      x=x-250;
      y=y+25;
    }
    image(rainTarget, x, y, 20, 20);
  }
}

class Magnet extends Target {
  float atraction;

  Magnet(float x, float y) {
    super( x, y, 80, 120*3, 10);
    saveCode=3;
    atraction=60.0/120;
    unique=true;
    spamer=false;
  }

  void draw() {
    if(leftTime>120)image(magnet, pos.posX, pos.posY, size*1.1, size*1.1);
    else image(brokenmagnet, pos.posX, pos.posY, size*1.1, size*1.1);
    for (int i=0; i<targets.size(); i++) {
      if (targets.get(i).saveCode==0) {
        float dist=pos.distance(targets.get(i).pos);
        targets.get(i).pos.posX=targets.get(i).pos.posX + (pos.posX-targets.get(i).pos.posX)/dist*atraction/dist*500;
        targets.get(i).pos.posY=targets.get(i).pos.posY + (pos.posY-targets.get(i).pos.posY)/dist*atraction/dist*500;
        if(pos.distance(targets.get(i).pos)<size/2)targets.get(i).activateHit();
      }
    }
    if (leftTime>=0)leftTime--;
    else {
      targets.remove(this);
      mode=0;
      ingame=false;
      particlesSpawn();
    }
    checkHit();
  }
  
  void particlesSpawn(){
    magnetParticle m =new magnetParticle(magnet, pos.posX, pos.posY);
    if(ingame){
      StringParticle n=new StringParticle("+"+pointReward, pos.posX-2, pos.posY,40,#CE0000);
      StringParticle s=new StringParticle("+"+pointReward, pos.posX+2, pos.posY,40,#325BC6);
    }
  }
  
  void drawInGauntlet(float posX, float posY, int n) {
    float x=posX+25*n;
    float y=posY;
    if(n>9){
      x=x-250;
      y=y+25;
    }
    image(magnet, x, y, 20, 20);
  }

  void spawn() {
    Magnet t=new Magnet(random(900)+50, random(900)+50);
    targets.add(t);
  }
  Target clone(){
    Magnet t1=new Magnet(pos.posX,pos.posY);
    return t1;
  }
}

class Shuriken extends Target {
  float angle;
  int bounces;
  float speedX;
  float speedY;
  int startingFrames;

  Shuriken(float x, float y) {
    super( x, y, 100, 480, 20);
    saveCode=5;
    angle=0;
    bounces=0;
    float angle1=random(TWO_PI);
    float speed=4.4;
    speedX=cos(angle1)*speed;
    speedY=sin(angle1)*speed;
    while(!(pos.posX+size/2>1000 || pos.posX-size/2<0 || pos.posY+size/2>1000 || pos.posY-size/2<0)){
      pos.posX=pos.posX-speedX;
      pos.posY=pos.posY-speedY;
    }
    pos.posX=pos.posX-speedX*20;
    pos.posY=pos.posY-speedY*20;
    startingFrames=22;
  }

  void draw() {
    if(startingFrames>0)startingFrames--;
    pos.posX=speedX+pos.posX;
    pos.posY=speedY+pos.posY;
    if((pos.posX+size/2>1000 || pos.posX-size/2<0) && startingFrames<=0 ){
      if(bounces<1)speedX=-speedX;
      else{
        targets.remove(this);
        mode=0;
        ingame=false;
        particlesSpawn();
      }
      bounces++;
    }
    if((pos.posY+size/2>1000 || pos.posY-size/2<0) && startingFrames<=0){
      if(bounces<1)speedY=-speedY;
      else{
        targets.remove(this);
        mode=0;
        ingame=false;
        particlesSpawn();
      }
      bounces++;
    }
    
    pushMatrix();
    translate(pos.posX, pos.posY);
    angle=(angle+6*TWO_PI/120)%HALF_PI;
    rotate(angle);
    image(shuriken, 0, 0, size*1.1, size*1.1);
    popMatrix();
    checkHit();
  }
  
  
  void activateHit() {
    targets.remove(this);
    points=points+(int)(pointReward*pointMulti);
    particlesSpawn();
  }
  void particlesSpawn(){
    for (int i=0; i<16; i++) {
      shurikenParticle o=new shurikenParticle(shuriken, pos.posX, pos.posY,speedX,speedY);
    }
    if(ingame){StringParticle n=new StringParticle("+"+pointReward, pos.posX, pos.posY,44,#A2A2A2);}
  }
  
  void drawInGauntlet(float posX, float posY, int n) {
    float x=posX+25*n;
    float y=posY;
    if(n>9){
      x=x-250;
      y=y+25;
    }
    image(shuriken, x, y, 24, 24);
  }

  void spawn() {
    Shuriken t=new Shuriken(random(900)+50, random(900)+50);
    targets.add(t);
  }
  Target clone(){
    Shuriken t1=new Shuriken(pos.posX,pos.posY);
    return t1;
  }
}

class Buzzer extends Target {
  int pressed;

  Buzzer(float x, float y) {
    super( x, y, 160, 240, 2);
    saveCode=4;
    pressed=-1;
    spamer=false;
    firstSlotter=false;
  }

  void draw() {
    if (pressed>0) {
      image(buzzerPressed, pos.posX, pos.posY, size*1.1, size*1.1); 
      pressed--;
    } else image(buzzer, pos.posX, pos.posY, size*1.1, size*1.1);
    if (leftTime>=0)leftTime--;
    else {
      targets.remove(this);
      particlesSpawn();
    }
    checkHit();
  }
  
  void particlesSpawn(){
    for (int i=0; i<6; i++) {
      if (random(100)<33) {
        fireExplosion r=new fireExplosion(redParticle, pos.posX, pos.posY);
      } else {
        if (random(100)<33) {
          fireExplosion y=new fireExplosion(yellowParticle, pos.posX, pos.posY);
        } else {
          fireExplosion b=new fireExplosion(blueParticle, pos.posX, pos.posY);
        }
      }
    }
    if(ingame){
      if(random(100)<50){StringParticle n=new StringParticle("+"+pointReward, mousePos.posX, mousePos.posY,30,255);
      }else{StringParticle n=new StringParticle("+"+pointReward, mousePos.posX, mousePos.posY,30,0);}
    }
  }
  
  void drawInGauntlet(float posX, float posY, int n) {
    float x=posX+25*n;
    float y=posY;
    if(n>9){
      x=x-250;
      y=y+25;
    }
    image(buzzer, x, y, 20, 20);
  }

  void activateHit() {
    pressed=6;
    points=points+(int)(pointReward*pointMulti);
    particlesSpawn();
  }

  void spawn() {
    Buzzer t=new Buzzer(random(900)+50, random(900)+50);
    targets.add(t);
    nextTarget=1;
  }
  Target clone(){
    Buzzer t1=new Buzzer(pos.posX,pos.posY);
    return t1;
  }
}

class Katana extends Target {
  ArrayList<Target> targetsInside;
  int particleTimer;
  Point prevMouse;
  Katana(){
    super(500,500, 80, 120*6, 0);
    targetsInside=new ArrayList<Target>();
    saveCode=6;
    spamer=false;
    firstSlotter=false;
    unique=true;
  }
  
  void passive(){
    ArrayList<Target> thisFrameTargets=new ArrayList<Target>(targets);
    for(int i=0; i<thisFrameTargets.size();i++){
      if(thisFrameTargets.get(i).pos.distance(mousePos) < thisFrameTargets.get(i).size/2)  targetsInside.add(thisFrameTargets.get(i));
    }
    for(int i=0; i<targetsInside.size();i++){
      if(!targets.contains(targetsInside.get(i)))targetsInside.remove(targetsInside.get(i));
      else{
        if(targetsInside.get(i).pos.distance(mousePos) > targetsInside.get(i).size/2){
          targetsInside.get(i).activateHit();
          screenSlit b=new screenSlit(mouseX,mouseY,targetsInside.get(i).pos.posX*2-mouseX,targetsInside.get(i).pos.posY*2-mouseY);
          targetsInside.remove(targetsInside.get(i));
        }
      }
    }
    
    if(mouseSpeed>120+randomGaussian()*100 && random(100)<10){
      screenSlit b=new screenSlit(mouseX,mouseY,prevMouse.posX,prevMouse.posY);
    }else particleTimer--;
    if(random(100)<50)prevMouse=new Point(mouseX,mouseY);
  }
  
  void spawn() {
    equiptGauntlet.newTarget();
  }
  Target clone(){
    Katana t1=new Katana();
    return t1;
  }
  void drawInGauntlet(float posX, float posY, int n) {
    float x=posX+25*n;
    float y=posY;
    if(n>9){
      x=x-250;
      y=y+25;
    }
    image(katana, x, y, 20, 20);
  }
}

class RedButton extends Target {

  RedButton(float x,float y) {
    super(x, y, 100, 480, 5);
    saveCode=7;
    firstSlotter=false;
  }

  void draw() {

    image(atomButton, pos.posX, pos.posY, size*1.6, size*1.6);
    if (leftTime>0)leftTime--;
    else {
      targets.remove(this);
      points=points+(int)(pointReward*pointMulti);
      for (int i=0; i<10; i++) {
        fireExplosion r=new fireExplosion(redParticle, pos.posX, pos.posY);
      }
      StringParticle n=new StringParticle("+"+pointReward, pos.posX, pos.posY,30,0);
    }
    checkHit();
  }

  void activateHit() {
    mode=0;
    ingame=false;
    targets.remove(this);
    particlesSpawn();
  }
  void particlesSpawn(){
    for (int i=0; i<120; i++) {
        fireExplosion r=new fireExplosion(redParticle, pos.posX, pos.posY);
        fireExplosion b=new fireExplosion(blueParticle, pos.posX, pos.posY);
        fireExplosion y=new fireExplosion(yellowParticle, pos.posX, pos.posY);
        fireExplosion o=new fireExplosion(orangeParticle, pos.posX, pos.posY);
      }
    for(int ii=0; ii<180; ii++){
      pos.posX=random(1000);
      pos.posY=random(1000);
      for (int i=0; i<1; i++) {
        fireExplosion r=new fireExplosion(redParticle, pos.posX, pos.posY);
        fireExplosion b=new fireExplosion(blueParticle, pos.posX, pos.posY);
        fireExplosion y=new fireExplosion(yellowParticle, pos.posX, pos.posY);
        fireExplosion o=new fireExplosion(orangeParticle, pos.posX, pos.posY);
      }
    }
  }
  
  void spawn() {
    RedButton t=new RedButton(random(900)+50,random(900)+50);
    targets.add(t);
    nextTarget=nextTarget*0.75;
  }
  Target clone(){
    RedButton t=new RedButton(random(900)+50,random(900)+50);
    return t;
  }
  void drawInGauntlet(float posX, float posY, int n) {
    float x=posX+25*n;
    float y=posY;
    if(n>9){
      x=x-250;
      y=y+25;
    }
    image(atomButton, x, y, 20, 20);
  }
}

class GreenTarget extends Target{
  
  GreenTarget(float x, float y, float size, float maxT, int reward){
    super( x,  y,  size,  maxT,  reward);
    saveCode=8;
  }
  
  void draw() {
    size=(maxTime-leftTime)/maxTime*maxSize;
    pushMatrix();
    translate(pos.posX, pos.posY);
    if (random(100)<60/1.2)angle=random(TWO_PI);
    rotate(angle);
    image(greenTarget, 0, 0, size*1.1, size*1.1);
    popMatrix();
    if (leftTime>=0)leftTime--;
    else {
      targets.remove(this);
      mode=0;
      ingame=false;
      particlesSpawn();
    }
    checkHit();
  }
  void particlesSpawn(){
    for (int i=0; i<80; i++) {
        if (random(100)>30) {
          fireExplosion g=new fireExplosion(greenParticle, pos.posX, pos.posY);
        } else {
          fireExplosion o=new fireExplosion(orangeParticle, pos.posX, pos.posY);
        }
      }
      if(ingame){StringParticle n=new StringParticle("+"+pointReward, pos.posX, pos.posY,44,#00905A);}
  }
  void drawInGauntlet(float posX, float posY, int n) {
    float x=posX+25*n;
    float y=posY;
    if(n>9){
      x=x-250;
      y=y+25;
    }
    image(greenTarget, x, y, 20, 20);
  }
  
  void spawn() {
    GreenTarget t=new GreenTarget(random(700)+150, random(700)+150, 140, 210, 20);
    targets.add(t);
  }
  Target clone(){
    GreenTarget t1=new GreenTarget(pos.posX,pos.posY,140,240,20);
    return t1;
  }
}

class EnergyTarget extends Target{
  
  EnergyTarget(float x, float y, float size, float maxT, int reward){
    super( x,  y,  size,  maxT,  reward);
    saveCode=9;
    spamer=false;
  }
  
  void draw() {
    size=(maxTime-leftTime)/maxTime*maxSize;
    pushMatrix();
    translate(pos.posX, pos.posY);
    if (random(100)<60/1.2)angle=random(TWO_PI);
    rotate(angle);
    image(energyTarget, 0, 0, size*1.1, size*1.1);
    popMatrix();
    if (leftTime>=0)leftTime--;
    else {
      targets.remove(this);
      mode=0;
      ingame=false;
      particlesSpawn();
    }
    checkHit();
  }
  
  void particlesSpawn(){
    for (int i=0; i<80; i++) {
      fireExplosion e=new fireExplosion(energyParticel, pos.posX, pos.posY);
    }
    if(ingame){StringParticle n=new StringParticle("+"+pointReward, pos.posX, pos.posY,60,#5C007E);}
  }
  void drawInGauntlet(float posX, float posY, int n) {
    float x=posX+25*n;
    float y=posY;
    if(n>9){
      x=x-250;
      y=y+25;
    }
    image(energyTarget, x, y, 20, 20);
  }
  
  void spawn() {
    EnergyTarget t=new EnergyTarget(random(700)+150, random(700)+150, 140, 180, 50);
    targets.add(t);
  }
  Target clone(){
    EnergyTarget t1=new EnergyTarget(pos.posX,pos.posY,140,240,50);
    return t1;
  }
}

class AcidDrop extends RainDrop {
  float speedDown;

  AcidDrop(float x) {
    super(x);
    pointReward=10;
    saveCode=10;
    speedDown=120.0/120;
  }

  void draw() {

    image(acidRain, pos.posX, pos.posY, size*1.1, size*1.1);
    speedDown=speedDown+300.0/120/120;
    if (pos.posY<1000+size/2)pos.posY=pos.posY+speedDown;
    else {
      targets.remove(this);
      points=points+(int)(pointReward*pointMulti);
      speedDown=-speedDown;
      particlesSpawn();
    }
    checkHit();
  }
  
  void checkHit() {
    if (pos.distance(mousePos)<size/2 && firstFrameClick) {
      activateHit();
    }
  }
  
  void particlesSpawn(){
    for (int i=0; i<60; i++) {
      waterExplosion b=new waterExplosion(greenParticle, pos.posX, pos.posY, speedDown);
    }
    if(ingame){StringParticle s=new StringParticle("+"+pointReward, pos.posX, pos.posY-size,30,#00CB4F);}
  }

  void activateHit() {
    targets.remove(this);
    mode=0;
    ingame=false;
    particlesSpawn();
  }
  
  void spawn() {
    AcidDrop t=new AcidDrop(random(900)+50);
    targets.add(t);
  }
  Target clone(){
    AcidDrop t1=new AcidDrop(pos.posX);
    return t1;
  }
  void drawInGauntlet(float posX, float posY, int n) {
    float x=posX+25*n;
    float y=posY;
    if(n>9){
      x=x-250;
      y=y+25;
    }
    image(acidRain, x, y, 20, 20);
  }
}

class BloodDrop extends RainDrop {

  BloodDrop(float x) {
    super(x);
    saveCode=11;
    speedDown=200.0/120;
    pointReward=50;
    spamer=false;
    size=90;
  }

  void draw() {

    image(bloodRain, pos.posX, pos.posY, size*1.1, size*1.1);
    if(speedDown<500.0/120) speedDown=speedDown+200.0/120/120;
    if (pos.posY<1000+size/2)pos.posY=pos.posY+speedDown;
    else {
      targets.remove(this);
      ingame=false;
      mode=0;
      speedDown=-speedDown;
      particlesSpawn();
    }
    checkHit();
  }
  
  void particlesSpawn(){
    for (int i=0; i<60; i++) {
      waterExplosion b=new waterExplosion(redParticle, pos.posX, pos.posY, speedDown);
    }
    if(ingame){StringParticle s=new StringParticle("+"+pointReward, pos.posX, pos.posY,60,#CE0202);}
  }

  void spawn() {
    BloodDrop t=new BloodDrop(random(900)+50);
    targets.add(t);
  }
  Target clone(){
    BloodDrop t1=new BloodDrop(pos.posX);
    return t1;
  }
  void drawInGauntlet(float posX, float posY, int n) {
    float x=posX+25*n;
    float y=posY;
    if(n>9){
      x=x-250;
      y=y+25;
    }
    image(bloodRain, x, y, 20, 20);
  }
}

class GoldCoin extends Target {

  GoldCoin(float x, float y) {
    super(x, y, 80, 120*6, 0);
    targets.add(this);
    saveCode=0;
  }
  void draw() {
    image(goldTarget, pos.posX, pos.posY, size*1.1, size*1.1);
    if (leftTime>0)leftTime--;
    else {
      targets.remove(this);
    }
    checkHit();
  }

  void activateHit() {
    points=points+(int)(pointReward*pointMulti);
    money=money+1;
    targets.remove(this);
    particlesSpawn();
  }
  
  void particlesSpawn(){
    for (int i=0; i<60; i++) {
      if (random(100)>50) {
        fireExplosion y=new fireExplosion(yellowParticle, pos.posX, pos.posY);
      } else {
        fireExplosion b=new fireExplosion(blueParticle, pos.posX, pos.posY);
      }
    }
    StringParticle s=new StringParticle("+1$", pos.posX, pos.posY,40,#79B202);
  }
}
