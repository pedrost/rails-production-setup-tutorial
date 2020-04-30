Rails.application.routes.draw do
  get "poll/:id" => "polls#show"
  post "poll" => "polls#create"

  get "poll/:id/stats" => "polls#stats"
  post "poll/:id/vote" => "polls#vote"
end
