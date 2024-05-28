

class Krypto{
  float[] fifteenmin;
  float[] day;
  float[] month;
  float shortMedian;
  float midMedian;
  float longMedian;
  float schwankung;
  int whichGraph;
  int nextEntryFif;
  int nextEntryDay;
  int nextEntryMon;
  float maxValue;
  String name;
  int leverage;
  
  int youOwn;
  int ownMiner; 
  
  Krypto(){
    float startValue=(float)(Math.pow(1.05,abs(randomGaussian())*60)*0.1);
    schwankung=(float)Math.pow(1.05,randomGaussian()*16)*0.2;
    fifteenmin=new float[350];
    for(int i=0;i<fifteenmin.length;i++){
      fifteenmin[i]=startValue;
    }
    day=new float[360];
    for(int i=0;i<day.length;i++){
      day[i]=startValue;
    }
    month=new float[360];
    for(int i=0;i<month.length;i++){
      month[i]=startValue;
    }
    shortMedian=randomGaussian()*schwankung*fifteenmin[fifteenmin.length-1]/50;
    midMedian=randomGaussian()*schwankung*day[day.length-1]/50;
    longMedian=randomGaussian()*schwankung*month[month.length-1]/50;
    whichGraph=1;
    nextEntryFif=(second()+5)%60;
    nextEntryDay=(second()+16)%60;
    nextEntryMon=(minute()*60+240+second())%3600;
    youOwn=0;
    leverage=1;
    ownMiner=0;
    name=Character.toString ((char) random(65,91))+Character.toString ((char) random(65,91))+Character.toString ((char) random(65,91));
  }
  
