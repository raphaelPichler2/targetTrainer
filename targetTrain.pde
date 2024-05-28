Table table;

boolean firstFrameClick=true;
boolean ingame;
int mode=0;//0 nichts, 1= tresure, 2 invest, 3 gauntlets,
Point mousePos=new Point(0,0);
float mouseSpeed;
int points;
float highscore;
float money;
float nextTarget;
float gameSpeed=1;
float pointMulti=1;
float nextCoin;
Gauntlet equiptGauntlet;
Gauntlet tresureGot;
Krypto k1=new Krypto();
Krypto k2=new Krypto();
Krypto k3=new Krypto();
Krypto shown;
int timerForKryptoBankrupt=0;
String kryptoBankrupt;
int nDRewardDay=day()-1;
int nDRewardMonth=month();
int nDRewardYear=year();
boolean nextDailyRewardready;

ArrayList<Target> targets=new ArrayList<Target>();
ArrayList<Particle> particles=new ArrayList<Particle>();
ArrayList<Gauntlet> gauntlets=new ArrayList<Gauntlet>();
ArrayList<Target> rollTargets=new ArrayList<Target>();

void setup(){
  size(1000,1000,P2D);
  smooth(8);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  imageMode(CENTER);
  frameRate(120);
  
  loadAllPics();
  loadGame(); 
  fillRollTargets();
  if(gauntlets.size()<=0){
    ArrayList<Target> posibleTargets=new ArrayList<Target>();
    for(int i=0;i<5;i++){
      Target t=new Target(random(900)+50,random(900)+50, 100, 240, 10);
      posibleTargets.add(t);
    }
    Gauntlet newG=new Gauntlet(posibleTargets);
    equiptGauntlet=newG;
  }
}

