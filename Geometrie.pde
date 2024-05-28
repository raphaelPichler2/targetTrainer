class Point{
  float posX;
  float posY;
  Point(float x,float y){
    posX=x;
    posY=y;
  }
  
  float distance(Point p){
    float distance=(float)Math.sqrt(Math.pow(p.posX-posX,2)+Math.pow(p.posY-posY,2));
    return distance;
  }
  
  void subtract(Point p){
    posX=posX-p.posX;
    posY=posY-p.posY;
  } 
}
