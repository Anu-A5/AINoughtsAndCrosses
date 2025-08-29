// CLASSIC AI, REDUCED TO SEARCHING ALGORITHM

gamerunner GR;

int view_user_tree_screen  = 0;
int view_robot_tree_screen = 0;

int difficulty = 0;

void setup()
{
  fullScreen(2);
  background(255,255,255); // Change to moving background
  
  GR = new gamerunner(width/2, height/2, int(height*1.5)/2, 1, 1);
  print(width);
  
}

void draw()
{
  if(view_user_tree_screen == 1){
    GR.view_user_tree();
  }else if(view_robot_tree_screen == 1){
    GR.view_robot_tree();
  }else{
    if(difficulty == 1){
       background(255,240,240);
    }else if(difficulty == 2){
      background(255,180,180);
    }else{
      background(255,255,255);
    }
    
    textSize(80);
    text("AI NOUGHTS AND CROSSES", width/2, height/15);
    
    fill(255,255,255);
    Button reset_b         = new Button(int(width*5)/6, height/2 - 25, 120, 80, "RESET", 30);
    Button robot_view_tree = new Button(int(width)/8, (int(height/2) - 160), 170, 80, "ROBOT TREE", 30);
    Button user_view_tree  = new Button(int(width)/8, (int(height/2) + 100), 160, 90, "YOUR TREE",  30);
    
    fill(0,128,0);
    Button easy_b    = new Button(int(width*5)/6, (int(height/2) - 150), 40, 50, "EASY",  10);
    fill(128,128,0);
    Button medium_b  = new Button(int(width*5)/6 + 40, (int(height/2) - 150), 40, 50, "MEDIUM",  10);
    fill(128,0,0);
    Button hard_b    = new Button(int(width*5)/6 + 80, (int(height/2) - 150), 40, 50, "IMPOSSIBLE",  6);
    
    
    GR.run_game();
    
    if(easy_b.Click()){
      difficulty = 0; 
    }
    
    if(medium_b.Click()){
      difficulty = 1;
    }
    
    if(hard_b.Click()){
      difficulty = 2;
    }
    
    
    if(reset_b.Click()){
      //reset game state
      GR.reset_game();
    }
    
    if(user_view_tree.Click()){
      view_user_tree_screen = 1;
    }
    
    if(robot_view_tree.Click()){
      view_robot_tree_screen = 1;
    }
  }
}

void mousePressed() {
  GR.user_input();
}