void draw(){
  Point mouseNow=new Point(mouseX,mouseY);
  mouseSpeed=mousePos.distance(mouseNow);
  mousePos=mouseNow;

  background(#EA133B);
  
  //menu
  
  if(!ingame){
    textI(""+points,500,160,60,0);
    if(points>highscore)highscore=points;
    textI("highscore: "+(int)highscore,500,230,30,0);
    textI("gold: "+(int)money,500,280,30,0);
    
    fill(#D89125);
    rect(160,400,200,80);
    textI("start",160,400,30,0);
    if(buttonPressed(160,400,200,80)){
      ingame=true;
      points=0;
      gameSpeed=1;
      pointMulti=1;
      nextTarget=120;
      nextCoin=120*12;
      targets.clear();
    }
    
    fill(#D89125);
    rect(160,500,200,80);
    textI("open treasure",160,500,20,0);
    if(buttonPressed(160,500,200,80)){
      mode=1;
    }
    
    fill(#D89125);
    rect(160,600,200,80);
    textI("investments",160,600,20,0);
    if(buttonPressed(160,600,200,80)){
      mode=2;
    }
    
    fill(#D89125);
    rect(160,700,200,80);
    textI("gauntlets",160,700,20,0);
    if(buttonPressed(160,700,200,80)){
      mode=3;
    }
    
    if(mode==1){
      if(tresureGot!=null){
        tresureGot.drawPic(11);
        tresureGot.drawInventory(11);
      }
      fill(#D89125);
      rect(490,800,200,80);
      textI("100 gold",490,800,20,0);
      if(buttonPressed(490,800,200,80) && money>=100){
        money=money-100;
        Gauntlet newG=rollGauntlet();
        tresureGot=newG;
      }
      fill(#D89125);
      rect(710,800,200,80);
      if(nDRewardDay<day() || nDRewardMonth<month() || nDRewardYear<year()){
        nextDailyRewardready=true;
      }
      String rewardTimer =""+(23-hour())+":"+(60-minute())+":"+(60-second());
      if(nextDailyRewardready)textI("freeroll ready",710,800,16,0);
      else textI("next freeroll: "+rewardTimer,710,800,16,0);
      if(buttonPressed(710,800,200,80) && nextDailyRewardready){
        nextDailyRewardready=false;
        nDRewardDay=day();
        nDRewardMonth=month();
        nDRewardYear=year();
        Gauntlet newG=rollGauntlet();
        tresureGot=newG;
      }
    }
    
    if(mode==2){
      if(shown!=null)shown.drawGraph();
      else{
        fill(#D89125);
        rect(350,500,140,80);
        String price=""+k1.fifteenmin[k1.fifteenmin.length-1];
        price=price.substring(0,4)+" $";
        textI(k1.name+" "+price,350,500,16,0);
        if(buttonPressed(350,500,140,80)){
          shown=k1;
        }
        
        fill(#D89125);
        rect(510,500,140,80);
        price=""+k2.fifteenmin[k2.fifteenmin.length-1];
        price=price.substring(0,4)+" $";
        textI(k2.name+" "+price,510,500,16,0);
        if(buttonPressed(510,500,140,80)){
          shown=k2;
        }
        
        fill(#D89125);
        rect(670,500,140,80);
        price=""+k3.fifteenmin[k3.fifteenmin.length-1];
        price=price.substring(0,4)+" $";
        textI(k3.name+" "+price,670,500,16,0);
        if(buttonPressed(670,500,140,80)){
          shown=k3;
        }
      }
    }
    
    if(mode==3){
      for(int i=0;i<gauntlets.size();i++){
        gauntlets.get(i).drawPic(i);
      }
      for(int i=0;i<gauntlets.size();i++){
        gauntlets.get(i).drawInventory(i);
      }
      fill(#D89125);
      rect(600,800,200,80);
      textI("sell gauntlet for 10 gold",600,800,14,0);
      if(buttonPressed(600,800,200,80) && gauntlets.size()>1){
        money=money+10;
        gauntlets.remove(equiptGauntlet);
        equiptGauntlet=gauntlets.get(0);
      }
    }
    cursor();
  }
  
  //ingame 
  
  if(ingame){
    background(255);
    
    
    String pointMultiPortraid= ""+pointMulti;
    if(pointMultiPortraid.length()>=4)pointMultiPortraid=pointMultiPortraid.substring(0,4);
    textI(""+points+" X "+pointMultiPortraid,500,40,30,0);
    ArrayList<Target> thisFrameTargets=new ArrayList<Target>(targets);
    for(int i=0; i<thisFrameTargets.size();i++){
      thisFrameTargets.get(i).draw();
    }
    
    if(nextCoin>0)nextCoin=nextCoin-1-(points/300);
    else{
      nextCoin=120*12;
      GoldCoin g=new GoldCoin(random(900)+50,random(900)+50);
    }
    if(nextTarget>0)nextTarget--;
    else{
      nextTarget=240/gameSpeed;
      equiptGauntlet.newTarget();
    }
    equiptGauntlet.passiveTargets();
    if(gameSpeed<2)gameSpeed=gameSpeed+0.03/120;
    else gameSpeed=gameSpeed+0.015/120;
    pointMulti=pointMulti+0.01/120;
    
    equiptGauntlet.drawCursor();
  }
  
  k1.calcGraph();
  k2.calcGraph();
  k3.calcGraph();
  if(timerForKryptoBankrupt>0 && kryptoBankrupt!=null){
    textI(kryptoBankrupt,500,500+120*4-timerForKryptoBankrupt,60,0);
    timerForKryptoBankrupt--;
  }
  
  ArrayList<Particle> thisFrameParticles=new ArrayList<Particle>(particles);
  for(int i=0; i<thisFrameParticles.size();i++){
    thisFrameParticles.get(i).draw();
  }
  equiptGauntlet.particleSpawn();
  textI(""+(int)frameRate,20,20,16,0);
  if(!keyPressed && !mousePressed)firstFrameClick=true;  
  if(keyPressed || mousePressed)firstFrameClick=false;
}

boolean buttonPressed(float posX, float posY, float sizeX, float sizeY) {
  if (mousePressed && firstFrameClick && mouseX<posX+sizeX/2 && mouseX>posX-sizeX/2 && mouseY<posY+sizeY/2 && mouseY>posY-sizeY/2) {
    return true;
  }
  return false;
}

void textI(String s,float x,float y, float size, color c){
  textSize(size);
  fill(c);
  text(s,x,y);
}

void save(){
  table=loadTable("data/new.csv", "header,csv");
  table.getRow(0).setFloat("value",highscore);
  table.getRow(1).setFloat("value",money);
  table.getRow(2).setInt("value",k1.youOwn);table.getRow(2).setString("name",k1.name);table.getRow(2).setFloat("secondvalue",k1.schwankung);
  table.getRow(3).setInt("value",k2.youOwn);table.getRow(3).setString("name",k2.name);table.getRow(3).setFloat("secondvalue",k2.schwankung);
  table.getRow(4).setInt("value",k3.youOwn);table.getRow(4).setString("name",k3.name);table.getRow(4).setFloat("secondvalue",k3.schwankung);
  table.getRow(5).setInt("value",k1.ownMiner);table.getRow(5).setInt("name",k2.ownMiner);table.getRow(5).setInt("secondvalue",k3.ownMiner);
  table.getRow(6).setInt("value",nDRewardDay);table.getRow(6).setInt("name",nDRewardMonth);table.getRow(6).setInt("secondvalue",nDRewardYear);
  
  table.getRow(11).setInt("value",gauntlets.size());
  for(int i=0;i<gauntlets.size();i++){
    String s="";
    for(int ii=0;ii<gauntlets.get(i).posibleTargets.size();ii++){
      
      s=s+ gauntlets.get(i).posibleTargets.get(ii).saveCode +" ";
    }
    table.getRow(12+i).setString("value",s);
  }
  saveTable(table, "data/new.csv");
  k1.save("krypto1");
  k2.save("krypto2");
  k3.save("krypto3");
}
void loadGame(){
  table=loadTable("data/new.csv", "header,csv");
  highscore=table.getInt(0, "value");
  money=table.getInt(1, "value");
  k1.youOwn=table.getInt(2, "value");k1.name=table.getString(2, "name");k1.schwankung=table.getFloat(2, "secondvalue");
  k2.youOwn=table.getInt(3, "value");k2.name=table.getString(3, "name");k2.schwankung=table.getFloat(3, "secondvalue");
  k3.youOwn=table.getInt(4, "value");k3.name=table.getString(4, "name");k3.schwankung=table.getFloat(4, "secondvalue");
  k1.ownMiner=table.getInt(5, "value");k2.ownMiner=table.getInt(5, "name");k3.ownMiner=table.getInt(5, "secondvalue");
  nDRewardDay=table.getInt(6, "value");nDRewardMonth=table.getInt(6, "name");nDRewardYear=table.getInt(6, "secondvalue");
  
  ArrayList<Target> posibleTargets;
  
  int amountOfGauntlets=table.getInt(11, "value");
  for(int i=0;i<amountOfGauntlets;i++){
    posibleTargets=new ArrayList<Target>();
    String gauntletString=table.getString(12+i, "value");
    int[] data=int(split(gauntletString, ' '));
    for(int ii=0;ii<data.length;ii++){
      switch (data[ii]){
      case 1:
        Target t2=new Target(random(900)+50,random(900)+50, 100, 240, 10);
        posibleTargets.add(t2);
        break;
      case 2:
        RainDrop t3=new RainDrop(random(900)+50);
        posibleTargets.add(t3);
        break;
      case 3:
        Magnet t4=new Magnet(random(900)+50,random(900)+50);
        posibleTargets.add(t4);
        break;
      case 4:
        Buzzer t5=new Buzzer(random(900)+50,random(900)+50);
        posibleTargets.add(t5);
        break;
      case 5:
        Shuriken t6=new Shuriken(random(900)+50,random(900)+50);
        posibleTargets.add(t6);
        break;
      case 6:
        Katana t7=new Katana();
        posibleTargets.add(t7);
        break;
      case 7:
        RedButton t8=new RedButton(random(900)+50,random(900)+50);
        posibleTargets.add(t8);
        break;
      case 8:
        GreenTarget t9=new GreenTarget(random(700)+150, random(700)+150, 140, 240, 20);
        posibleTargets.add(t9);
        break;
      case 9:
        EnergyTarget t10=new EnergyTarget(random(700)+150, random(700)+150, 140, 240, 50);
        posibleTargets.add(t10);
        break;
      case 10:
        AcidDrop t11=new AcidDrop(random(900)+50);
        posibleTargets.add(t11);
        break;
      case 11:
        BloodDrop t12=new BloodDrop(random(900)+50);
        posibleTargets.add(t12);
        break;
      }
    }
    Gauntlet g=new Gauntlet(posibleTargets);
  }
  equiptGauntlet=gauntlets.get(0);
  k1.load("krypto1");
  k2.load("krypto2");
  k3.load("krypto3");
  //k1=new Krypto();k2=new Krypto();k3=new Krypto();
  
}

Gauntlet rollGauntlet(){
  fillRollTargets();
  
  ArrayList<Target> posibleTargets=new ArrayList<Target>();
  int slots=3+(int)Math.abs(random(17)+random(17)-17);
  for(int i=0;i<slots;i++){
    Target newT=rollTargets.get( (int)random(rollTargets.size()) ).clone();
    if(i==0){
      while(!newT.firstSlotter){
        newT=rollTargets.get( (int)random(rollTargets.size()) ).clone();
      }
    }else{
      if(posibleTargets.get(i-1).spamer && random(100)<50)newT=posibleTargets.get(i-1).clone();
    }
    if(newT.unique){
      for(int ii=0;ii<rollTargets.size();ii++){
        if(rollTargets.get(i).saveCode==newT.saveCode)rollTargets.remove(ii);
      }
    }
    
    posibleTargets.add(newT);
  }
  Gauntlet newG=new Gauntlet(posibleTargets);
  return newG;
}

void fillRollTargets(){
  
  for(int i=0;i<80;i++){
    Target t1=new Target(random(900)+50,random(900)+50, 100, 240, 10);
    rollTargets.add(t1);
  }
  for(int i=0;i<20;i++){
    GreenTarget t1=new GreenTarget(random(700)+150, random(700)+150, 140, 240, 20);
    rollTargets.add(t1);
  }
  for(int i=0;i<6;i++){
    EnergyTarget t1=new EnergyTarget(random(700)+150, random(700)+150, 140, 240, 50);
    rollTargets.add(t1);
  }
  for(int i=0;i<60;i++){
    RainDrop t2=new RainDrop(random(900)+50);
    rollTargets.add(t2);
  }
  for(int i=0;i<15;i++){
    AcidDrop t2=new AcidDrop(random(900)+50);
    rollTargets.add(t2);
  }
  for(int i=0;i<5;i++){
    BloodDrop t2=new BloodDrop(random(900)+50);
    rollTargets.add(t2);
  }
  for(int i=0;i<12;i++){
    Magnet t3=new Magnet(random(900)+50,random(900)+50);
    rollTargets.add(t3);
  }
  for(int i=0;i<12;i++){
    Buzzer t3=new Buzzer(random(900)+50,random(900)+50);
    rollTargets.add(t3);
  }
  for(int i=0;i<30;i++){
    Shuriken t3=new Shuriken(random(900)+50,random(900)+50);
    rollTargets.add(t3);
  }
  for(int i=0;i<12;i++){
    Katana t3=new Katana();
    rollTargets.add(t3);
  }
  for(int i=0;i<15;i++){
    RedButton t3=new RedButton(random(900)+50,random(900)+50);
    rollTargets.add(t3);
  }
}


void exit() {
  println("exiting");
  save();
  super.exit();
}
