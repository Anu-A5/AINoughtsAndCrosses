class gameboard
{
  int     back_opacity; //
  int     size;         // Board is a square
  int     state;        // Whose turn it is
  int[]   draw_coords;  // Where to draw the grid
  
  int[][] game_state; 
  //int[][] previous_game_state;
  
  float[]   end_game_line_start;
  float[]   end_game_line_end;
  
  gameboard (int x_coord, int y_coord, int Size) {
    draw_coords    = new int[2]; // Where to draw the grid
    draw_coords[0] = x_coord;
    draw_coords[1] = y_coord;
    
    back_opacity   = 10;         //
    size           = Size;        // Board is a square
      
    game_state     = new int[3][3];
    //previous_game_state     = new int[3][3];
    for(int y = 0; y < 3; y++) {
      for(int x = 0; x < 3; x++) {
        game_state[x][y] = 0;   
        //previous_game_state[x][y] = 0;  
      }
    }  
     
    
    
    
    end_game_line_start  = new float[2]; // Coords for red line to show win
    end_game_line_end    = new float[2]; // Coords for red line to show win
    
    end_game_line_start[0] = 0.0;
    end_game_line_start[1] = 0.0;
    end_game_line_end[0]   = 0.0;
    end_game_line_end[1]   = 0.0;
  }
  
  void draw_board()
  {
     float top_left_x = this.draw_coords[0]-(this.size/2);
     float top_left_y = this.draw_coords[1]-(this.size/2);
     rectMode(CENTER);
     
    
     //background square
     fill(250,250,250);
     noStroke();
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
  
  void draw_game_state()
  {
    float top_left_centre_x = this.draw_coords[0] - (this.size)/3;
    float top_left_centre_y = this.draw_coords[1] - (this.size)/3;
    int textsize = 100; 
    
    textSize(100);
    fill(0,0,0);
    textAlign(CENTER, CENTER);
    
    for(int rows = 0; rows<3; rows++){
      for(int cols = 0; cols<3; cols++){

        switch(this.game_state[rows][cols]){
          case 0:
            text("", top_left_centre_x+(this.size*rows)/3, top_left_centre_y+(this.size*cols)/3 - textsize/5);
            break;
          case 1:
            text("X", top_left_centre_x+(this.size*rows)/3, top_left_centre_y+(this.size*cols)/3 - textsize/5);
            break;
          case 2:
            text("0", top_left_centre_x+(this.size*rows)/3, top_left_centre_y+(this.size*cols)/3 - textsize/5);
            break;
        }
        
      }
    }
  }
  
  void reset_game()
  {
    for(int y = 0; y < 3; y++) {
      for(int x = 0; x < 3; x++) {
        this.game_state[x][y] = 0;   
        //this.previous_game_state[x][y] = 0;  
      }
    }  
  }
  
  boolean user_input()
  {
      float top_left_x = this.draw_coords[0]-(this.size/2);
      float top_left_y = this.draw_coords[1]-(this.size/2);
      
      int   clicked_x  = -1;
      int   clicked_y  = -1;
      
      if((mouseX >= top_left_x) && (mouseX <= top_left_x + this.size) && (mouseY >= top_left_y) && (mouseY <= top_left_y + this.size))
      {
        if(mouseX < (top_left_x + (this.size/3))){
          clicked_x = 0; 
        }else if((mouseX > (top_left_x + (this.size/3))) && (mouseX < (top_left_x + (2*this.size/3)))){
          clicked_x = 1; 
        }else{
          clicked_x = 2; 
        }
        
        if(mouseY < (top_left_y + (this.size/3))){
          clicked_y = 0; 
        }else if((mouseY > (top_left_y + (this.size/3))) && (mouseY < (top_left_y + (2*this.size/3)))){
          clicked_y = 1; 
        }else{
          clicked_y = 2; 
        }
        
      }
      
      if((clicked_x != -1) &&(clicked_y != -1)){
        if(this.game_state[clicked_x][clicked_y] == 0){
          this.game_state[clicked_x][clicked_y] = 1; 

          return true;
        }
      }
      return false;
  }
  
  int[][] get_game_state(){
    return this.game_state; 
  }
  
  //int[][] get_previous_game_state(){
  //  return this.previous_game_state; 
  //}
  
  void set_game_state(int[][] updated_game_state){
    this.game_state =  updated_game_state;
  }
  
  //void set_previous_game_state(int[][] updated_game_state){
  //  this.previous_game_state =  updated_game_state;
  //}
  
  
  int check_game_end_cond(){
    
    this.end_game_line_start[0] = -1;
    this.end_game_line_start[1] = -1;
    this.end_game_line_end[0]   = -1;
    this.end_game_line_end[1]   = -1;
    
    float top_left_centre_x = this.draw_coords[0] - (this.size)/3;
    float top_left_centre_y = this.draw_coords[1] - (this.size)/3;
    
    int game_end = 0; //0 - game continue, 1 - user wins, 2 - robot wins, 3 - draw
    
    //Board Full Condition
    
    int board_full = 1; // assume board is full
    
    //User Wins condition
    int user_won   = 0; 
    
    //Robot Wins condition
    int robot_won  = 0;
    

    for(int x = 0; x < 3; x++){
      for(int y = 0; y < 3; y++){
                
        //check row
        if((this.game_state[0][y] == 1) && (this.game_state[1][y] == 1) && (this.game_state[2][y] == 1))
        {
          user_won = 1; 
          
          this.end_game_line_start[0] = top_left_centre_x; 
          this.end_game_line_start[1] = top_left_centre_y * (y+1);
          
          this.end_game_line_end[0]   = top_left_centre_x + (this.size * 2)/3;
          this.end_game_line_end[1]   = top_left_centre_y * (y+1);
          
        }
        
        if((this.game_state[0][y] == 2) && (this.game_state[1][y] == 2) && (this.game_state[2][y] == 2))
        {
          robot_won = 1; 
          
          this.end_game_line_start[0] = top_left_centre_x; 
          this.end_game_line_start[1] = top_left_centre_y * (y+1);
          
          this.end_game_line_end[0]   = top_left_centre_x + (this.size * 2)/3;
          this.end_game_line_end[1]   = top_left_centre_y * (y+1);
        }
        
      }
      
      if((this.game_state[x][0] == 1) && (this.game_state[x][1] == 1) && (this.game_state[x][2] == 1))
      {
        user_won = 1; 
        
        this.end_game_line_start[0] = top_left_centre_x * (x+1) - ((width/4.6)*x); 
        this.end_game_line_start[1] = top_left_centre_y;
        
        this.end_game_line_end[0]   = top_left_centre_x * (x+1) - ((width/4.6)*x);
        this.end_game_line_end[1]   = top_left_centre_y + (this.size * 2)/3;
      }
      
      if((this.game_state[x][0] == 2) && (this.game_state[x][1] == 2) && (this.game_state[x][2] == 2))
      {
        robot_won = 1; 

        this.end_game_line_start[0] = top_left_centre_x * (x+1) - ((width/4.6)*x); 
        this.end_game_line_start[1] = top_left_centre_y;
        
        this.end_game_line_end[0]   = top_left_centre_x * (x+1) - ((width/4.6)*x);
        this.end_game_line_end[1]   = top_left_centre_y + (this.size * 2)/3;
      }

    }
    
    for(int x = 0; x < 3; x++){
      for(int y = 0; y < 3; y++){
        if(this.game_state[x][y] == 0)
        {
          //board is not full
          board_full = 0;
          
        }
      }
    }
    
    //check diagonal win
    if((this.game_state[0][0] == 1) && (this.game_state[1][1] == 1) && (this.game_state[2][2] == 1)){
      user_won = 1;
      this.end_game_line_start[0] = top_left_centre_x; 
      this.end_game_line_start[1] = top_left_centre_y;
      
      this.end_game_line_end[0]   = top_left_centre_x + (this.size * 2)/3;
      this.end_game_line_end[1]   = top_left_centre_y + (this.size * 2)/3;

    }
    if((this.game_state[2][0] == 1) && (this.game_state[1][1] == 1) && (this.game_state[0][2] == 1)){
      user_won = 1;
      this.end_game_line_start[0] = top_left_centre_x + (this.size * 2)/3; 
      this.end_game_line_start[1] = top_left_centre_y;
      
      this.end_game_line_end[0]   = top_left_centre_x ;
      this.end_game_line_end[1]   = top_left_centre_y + (this.size * 2)/3;
    }
    
    if((this.game_state[0][0] == 2) && (this.game_state[1][1] == 2) && (this.game_state[2][2] == 2)){
      robot_won = 1;
      this.end_game_line_start[0] = top_left_centre_x; 
      this.end_game_line_start[1] = top_left_centre_y;
      
      this.end_game_line_end[0]   = top_left_centre_x + (this.size * 2)/3;
      this.end_game_line_end[1]   = top_left_centre_y + (this.size * 2)/3;
    }
    if((this.game_state[2][0] == 2) && (this.game_state[1][1] == 2) && (this.game_state[0][2] == 2)){
      robot_won = 1;
      this.end_game_line_start[0] = top_left_centre_x + (this.size * 2)/3; 
      this.end_game_line_start[1] = top_left_centre_y;
      
      this.end_game_line_end[0]   = top_left_centre_x ;
      this.end_game_line_end[1]   = top_left_centre_y + (this.size * 2)/3;
    }
    
    if(user_won==1){
      game_end = 1;
    }else if(robot_won==1){
      game_end = 2;
    }else if(board_full==1){
      game_end = 3; 
    }else{
      game_end = 0; 
    }
    return game_end; 
  }
  
}