  void drawGraph(){
    fill(#FFFFFF);
    rect(600,550,480,400);
    
    float[] graph=new float[450];
    switch(whichGraph){
    case 1://15
      graph=fifteenmin;
      break;
    case 2://day
      graph=day;
      break;
    case 3://month
      graph=month;
      break;
    }
    maxValue=0;
    for(int i=1;i<graph.length;i++){
      if(graph[i]>maxValue)maxValue=graph[i];
    }
    float param=360/maxValue;
    if(whichGraph==2)param=param/2;
    if(whichGraph==3)param=param/4;
    stroke(200);
    line(360,450,360+480,450);
    line(360,550,360+480,550); 
    line(360,650,360+480,650);
    stroke(0);
    textI(""+(200/param),600,560,10,0);
    textI(""+(300/param),600,460,10,0);
    textI(""+(100/param),600,660,10,0);
    noFill();
    rect(600,550,480,400);
    
    for(int i=1;i<graph.length;i++){
      fill(0);
      line(360+(i-1)*480/graph.length,-graph[i-1]*param+750,360+(i)*480/graph.length,-graph[i]*param+750);
    }
    
    fill(#D89125);
    rect(920,800,140,50);
    textI("back",920,800,16,0);
    if(buttonPressed(920,800,140,50)){
      //whichGraph=1;
      shown=null;
    }
    
    
    fill(#D89125);
    rect(920,860,140,50);
    if(leverage==-1)textI("buy/sell all",920,860,16,0);
    else textI("quantity "+leverage,920,860,16,0);
    if(buttonPressed(920,860,140,50)){
      switch(leverage){
      case 1:
        leverage=2;
        break;
      case 2:
        leverage=5;
        break;
      case 5:
        leverage=10;
        break;
      case 10:
        leverage=50;
        break;
      case 50:
        leverage=100;
        break;
      case 100:
        leverage=-1;
        break;
      default: 
        leverage=1;
        break;
      }
    }
    
    fill(#D89125);
    rect(920,920,140,50);
    if(whichGraph==1)textI("15 min",920,920,16,0);
    if(whichGraph==2)textI("2 hours",920,920,16,0);
    if(whichGraph==3)textI("24 hours",920,920,16,0);
    if(buttonPressed(920,920,140,50)){
      whichGraph=whichGraph%3+1;
    }
    
    fill(#D89125);
    rect(435,800,150,50);
    textI("you own "+youOwn+" "+name,435,800,14,0);
    
    fill(#D89125);
    rect(600,800,150,50);
    if(ownMiner>0)textI("you own a Miner",600,800,10,0);
    else textI("buy a miner: 60 coins",600,800,10,0);
    if(buttonPressed(600,800,150,50) && ownMiner==0 && money>=60){
      money=money-60;
      ownMiner++;
    }
    
    fill(#D89125);
    rect(765,800,150,50);
    textI("discard crypto: 10 coins",765,800,10,0);
    if(buttonPressed(765,800,150,50) && money>=10){
      money=money-10;
      if(this==k1){k1=new Krypto();shown=k1;}
      if(this==k2){k2=new Krypto();shown=k2;}
      if(this==k3){k3=new Krypto();shown=k3;}
    }
    
    fill(#D89125);
    rect(600,860,480,50);
    int buySellAll=(int)((money)/(fifteenmin[fifteenmin.length-1]*1.02));
    if(leverage==-1)textI("buy "+buySellAll+" for "+(int)(1+1.02*fifteenmin[fifteenmin.length-1]*buySellAll)+" $",600,860,16,0);
    else textI("buy "+leverage+" for "+(int)(1+1.02*fifteenmin[fifteenmin.length-1]*leverage)+" $",600,860,16,0);
    if(buttonPressed(600,860,480,50) && ((money>=(int)(1+1.02*fifteenmin[fifteenmin.length-1]*leverage) && leverage!=-1)||(leverage==-1&&buySellAll>0))){
      if(leverage==-1){
        money=money-(int)(1+1.02*fifteenmin[fifteenmin.length-1]*buySellAll);
        youOwn=youOwn+buySellAll;
      }else{
        money=money-(int)(1+1.02*fifteenmin[fifteenmin.length-1]*leverage);
        youOwn=youOwn+leverage;
      }
    }
    
    fill(#D89125);
    rect(600,920,480,50);
    buySellAll=youOwn;
    if(leverage==-1)textI("sell "+buySellAll+" for "+(int)(buySellAll*fifteenmin[fifteenmin.length-1])+" $",600,920,16,0);
    else textI("sell "+leverage+" for "+(int)(leverage*fifteenmin[fifteenmin.length-1])+" $",600,920,16,0);
    if(buttonPressed(600,920,480,50) && ((youOwn>=leverage && leverage!=-1)||leverage==-1)){
      if(leverage==-1){
        money=money+(int)(buySellAll*fifteenmin[fifteenmin.length-1]);
        youOwn=youOwn-buySellAll;
      }else{
        money=money+(int)(leverage*fifteenmin[fifteenmin.length-1]);
        youOwn=youOwn-leverage;
      }
    }
    
    textAlign(LEFT);
    textI(""+fifteenmin[fifteenmin.length-1],850,-graph[graph.length-1]*param+750,14,0);
    textAlign(CENTER,CENTER);
  }
    
  void calcGraph(){
    //15min
    if(nextEntryFif==second()){
      nextEntryFif=(second()+2)%60;
      
      if(random(100)<100/30)shortMedian=randomGaussian()*schwankung*(fifteenmin[fifteenmin.length-2])/50;
      for(int i=1;i<fifteenmin.length;i++){
        fifteenmin[i-1]=fifteenmin[i];
      }
      
      //calc new value 15min
      float median=fifteenmin[fifteenmin.length-1]+shortMedian+midMedian/8+longMedian/8/12;
      float newValue=randomGaussian()*4*schwankung*(fifteenmin[fifteenmin.length-1])/50  +  median;
      
      if(newValue<0.01){
        timerForKryptoBankrupt=4*120;
        kryptoBankrupt=name+" has gone bankrupt";
        if(this==k1){k1=new Krypto();shown=k1;}
        if(this==k2){k2=new Krypto();shown=k2;}
        if(this==k3){k3=new Krypto();shown=k3;}
      }else fifteenmin[fifteenmin.length-1]=newValue;
      
    }
    
    //2 hours
    if(nextEntryDay==second()){
      nextEntryDay=(second()+16)%60;
      
      //midMedian=(midMedian*0+1*(+day[day.length-1]*2-day[day.length-2]));
      if(random(100)<100/30)midMedian=randomGaussian()*schwankung*(fifteenmin[fifteenmin.length-1])/50;
      
      for(int i=1;i<day.length;i++){
        day[i-1]=day[i];
      }
      
      //calc new value day
      float newValue=0;
      for(int i=0;i<8;i++){
        newValue=newValue+fifteenmin[fifteenmin.length-1-8+i];
      }
      newValue=newValue/8;
      
      day[day.length-1]=newValue;
    }
    
    //month
    if(nextEntryMon==minute()*60+second()){
      nextEntryMon=(minute()*60+240+second())%3600;
      
      //longMedian=(longMedian*0+1*(month[month.length-1]*2-month[month.length-2]));
      if(random(100)<100/30)longMedian=randomGaussian()*schwankung*(fifteenmin[fifteenmin.length-1])/50+0.2;
      
      for(int i=1;i<month.length;i++){
        month[i-1]=month[i];
      }
      
      //calc new value day
      float newValue=0;
      for(int i=0;i<12;i++){
        newValue=newValue+day[day.length-1-12+i];
      }
      newValue=newValue/12;
      
      month[month.length-1]=newValue;
    }
    
    float miningChance=0;
    for(int i=0;i<fifteenmin.length;i++){
      miningChance=miningChance+fifteenmin[i];
    }
    miningChance=2/(miningChance /fifteenmin.length)  /1.2/60;
    if(ownMiner>=1  && random(100)<miningChance){
      youOwn=youOwn+1;
    }
  }
  
  void load(String datei){
    table=loadTable("data/"+datei+".csv", "header,csv");
    for(int i=0;i<fifteenmin.length;i++){
      fifteenmin[i]=table.getFloat(i+1, "short");
    }
    for(int i=0;i<day.length;i++){
      day[i]=table.getFloat(i+1, "mid");
    }
    for(int i=0;i<month.length;i++){
      month[i]=table.getFloat(i+1, "long");
    }
    nextEntryDay=(table.getInt(0, "mid")+second())%60;
    nextEntryMon=(table.getInt(0, "long")+minute()*60+second())%3600;
    
    shortMedian=randomGaussian()*schwankung*fifteenmin[fifteenmin.length-1]/50;
    midMedian=randomGaussian()*schwankung*day[day.length-1]/50;
    longMedian=randomGaussian()*schwankung*month[month.length-1]/50;
  }
  
  void save(String datei){
    table=loadTable("data/"+datei+".csv", "header,csv");
    for(int i=0;i<fifteenmin.length;i++){
      table.getRow(i+1).setFloat("short",fifteenmin[i]);
    }
    for(int i=0;i<day.length;i++){
      table.getRow(i+1).setFloat("mid",day[i]);
    }
    for(int i=0;i<month.length;i++){
      table.getRow(i+1).setFloat("long",month[i]);
    }
    
    if(nextEntryDay<minute()*60+second())nextEntryDay=nextEntryDay+3600;
    table.getRow(0).setInt("mid",nextEntryDay-minute()*60-second());
    
    if(nextEntryMon<hour()*3600+minute()*60+second())nextEntryMon=nextEntryMon+24*60*60;
    table.getRow(0).setInt("long",nextEntryMon-hour()*3600-minute()*60-second());
    
    saveTable(table, "data/"+datei+".csv");
  }
  
}
