Rails.application.routes.draw do
  get "poll" => "polls#index"
  post "poll" => "polls#create"
  get "poll/:id" => "polls#show"

  get "poll/:id/stats" => "polls#stats"
  post "poll/:id/vote" => "polls#vote"
end
