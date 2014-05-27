Certus::Application.routes.draw do
  get :login,   controller: :user_sessions, action: :new
  get :logout,  controller: :user_sessions, action: :destroy

  resources :user_sessions

  get "orders/show"
  # You can have the root of your site routed with "root"
  root 'deliveries#picklist'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):


  namespace :admin do
    get "/", controller: :deliveries, action: :history
    resources :users
    resources :deliveries do
      collection do
        get :history
        get :picklist
      end
    end
  end

  namespace :customer do
    resources :orders, only: [:show, :update]
  end

  scope :api do
    resources :deliveries do
      collection do
        get 'picklist'
        get 'search'
        get 'unpicked_orders'
        get 'load_unpicked_order'
        get 'sort_picking_orders'
        delete 'remove_picked_orders'
        get 'picking_print'
        get 'print_packing_list'
        get 'history'
      end
    end

    resources :delivery_items, only: [ :show ] do
      collection do
        post 'pick'
      end
      member do
        post 'update_location'
        post 'substitute'
      end
    end

    resources :products, only: [:index, :new, :create, :destroy] do
      collection do
        get 'search/:store_sku' => 'products#search'
      end
      member do
        post 'update_location'
        post 'update_property'
      end
    end

    resources :locations do
      collection do
        post 'create_by_info' => 'locations#create_by_info'
      end
      resources :products, only: [:index, :create] do
        collection do
          get 'relocation/:store_sku' => 'products#relocation'
          post 'create_at_location'
        end
      end
    end

    resources :users do
      collection do
        get 'pickers' => 'users#pickers'
      end
    end

    resources :delivery_picker_ships do
      collection do
        post 'create_by_params' => 'delivery_picker_ships#create_by_params'
      end
    end
  end

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
