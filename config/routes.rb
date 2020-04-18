Rails.application.routes.draw do

  # Routes for the Card resource:
          
  # READ
  get("/cards", { :controller => "cards", :action => "index" })
  post("/change_deck_image", { :controller => "cards", :action => "change_deck" })

  #------------------------------

  # Routes for the Game resource:

  # CREATE
  post("/insert_game", { :controller => "games", :action => "create" })
  get("/create_or_join", { :controller => "games", :action => "create_or_join" })
  get("/", { :controller => "games", :action => "create_or_join" })
  post("/take_a_seat", { :controller => "games", :action => "sit_down" })
          
  # READ
  get("/games", { :controller => "games", :action => "index" })
  get("/games/:path_id", { :controller => "games", :action => "show" })
  post("/join_game", { :controller => "games", :action => "join" })
  get("/before_we_begin", { :controller => "games", :action => "pre_game" })
  get("/table_top/:game_id", { :controller => "games", :action => "table_top"})
  
  # UPDATE
  
  post("/modify_game/:path_id", { :controller => "games", :action => "update" })
  post("/leave_table", { :controller => "games", :action => "leave_table"})
  
  # DELETE
  get("/delete_game/:path_id", { :controller => "games", :action => "destroy" })

  #------------------------------

  # Routes for the Player account:

  # SIGN UP FORM
  get("/player_sign_up", { :controller => "players", :action => "new_registration_form" })        
  # CREATE RECORD
  post("/insert_player", { :controller => "players", :action => "create"  })
      
  # EDIT PROFILE FORM        
  get("/edit_player_profile", { :controller => "players", :action => "edit_registration_form" })       
  # UPDATE RECORD
  post("/modify_player", { :controller => "players", :action => "update" })
  
  # DELETE RECORD
  get("/cancel_player_account", { :controller => "players", :action => "destroy" })

  # ------------------------------

  # SIGN IN FORM
  get("/player_sign_in", { :controller => "player_sessions", :action => "new_session_form" })
  # AUTHENTICATE AND STORE COOKIE
  post("/player_verify_credentials", { :controller => "player_sessions", :action => "create_cookie" })
  
  # SIGN OUT        
  get("/player_sign_out", { :controller => "player_sessions", :action => "destroy_cookies" })
             
  #------------------------------

  # ROUTES FOR THE GAMEPLAY

  post("/new_hand", { :controller => "gameplay", :action => "new_hand"})
  post("/flop", { :controller => "gameplay", :action => "flop"})
  post("/turn_river", { :controller => "gameplay", :action => "turn_river"})
  post("/reveal_cards", { :controller => "gameplay", :action => "reveal_cards"})
  post("/fold", { :controller => "gameplay", :action => "fold"})

  # ======= Add Your Routes Above These =============
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
