class GameplayController < ApplicationController

  def new_hand
    game_id = params.fetch("game_id")
    game = Game.where({:id => game_id}).at(0)
    game.revealed = false;
    game.save

    # Shuffle the cards
    a = *(1..52)
    b = []
    52.times { |i|
      b.push(a.delete_at(rand(52-i)))
    }

    Card.all.each do |the_card|
      the_card.hand_player_id = nil
      the_card.deck_order = b[the_card.id]
      the_card.save
    end
    # Cards shuffled

    deck = Card.order(:deck_order)
    players = Player.where({ :current_game_id => game_id})

    # Deal 2 cards to each player
    top = 0
    2.times {
      players.each do |player|
        player.folded = false
        player.save
        deck[top].hand_player_id = player.id
        deck[top].save
        top += 1
      end
    }
    # Cards dealt
  end

  def flop
    if Card.where(:hand_player_id => 0).length() != 0
      return
    end

    deck = Card.where(:hand_player_id => nil).order(:deck_order)

    3.times { |top|
      deck[top].hand_player_id = 0
      deck[top].save
    }
  end

  def turn_river
    table_cards = Card.where(:hand_player_id => 0).length()
    if table_cards > 4 or table_cards < 3
      return
    end

    top_card = Card.where(:hand_player_id => nil).order(:deck_order).at(0)
    top_card.hand_player_id = 0
    top_card.save
  end

  def reveal_cards
    if Card.where(:hand_player_id => 0).length() != 5
      return
    end

    game_id = params.fetch("game_id")
    game = Game.where({:id => game_id}).at(0)
    game.revealed = true;
    game.save
  end

  def fold
    player = Player.where({ :id => session.fetch(:player_id)}).at(0)
    player.folded = true
    player.save
  end

end
