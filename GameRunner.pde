class gamerunner
{
  gameboard GB;
  robotinterface RI;
  
  boolean user_turn;
  boolean user_turn_complete;
  boolean robot_turn_complete;
  int     game_end;
  int[][] previous_game_state;
  
  gamerunner(int game_board_coord_x, int game_board_coord_y, int game_board_size, int ai_setting, int ai_max_depth)
  {
     GB                  = new gameboard(game_board_coord_x, game_board_coord_y, game_board_size);
     RI                  = new robotinterface(ai_setting, ai_max_depth);
     
     user_turn           = true;
     user_turn_complete  = false;
     robot_turn_complete = false;
     game_end            = 0;
     
     previous_game_state     = new int[3][3];
     for(int y = 0; y < 3; y++) {
       for(int x = 0; x < 3; x++) { 
         previous_game_state[x][y] = 0;  
       }
     }  
    
  }
  
  void run_game()
  {
    this.GB.draw_board();
    this.GB.draw_game_state();
    
    
    this.game_end = 0;
    this.game_end = this.GB.check_game_end_cond();

    if(this.game_end == 0){

      if(this.user_turn_complete == true){
        this.game_end = this.GB.check_game_end_cond();
        this.user_turn = false;
        this.user_turn_complete = false;
        
        if(this.game_end == 0){
          for(int y = 0; y < 3; y++) {
            for(int x = 0; x < 3; x++) { 
              this.previous_game_state[x][y] = this.GB.get_game_state()[x][y];  
            }
          }  
          this.robot_turn_complete = this.RI.make_move(this.GB.get_game_state());
          if(this.robot_turn_complete == true){
            this.game_end = this.GB.check_game_end_cond();
            this.GB.set_game_state(RI.get_game_state());
            this.user_turn = true;
            this.robot_turn_complete = false;
          }
        } 
      }
    }else{
      strokeWeight(5);
      stroke(255,0,0);
      line(this.GB.end_game_line_start[0], this.GB.end_game_line_start[1], this.GB.end_game_line_end[0], this.GB.end_game_line_end[1]); 
    }
    
  }  
  
  void reset_game()
  {
    GB.reset_game();
    user_turn = true;
    user_turn_complete = false;
    robot_turn_complete = false;
  }
  
  void user_input()
  {
     if(this.user_turn && (this.game_end == 0) && (view_user_tree_screen == 0) && (view_robot_tree_screen == 0)){ 
       this.user_turn_complete = GB.user_input(); 
     }
  }
  
  void view_user_tree()
  {
    background(255,255,255);
    //user is green
    //ai is red
    
    //if user turn use green arrows
    //if robot turn use red arrows
    
    //make sure game hasnt ended.
    this.game_end = this.GB.check_game_end_cond();
    if(this.game_end == 0){
      //get current game state
      int[][] current_game_state  = this.GB.get_game_state(); 
      
      //get next possible moves
      ArrayList<int[][]> possible_moves = new ArrayList<int[][]>();
      
      //if users turn 
      if(user_turn == true){
        possible_moves = RI.find_user_poss_moves(current_game_state);
      }
      
      minigameboard MGB = new minigameboard(width/2 - 40, height/4, int(height)/4, int(user_turn));
      MGB.draw_board();
      MGB.set_game_state(current_game_state);
      MGB.draw_game_state();
      
      for(int i = 0; i < possible_moves.size(); i++){
        if(possible_moves.size() == 1){
          minigameboard PGB = new minigameboard((i+(9-possible_moves.size()))*int((width-100)/9) - ((9-possible_moves.size())*int(width/18)) + 150, int(height/2), min(100,int(width/9)), 2);
          PGB.draw_board();
          PGB.set_game_state(possible_moves.get(i));
          PGB.draw_game_state();
        }else{
          minigameboard PGB = new minigameboard((i+(9-possible_moves.size()))*int((width-100)/9) - ((9-possible_moves.size())*int(width/18)) + 150, int(height/2), min(100,int(width/9)), 2);
          PGB.draw_board();
          PGB.set_game_state(possible_moves.get(i));
          PGB.draw_game_state();
        }
      }
      
      fill(255,255,255);
      Button back_c = new Button((width/2)-90, height - 100, 120, 80, "BACK", 30);
      
      if(back_c.Click()){
        view_user_tree_screen = 0;  
      }
    }else{
      background(255,255,255);
      textSize(100);
      fill(0,0,0);
      textAlign(CENTER, CENTER);
      text("GAME ENDED", width/2, height/2);
      
      fill(255,255,255);
      Button back_e = new Button((width/2)-90, height - 100, 120, 80, "BACK", 30);
      
      if(back_e.Click()){
        view_user_tree_screen = 0;  
      }
    }

  }
  
  void view_robot_tree()
  {
    background(255,255,255);
    //user is green
    //ai is red
    
    //if user turn use green arrows
    //if robot turn use red arrows
    
    //make sure game hasnt ended.
    this.game_end = this.GB.check_game_end_cond();
    if(this.game_end == 0){
      //get current game state
      //int[][] previous_game_state = this.GB.get_previous_game_state(); 
      
      //get next possible moves
      ArrayList<int[][]> possible_moves_r = new ArrayList<int[][]>();
      FloatList heuristics                = new FloatList();
      
      possible_moves_r = RI.find_robot_poss_moves(this.previous_game_state);
      heuristics       = RI.get_game_state_heuristics(possible_moves_r);
      
      minigameboard MGB = new minigameboard(width/2 - 40, height/4, int(height)/4, 0);
      MGB.draw_board();
      MGB.set_game_state(previous_game_state);
      MGB.draw_game_state();
      
      for(int i = 0; i < possible_moves_r.size(); i++){
        
        minigameboard PGB = new minigameboard((i+(9-possible_moves_r.size()))*int((width-100)/9) - ((9-possible_moves_r.size())*int(width/18)) + 150, int(height/2), min(100,int(width/9)), 2);
        fill(0,0,0);
        textSize(20);
        text(String.format("%.3f", heuristics.get(i)),(i+(9-possible_moves_r.size()))*int((width-100)/9) - ((9-possible_moves_r.size())*int(width/18)) + 150, (height/2)+ 75 +((10-possible_moves_r.size())*5));
        PGB.draw_board();
        PGB.set_game_state(possible_moves_r.get(i));
        PGB.draw_game_state();
        
      }
      
      fill(255,255,255);
      Button back_c = new Button((width/2)-90, height - 100, 120, 80, "BACK", 30);
      
      if(back_c.Click()){
        view_robot_tree_screen = 0;  
      }
    }else{
      background(255,255,255);
      textSize(100);
      fill(0,0,0);
      textAlign(CENTER, CENTER);
      text("GAME ENDED", width/2, height/2);
      
      fill(255,255,255);
      Button back_e = new Button((width/2)-90, height - 100, 120, 80, "BACK", 30);
      
      if(back_e.Click()){
        view_robot_tree_screen = 0;  
      }
    }

  }
  
}
