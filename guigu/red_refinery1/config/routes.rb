# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :account, module: "accounts" do
    resource :password, only: %i[show update]
    resource :profile, only: %i[show update]
    resources :memberships, only: %i[index update]
  end

  resources :projects, only: [:index, :show] do
    scope module: :projects do
      resources :workflows, only: %i[index show] do
        scope module: :workflows do
          resources :instances, only: %i[index new create show destroy] do
            scope module: :instances do
              resources :observations, only: %i[index update]
              resources :tokens, only: %i[index show] do
                post "fire"
                patch "forward"
                patch "endorse"
                patch "adding_observation"
              end
            end
          end
        end
      end
    end
  end

  namespace :admin do
    root to: "home#index"

    resources :users, except: %i[destroy] do
      member do
        patch :lock
        patch :unlock
        patch :resend_confirmation_mail
        patch :resend_invitation_mail
      end
    end

    resources :tenants
  end

  resources :tenants, only: [] do
    scope module: :tenants do
      get "/", to: "home#index"

      namespace :admin do
        resources :projects do
          scope module: :projects do
            resources :trackers, except: %i[show]
            resources :groups, except: %i[show]
            resources :members, except: %i[show] do
              collection do
                post :sync
              end
            end

            resources :workflow_categories, except: %i[show]
            resources :workflows do
              scope module: :workflows do
                resource :load, only: %i[show update]
                resources :transitions, only: %i[index edit update] do
                  scope module: :transitions do
                    resource :options, only: %i[edit update]
                  end
                end
                resources :instances, only: %i[index show destroy] do
                  scope module: :instances do
                    resources :tokens, only: %i[show] do
                      post "fire"
                      patch "forward"
                    end
                  end
                end
              end
            end

            resources :forms do
              collection do
                post "random"
              end

              scope module: :forms do
                resource :preview, only: %i[show create]
                resources :entries do
                  collection do
                    post "random"
                  end
                end
                resources :fields, except: %i[show] do
                  collection do
                    put "move"
                  end

                  scope module: :fields do
                    resource :validations, only: %i[edit update]
                    resource :options, only: %i[edit update]
                    resource :scripts, only: %i[edit update]
                    resource :data_source_options, only: %i[edit update]
                    resources :choices, except: %i[show]
                  end
                end
              end
            end
          end
        end

        resources :dictionaries
      end
    end
  end

  namespace :api do
    resources :tenants, only: [] do
      scope module: :tenants do
        resources :hooks, only: [] do
          collection do
            post :user_connect
            post :issue_created
          end
        end
      end
    end
  end

  devise_for :users, skip: %i[registrations invitations], controllers: {
    confirmations: "users/confirmations",
    passwords: "users/passwords",
    sessions: "users/sessions"
  }

  devise_scope :user do
    resource :registrations,
             only: %i[new create],
             path: "users",
             path_names: { new: "sign_up" },
             controller: "users/registrations",
             as: :user_registration

    resource :invitations,
             only: %i[edit update],
             path: "users",
             controller: "users/invitations",
             as: :user_invitations
  end

  get "users", to: redirect("/users/sign_up")

  get "401", to: "errors#unauthorized", as: :unauthorized
  get "403", to: "errors#forbidden", as: :forbidden
  get "404", to: "errors#not_found", as: :not_found

  root to: "home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
