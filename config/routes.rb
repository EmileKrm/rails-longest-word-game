Rails.application.routes.draw do
  get 'game', to: 'matches#game'

  get 'score', to: 'matches#score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
