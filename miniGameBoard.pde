class minigameboard
{
  int     back_opacity; //
  int     size;         // Board is a square
  int     state;        // Whose turn it is
  int[]   draw_coords;  // Where to draw the grid
  
  int[][] game_state; 
  
  
  minigameboard (int x_coord, int y_coord, int Size, int User_Turn) {
    draw_coords    = new int[2]; // Where to draw the grid
    draw_coords[0] = x_coord;
    draw_coords[1] = y_coord;
    
    back_opacity   = 10;         //
    size           = Size;        // Board is a square
      
    state = User_Turn;  //1 for user, 0 for robot
      
    game_state     = new int[3][3];
    for(int y = 0; y < 3; y++) {
      for(int x = 0; x < 3; x++) {
        game_state[x][y] = 0;     
      }
    }  
    
  }
  
  void draw_board()
  {
     float top_left_x = this.draw_coords[0]-(this.size/2);
     float top_left_y = this.draw_coords[1]-(this.size/2);
     rectMode(CENTER);
     
    
     //background square
     fill(250,250,250);
     strokeWeight(2);
     if(this.state == 1){
       stroke(0,128,0);
     }else if(this.state == 0){
       stroke(128,0,0);
     }else if(this.state == 2){
       noStroke(); 
     }
     square(this.draw_coords[0], this.draw_coords[1], this.size);
     
     stroke(0);
     strokeWeight(1);
     //draw grid lines
     for(int rows=1; rows<3; rows++){
       line((this.size*rows)/3 + top_left_x, top_left_y, (this.size*rows)/3 + top_left_x, top_left_y + this.size); 
     }
     for(int cols=1; cols<3; cols++){
       line(top_left_x,(this.size*cols)/3 + top_left_y, this.size + top_left_x, (this.size*cols)/3 + top_left_y); 
     }
  }
  
  void set_game_state(int[][] updated_game_state){
    this.game_state =  updated_game_state;
  }
  
  void draw_game_state()
  {
    float top_left_centre_x = this.draw_coords[0] - (this.size)/3;
    float top_left_centre_y = this.draw_coords[1] - (this.size)/3;
    int textsize = int(this.size/4.5); 
    
    textSize(textsize);
    fill(0,0,0);
    textAlign(CENTER, CENTER);
    
    for(int rows = 0; rows<3; rows++){
      for(int cols = 0; cols<3; cols++){

        switch(this.game_state[rows][cols]){
          case 0:
            text("", top_left_centre_x+(this.size*rows)/3, top_left_centre_y+(this.size*cols)/3 - textsize/5);
            break;
          case 1:
            fill(0,0,0);
            text("X", top_left_centre_x+(this.size*rows)/3, top_left_centre_y+(this.size*cols)/3 - textsize/5);
            break;
          case 2:
            fill(0,0,0);
            text("0", top_left_centre_x+(this.size*rows)/3, top_left_centre_y+(this.size*cols)/3 - textsize/5);
            break;
          case 3:
            fill(0,128,0);
            text("X", top_left_centre_x+(this.size*rows)/3, top_left_centre_y+(this.size*cols)/3 - textsize/5);
            break;
          case 4:
            fill(128,0,0);
            text("0", top_left_centre_x+(this.size*rows)/3, top_left_centre_y+(this.size*cols)/3 - textsize/5);
            break; 
           
        }
        
      }
    }
  }
  
}
