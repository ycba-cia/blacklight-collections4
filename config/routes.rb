Rails.application.routes.draw do
  mount Blacklight::Engine => '/'
  root to: "catalog#index"
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  #
  #get 'print/:id/:size/:index' => 'print#show' #deprecated, moved to catalog/print in line below
  get 'catalog/print/:id1/:size/:index' => 'catalog#print'

  get 'bookcover/isbn/:isbn' => 'book_cover#show'
  get 'bookcover/isbn/:isbn/size/:size' => 'book_cover#show'

  get 'catalog/:id/cite', :to => "catalog#cite", :as => "catalog_citation"

  get 'vufind/Record/:vufind_id' => 'vufind#show'

  get 'vufind/Search/Results' => 'catalog#index'

  get 'oaicatmuseum/OAIHandler' => 'vufind#oaicat'
end
