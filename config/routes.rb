Rails.application.routes.draw do
  get ':page_namespace/:page_id' => 'test#index', as: 'page'
end
