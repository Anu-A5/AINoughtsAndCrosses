class robotinterface
{
  int setting; //0 for random, 1 for AI
  int max_depth;
  int[][] current_game_state;
  
  robotinterface (int Setting, int Max_Depth)
  {
     setting     = Setting;
     max_depth   = Max_Depth; 
  }
  
  boolean make_move(int[][] game_state)
  {
    int posx = -1;
    int posy = -1;
    
    this.current_game_state = game_state;
    
    //make game move in here 
    //set posx and posy to ai net move
    switch(this.setting){
      case 0: //random
        ArrayList<int[][]> user_poss_moves_f = new ArrayList<int[][]>();
        user_poss_moves_f = this.find_robot_poss_moves(this.current_game_state);
        
        int random_move = int(random(0, user_poss_moves_f.size()));
        
        for(int x = 0; x < 3; x++){
          for(int y = 0; y < 3; y++){
            if(user_poss_moves_f.get(random_move)[x][y] == 4){
              posx = x;
              posy = y;
            }
          }
        }
        break;
        
      case 1:
        ArrayList<int[][]> user_poss_moves_a = new ArrayList<int[][]>();
        user_poss_moves_a = this.find_robot_poss_moves(this.current_game_state);
        
        FloatList heuristics = new FloatList();
        heuristics = this.get_game_state_heuristics(user_poss_moves_a);
        
        print("HEURISTICS:  ");
        for(int i = 0; i < heuristics.size(); i++){
          print(heuristics.get(i));
          print(" ");
        }
        
              
        ArrayList<Integer> max_value_indexs = new ArrayList<Integer>();
        float max_value = 0.0;
        for(int i = 0; i < heuristics.size(); i++){
          if(heuristics.get(i) >= max_value){
            max_value = heuristics.get(i);
          }
        }
        
        println();
        print("MAX VALUE:  ");
        print(max_value);
                
        
        for(int i = 0; i < heuristics.size(); i++){
          if(heuristics.get(i) == max_value){
            max_value_indexs.add(i);
          }
        }
        
        println();
        print("max_value indexes: ");
        for(int i = 0; i < max_value_indexs.size(); i++){
          print(max_value_indexs.get(i));
          print(" ");
        }
        

        int random_ai_move = 0;
        random_ai_move = int(random(0, max_value_indexs.size()));
        
        println();
        print("random_ai_move index:  ");
        print(random_ai_move);
        
        println();
        println("output grid:  ");
        for(int x = 0; x < 3; x++){
          for(int y = 0; y < 3; y++){
            if(user_poss_moves_a.get(max_value_indexs.get(random_ai_move))[x][y] == 4){
               posx = x;
               posy = y;
            }
            print(user_poss_moves_a.get(max_value_indexs.get(random_ai_move))[y][x]);
          }
          println();
        }
         
        break;
      
    }


    this.current_game_state[posx][posy] = 2;
    
    return true;
  }
  
  ArrayList<int[][]> find_user_poss_moves(int[][] game_state)
  {
    
    ArrayList<int[][]> user_poss_moves     = new ArrayList<int[][]>();
    
    
    for(int y = 0; y < 3; y++){
      for(int x = 0; x < 3; x++){
        if(game_state[x][y] == 0){
          
          int[][] possible_game_state = new int[3][3];
          for(int a = 0; a < 3; a++){
            for(int b = 0; b < 3; b++){
              possible_game_state[a][b] = game_state[a][b];    
            }
          }  
          
          possible_game_state[x][y] = 3;//3 is new X
          
          user_poss_moves.add(possible_game_state);
          
        }
      }
    }
   
    return user_poss_moves;
  }
  
  ArrayList<int[][]> find_robot_poss_moves(int[][] game_state)
  {
    
    ArrayList<int[][]> robot_poss_moves     = new ArrayList<int[][]>();
    
    
    for(int y = 0; y < 3; y++){
      for(int x = 0; x < 3; x++){
        if(game_state[x][y] == 0){
          
          int[][] possible_game_state = new int[3][3];
          for(int a = 0; a < 3; a++){
            for(int b = 0; b < 3; b++){
              possible_game_state[a][b] = game_state[a][b];    
            }
          }  
          
          possible_game_state[x][y] = 4; // New O
          
          robot_poss_moves.add(possible_game_state);
          
        }
      }
    }
   
    return robot_poss_moves;
  }
  
  FloatList get_game_state_heuristics(ArrayList<int[][]> game_state)
  {
     FloatList heuristics = new FloatList();
     
     if(this.setting == 0){
       for(int i = 0; i < game_state.size(); i++){
         float val = 1.0/game_state.size();
         heuristics.append(val);
       }
       heuristics.reverse();
     }else{
       for(int i = 0; i < game_state.size(); i++){
         float val = 0;
         
         //check if its a win
         // - plus 100
         //check if it blocks a win
         // - plus 100
         //check if u can win on next turn
         // - plus 20
         //corner or centre
         // - plus 10
         //non corner or centre
         // - plus 1
         
         //check if its a win--------------------------------------------------------------------------------------------------------------
         int win = 0;
         for(int x = 0; x < 3; x++){
           for(int y = 0; y < 3; y++){
             //check row
             if((game_state.get(i)[0][y] == 4) && (game_state.get(i)[1][y] == 2) && (game_state.get(i)[2][y] == 2)){win = 1;}
             if((game_state.get(i)[0][y] == 2) && (game_state.get(i)[1][y] == 4) && (game_state.get(i)[2][y] == 2)){win = 1;}
             if((game_state.get(i)[0][y] == 2) && (game_state.get(i)[1][y] == 2) && (game_state.get(i)[2][y] == 4)){win = 1;}
           } 
           //check col
           if((game_state.get(i)[x][0] == 4) && (game_state.get(i)[x][1] == 2) && (game_state.get(i)[x][2] == 2)){win = 1;}
           if((game_state.get(i)[x][0] == 2) && (game_state.get(i)[x][1] == 4) && (game_state.get(i)[x][2] == 2)){win = 1;}
           if((game_state.get(i)[x][0] == 2) && (game_state.get(i)[x][1] == 2) && (game_state.get(i)[x][2] == 4)){win = 1;}
         }
         //check diagonal win
         if((game_state.get(i)[0][0] == 4) && (game_state.get(i)[1][1] == 2) && (game_state.get(i)[2][2] == 2)){win = 1;}
         if((game_state.get(i)[0][0] == 2) && (game_state.get(i)[1][1] == 4) && (game_state.get(i)[2][2] == 2)){win = 1;}
         if((game_state.get(i)[0][0] == 2) && (game_state.get(i)[1][1] == 2) && (game_state.get(i)[2][2] == 4)){win = 1;}
         
         if((game_state.get(i)[2][0] == 4) && (game_state.get(i)[1][1] == 2) && (game_state.get(i)[0][2] == 2)){win = 1;}
         if((game_state.get(i)[2][0] == 2) && (game_state.get(i)[1][1] == 4) && (game_state.get(i)[0][2] == 2)){win = 1;}
         if((game_state.get(i)[2][0] == 2) && (game_state.get(i)[1][1] == 2) && (game_state.get(i)[0][2] == 4)){win = 1;}
         //--------------------------------------------------------------------------------------------------------------------------------
         
         
         //check if it blocks a win--------------------------------------------------------------------------------------------------------
         int blocks_win = 0;
         for(int x = 0; x < 3; x++){
           for(int y = 0; y < 3; y++){
             //check row
             if((game_state.get(i)[0][y] == 4) && (game_state.get(i)[1][y] == 1) && (game_state.get(i)[2][y] == 1)){blocks_win = 1;}
             if((game_state.get(i)[0][y] == 1) && (game_state.get(i)[1][y] == 4) && (game_state.get(i)[2][y] == 1)){blocks_win = 1;}
             if((game_state.get(i)[0][y] == 1) && (game_state.get(i)[1][y] == 1) && (game_state.get(i)[2][y] == 4)){blocks_win = 1;}
           }
          //check col
          if((game_state.get(i)[x][0] == 4) && (game_state.get(i)[x][1] == 1) && (game_state.get(i)[x][2] == 1)){blocks_win = 1;}
          if((game_state.get(i)[x][0] == 1) && (game_state.get(i)[x][1] == 4) && (game_state.get(i)[x][2] == 1)){blocks_win = 1;}
          if((game_state.get(i)[x][0] == 1) && (game_state.get(i)[x][1] == 1) && (game_state.get(i)[x][2] == 4)){blocks_win = 1;}
         }
         
         //check block diagonal win
         if((game_state.get(i)[0][0] == 4) && (game_state.get(i)[1][1] == 1) && (game_state.get(i)[2][2] == 1)){blocks_win = 1;}
         if((game_state.get(i)[0][0] == 1) && (game_state.get(i)[1][1] == 4) && (game_state.get(i)[2][2] == 1)){blocks_win = 1;}
         if((game_state.get(i)[0][0] == 1) && (game_state.get(i)[1][1] == 1) && (game_state.get(i)[2][2] == 4)){blocks_win = 1;}
         
         if((game_state.get(i)[2][0] == 4) && (game_state.get(i)[1][1] == 1) && (game_state.get(i)[0][2] == 1)){blocks_win = 1;}
         if((game_state.get(i)[2][0] == 1) && (game_state.get(i)[1][1] == 4) && (game_state.get(i)[0][2] == 1)){blocks_win = 1;}
         if((game_state.get(i)[2][0] == 1) && (game_state.get(i)[1][1] == 1) && (game_state.get(i)[0][2] == 4)){blocks_win = 1;}
         //---------------------------------------------------------------------------------------------------------------------------------
         
         //check if you can win next turn---------------------------------------------------------------------------------------------------
         int next_win = 0;
         for(int x = 0; x < 3; x++){
           for(int y = 0; y < 3; y++){
             //check row
             if((game_state.get(i)[0][y] == 2) && (game_state.get(i)[1][y] == 4) && (game_state.get(i)[2][y] == 0)){next_win = 1;}
             if((game_state.get(i)[0][y] == 4) && (game_state.get(i)[1][y] == 2) && (game_state.get(i)[2][y] == 0)){next_win = 1;}
             if((game_state.get(i)[0][y] == 0) && (game_state.get(i)[1][y] == 2) && (game_state.get(i)[2][y] == 4)){next_win = 1;}
             if((game_state.get(i)[0][y] == 0) && (game_state.get(i)[1][y] == 4) && (game_state.get(i)[2][y] == 2)){next_win = 1;}
             if((game_state.get(i)[0][y] == 2) && (game_state.get(i)[1][y] == 0) && (game_state.get(i)[2][y] == 4)){next_win = 1;}
             if((game_state.get(i)[0][y] == 4) && (game_state.get(i)[1][y] == 0) && (game_state.get(i)[2][y] == 2)){next_win = 1;}
           }
          //check col
          if((game_state.get(i)[x][0] == 2) && (game_state.get(i)[x][1] == 4) && (game_state.get(i)[x][2] == 0)){next_win = 1;}
          if((game_state.get(i)[x][0] == 4) && (game_state.get(i)[x][1] == 2) && (game_state.get(i)[x][2] == 0)){next_win = 1;}
          if((game_state.get(i)[x][0] == 0) && (game_state.get(i)[x][1] == 2) && (game_state.get(i)[x][2] == 4)){next_win = 1;}
          if((game_state.get(i)[x][0] == 0) && (game_state.get(i)[x][1] == 4) && (game_state.get(i)[x][2] == 2)){next_win = 1;}
          if((game_state.get(i)[x][0] == 2) && (game_state.get(i)[x][1] == 0) && (game_state.get(i)[x][2] == 4)){next_win = 1;}
          if((game_state.get(i)[x][0] == 4) && (game_state.get(i)[x][1] == 0) && (game_state.get(i)[x][2] == 2)){next_win = 1;}
          
         }
         
         //check next diagonal win
         if((game_state.get(i)[0][0] == 4) && (game_state.get(i)[1][1] == 2) && (game_state.get(i)[2][2] == 0)){next_win = 1;}
         if((game_state.get(i)[0][0] == 2) && (game_state.get(i)[1][1] == 4) && (game_state.get(i)[2][2] == 0)){next_win = 1;}
         if((game_state.get(i)[2][0] == 0) && (game_state.get(i)[1][1] == 4) && (game_state.get(i)[0][2] == 2)){next_win = 1;}
         if((game_state.get(i)[2][0] == 0) && (game_state.get(i)[1][1] == 2) && (game_state.get(i)[0][2] == 4)){next_win = 1;}
         if((game_state.get(i)[0][0] == 2) && (game_state.get(i)[1][1] == 0) && (game_state.get(i)[2][2] == 4)){next_win = 1;}
         if((game_state.get(i)[0][0] == 4) && (game_state.get(i)[1][1] == 0) && (game_state.get(i)[2][2] == 2)){next_win = 1;}
         //---------------------------------------------------------------------------------------------------------------------------------
         
         //check if diagonal or centre
         int centre_diag = 0;
         if((game_state.get(i)[0][0] == 4) || (game_state.get(i)[1][1] == 4) || (game_state.get(i)[2][2] == 4) || (game_state.get(i)[2][0] == 4) || (game_state.get(i)[0][2] == 4))
         {
           centre_diag = 1;
         }
         
         //check other
         int others = 0;
         if((game_state.get(i)[1][0] == 4) || (game_state.get(i)[0][1] == 4) || (game_state.get(i)[2][1] == 4) || (game_state.get(i)[1][2] == 4))
         {
           others = 1;
         }
         
         if(difficulty == 0){
           val = win*10 + blocks_win*10 + next_win*10 + centre_diag*10 + others; //easy
         }else if(difficulty == 1){
           val = win*11 + blocks_win*10 + next_win*5 + centre_diag*5 + others*5; //medium
         }else if(difficulty == 2){
           val = win*200 + blocks_win*100 + next_win*20 + centre_diag*10 + others; //impossible
         }else{
           val = win*11 + blocks_win*10 + next_win*5 + centre_diag*5 + others*5; //medium
         }

         heuristics.append(val);
       }
       //heuristics.reverse();
       
     }
     
     return heuristics;
  }
  
  int[][] get_game_state()
  {
    return this.current_game_state; 
  }
  
}
