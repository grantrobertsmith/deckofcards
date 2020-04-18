class GamesController < ApplicationController
  
  def sit_down
    @current_player = Player.where({ :id => session.fetch(:player_id)}).at(0)
    @current_player.current_game_id = session.fetch(:game_id)
    @current_player.save
    
    redirect_to("/before_we_begin")
  end

  def pre_game
    this_game = Game.where({ :id => session.fetch(:game_id)}).at(0)
    if this_game
      render({ :template => "games/before_we_begin.html.erb" })
    else
      redirect_to("/create_or_join", { :alert => "The game was deleted." })
    end
    
  end

  def join
    the_passcode = params.fetch("query_passcode")
    @game = Game.where({ :passcode => the_passcode}).at(0)

    if @game == nil
      redirect_to("/create_or_join", { :alert => "Incorrect passcode." })
    else
      session.store(:game_id, @game.id)

      redirect_to("/before_we_begin")
    end
  end
  
  def create_or_join
    render({ :template => "games/create_or_join.html.erb" })
  end

  def leave_table
    player = Player.where({ :id => session.fetch(:player_id)}).at(0)
    player.current_game_id = nil
    player.save
    render({ :template => "games/create_or_join.html.erb"})
  end

  def index
    @games = Game.all.order({ :created_at => :desc })

    render({ :template => "games/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")
    @game = Game.where({:id => the_id }).at(0)

    render({ :template => "games/show.html.erb" })
  end

  def table_top
    game_id = params.fetch("game_id")
    @game = Game.where({:id => game_id }).at(0)
    @player_id = Player.where({ :id => session.fetch(:player_id)}).at(0).id
    @table_cards = Card.where({:hand_player_id => 0}).order(:deck_order)
    @players = Player.where({:current_game_id => @game.id})
    @hands = []

    @players.each do |player|
      @hands.push(Card.where({:hand_player_id => player.id}))
    end

    render({ :template => "games/table_top.html.erb" })
  end

  def create
    @game = Game.new
    @game.passcode = params.fetch("query_passcode")
    @game.creator_id = session.fetch(:player_id)
    
    if @game.valid?
      @game.save
      session.store(:game_id, @game.id)
      redirect_to("/before_we_begin", { :alert => "Game created successfully." })
    else
      redirect_to("/create_or_join", { :notice => "Game failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    @game = Game.where({ :id => the_id }).at(0)

    @game.passcode = params.fetch("query_passcode")
    @game.creator_id = params.fetch("query_creator_id")

    if @game.valid?
      @game.save
      redirect_to("/games/#{@game.id}", { :notice => "Game updated successfully."} )
    else
      redirect_to("/games/#{@game.id}", { :alert => "Game failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    @game = Game.where({ :id => the_id }).at(0)

    @game.theplayers.each do |the_player|
      the_player.current_game_id = nil
    end

    Card.all.each do |the_card|
      the_card.back_image = "https://terrigen-cdn-dev.marvel.com/content/prod/1x/theavengers_lob_crd_03.jpg"
      the_card.save
    end

    @game.destroy

    redirect_to("/create_or_join", { :notice => "Game deleted successfully."} )
  end

end
