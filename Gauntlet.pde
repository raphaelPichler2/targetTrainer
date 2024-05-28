class Gauntlet{
  float randomStart;
  ArrayList<Target> posibleTargets;
  PImage skin1;
  PImage mouseSkin;
  
  Gauntlet(ArrayList<Target> t){
    posibleTargets=t;
    gauntlets.add(this);
    randomStart=0;
    
    desideSkin(this);
  }
  
  void passiveTargets(){
    for(int i=0;i<posibleTargets.size();i++){
      posibleTargets.get(i).passive();
    }
  }
  
  void particleSpawn(){
    for(int i=0;i<12;i++){
      if(random(100)<(mouseSpeed)/1.2){
        mouseParticle mp=new mouseParticle(mouseSkin,mousePos.posX,mousePos.posY);
      }
    }
    if(mousePressed && firstFrameClick){clickParticle c=new clickParticle(click,mouseX,mouseY);}
  }
  
  void newTarget(){
    posibleTargets.get((int)random(posibleTargets.size())).spawn();
  }
  void drawPic(int n){
    float x=310+n%7*70;
    float y=500+100*(int)(n/7);
    if(equiptGauntlet==this){
      image(gauntletBackground,x,y,60,60);
    }
    image(gauntletGreen,x,y,60,60);
    drawSkin(x,y);
    if(buttonPressed(x,y,60,60)){
      equiptGauntlet=this;
    }
  }
  
  void drawCursor(){
    pushMatrix();
    translate(mouseX+15,mouseY+15);
    scale(-1,1); 
    image(gauntletGreen,0,0,60,60);
    drawSkin(0,0);
    popMatrix();
    noCursor();
  }
  
  void drawSkin(float x,float y){
    image(skin1,x,y,60,60);
  }
  
  void drawInventory(int n){
    float x=310+n%7*70;
    float y=500+100*(int)(n/7);
    
    Point p=new Point(x,y);
    if(p.distance(mousePos)<35){
      fill(255);
      if(posibleTargets.size()<=10)rect(x+2.5+posibleTargets.size()*12.5,y-20,5+posibleTargets.size()*25,30);
      else rect(x+2.5+125,y-20+15,5+250,60);
      for(int i=0;i<posibleTargets.size();i++){
        posibleTargets.get(i).drawInGauntlet(x+15,y-20,i);
      }
    }
  }
}

void desideSkin(Gauntlet g){
    PImage skin1=fireSkin1;
    float overlap=0;
    
    int[] targetCounter=new int[12];
    for(int i=0;i<g.posibleTargets.size();i++){
      targetCounter[g.posibleTargets.get(i).saveCode]=targetCounter[g.posibleTargets.get(i).saveCode]+1;
    }
    
    if(overlap<  targetCounter[1]*1  ){skin1=fireSkin1; g.mouseSkin=orangeParticle; overlap=targetCounter[1]*1;}
    if(overlap<  targetCounter[2]*1.33  ){skin1=rainSkin1; g.mouseSkin=blueParticle; overlap=targetCounter[2]*1.25;}
    if(overlap<  targetCounter[5]*2.67  ){skin1=shurikenSkin1; g.mouseSkin=shuriken; overlap=targetCounter[5]*2.35;}
    if(overlap<  targetCounter[8]*4  ){skin1=greenSkin1; g.mouseSkin=greenParticle; overlap=targetCounter[8]*3.33;}
    if(overlap<  targetCounter[10]*5.33  ){skin1=acidSkin; g.mouseSkin=greenParticle; overlap=targetCounter[10]*4.2;}
    g.skin1=skin1;
}
