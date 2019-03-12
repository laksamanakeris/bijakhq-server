defmodule BijakhqWeb.Router do
  use BijakhqWeb, :router

  # Set token max to 1 year
  @max_age 365 * 24 * 60 * 60

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Phauxth.Authenticate, method: :token, max_age: @max_age
  end

  pipeline :api_admin do
    plug BijakhqWeb.Plug.RequireAdmin
  end

  scope host: "api.", alias: BijakhqWeb.Api, as: :api do
    pipe_through :api

    scope "/admin" do
      pipe_through :api_admin

      resources "/users", UserController, except: [:new, :edit]
      resources "/referrals", ReferralController, except: [:new, :edit]

      resources "/categories", QuizCategoryController, except: [:new, :edit]
      resources "/questions", QuizQuestionController, except: [:new, :edit]

      # resources "/payments", PaymentController, except: [:new, :edit]
      # resources "/payment-statuses", PaymentStatusController, except: [:new, :edit]
      # resources "/payment-types", PaymentTypeController, except: [:new, :edit]
      # resources "/payment-batches", PaymentBatchController, except: [:new, :edit]
      # resources "/payment-batch-items", PaymentBatchItemController, except: [:new, :edit]

      scope "/payment"do
        resources "/requests", PaymentController, except: [:new, :edit]
        resources "/batches", PaymentBatchController, only: [:index, :show] do
          resources "/items", PaymentBatchItemController, only: [:index]
        end
        post "/batches/new", PaymentBatchController, :create_new_batch
        get "/batches/:id/paypal", PaymentBatchController, :get_paypal_update
        resources "/statuses", PaymentStatusController, except: [:new, :edit]
        resources "/types", PaymentTypeController, except: [:new, :edit]
      end

      resources "/games", QuizSessionController, except: [:new, :edit] do
        get "/questions/:id/randomize_answers", GameQuestionController, :randomize_answers
        resources "/questions", GameQuestionController, except: [:new, :edit]
      end
      get "/games/leaderboard/weekly", QuizSessionController, :leaderboard_weekly
      get "/games/leaderboard/all-time", QuizSessionController, :leaderboard_alltime

      resources "/games-users", QuizUserController, except: [:new, :edit]

      get "/games-users/:game_id/extra-life", QuizUserController, :add_extra_life
      post "/users/:id/lives", UserController, :add_extra_life_to_user

      scope "/notifications" do
        resources "/tokens", ExpoTokenController
        resources "/messages", PushMessageController
      end

    end

    post "/sessions", SessionController, :create
    post "/users", UserController, :create_user
    post "/users/me/upload", UserController, :upload_image_profile
    post "/users/username/available", UserController, :check_username
    post "/users/referral", ReferralController, :add_referral
    post "/users/me/payment", PaymentController, :request_payment
    get "/users/me", UserController, :show_me
    put "/users/me", UserController, :update_me
    post "/users/me/token", ExpoTokenController, :add_token

    get "/confirm", ConfirmController, :index
    post "/password_resets", PasswordResetController, :create
    put "/password_resets/update", PasswordResetController, :update

    # Phone verification
    post "/verification", VerificationController, :authenticate
    post "/verification/:request_id", VerificationController, :verify
    post "/verification/:request_id/cancel", VerificationController, :cancel

    get "/categories", QuizCategoryController, :index
    resources "/questions", QuizQuestionController, except: [:new, :edit]

    get "/games/now", QuizSessionController, :now
    get "/games/leaderboard/weekly", QuizSessionController, :leaderboard_weekly
    get "/games/leaderboard/all-time", QuizSessionController, :leaderboard_alltime

    get "/", SettingController, :landing
  end

  scope "/", BijakhqWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/command-center-alpha-tango-create-tokens/:id_start/:id_end", PageController, :gen_token
    get "/command-center-alpha-tango-create-tokens/users", PageController, :gen_token_users
    get "/health", PageController, :health

    get "/command-center-alpha-tango/cache/players", PageController, :extract_cache_players
    get "/command-center-alpha-tango/cache/winners", PageController, :extract_cache_winners
  end
end