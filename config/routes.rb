Rails.application.routes.draw do
 
  resource :grant_details, only: [:new, :create], path: 'age-grant', path_names: {new: '/'}

  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :create, :edit, :update]

  get '/application_pending', to: 'pages#application_pending'
  get '/complete_application', to: 'pages#complete_application'
  

  get '/do-i-qualify', to: 'pages#do_i_qualify'
  get '/how-much-funding-is-available', to: 'pages#how_much_funding'
  get '/how-quickly-will-i-receive-the-money', to: 'pages#how_quickly_will_i_receive_the_money'
  get '/what-do-i-need-to-do-to-claim', to: 'pages#what_do_i_need_to_do_to_claim'
  get '/ive-already-applied-once-can-i-claim-again', to: 'pages#ive_already_applied_once_can_i_claim_again'
  get '/complaints-process', to: 'pages#complaints_process'


  get '/check_if_emails_need_to_go_out_to_people_who_registered_10_weeks_ago', to: 'pages#email_10_weeks_ago'
  get '/what-will-you-accept-as-a-review-document', to: 'pages#what_will_you_accept_as_a_review_document'
  get '/my-provider-has-not-completed-the-review-or-has-not-provided-me-with-a-copy--what-should-i-do', to: 'pages#my_provider_has_not_completed_the_review_or_has_not_provided_me_with_a_copy__what_should_i_do'
  get '/your-system-does-not-work-on-my-computer-what-do-i-do-now', to: 'pages#your_system_does_not_work_on_my_computer_what_do_i_do_now'
  get '/i-had-an-age-grant-from-government-in-the-last-year-can-i-still-claim-a-grant-from-you-if-i-take-on-another-apprentice', to: 'pages#i_had_an_age_grant_from_government_in_the_last_year_can_i_still_claim_a_grant_from_you_if_i_take_on_another_apprentice'
  get '/my-company-is-based-outside-norfolk-or-suffolk-what-should-i-do', to: 'pages#my_company_is_based_outside_norfolk_or_suffolk_what_should_i_do'
  get '/apply', to: 'grant_details#new'

  get '/login', to: 'sessions#new', as: :login
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: :logout

  get '/i-have-already-applied-for-a-grant-and-need-to-upload-evidence-to-claim', to: 'grant_reviews#new', as: :new_grant_review
  post '/i-have-already-applied-for-a-grant-and-need-to-upload-evidence-to-claim', to: 'grant_reviews#create', as: :grant_reviews

  namespace :admin do
    root :to => redirect('/admin/grant_details')
    get '/login', to: 'sessions#new', as: :login
    post '/login', to: 'sessions#create'
    get '/logout', to: 'sessions#destroy', as: :logout

    resources :training_providers
    resources :grant_details, only: [:index, :show, :destroy] do
      get 'download-evidence', as: :download_evidence, on: :member
    end
  end


  root to: 'pages#home'

end



'/do-i-qualify'
'/how-much-funding-is-available'
'/what-do-i-need-to-do-to-claim'
'/ive-already-applied-once-can-i-claim-again'
'/how-quickly-will-i-receive-the-money'
'/i-have-already-applied-for-a-grant-and-need-to-upload-evidence-to-claim'