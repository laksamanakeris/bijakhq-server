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

  scope host: "api.", alias: BijakhqWeb.Api, as: :api do
    pipe_through :api

    scope "/admin" do
      resources "/users", UserController, except: [:new, :edit]

      resources "/categories", QuizCategoryController, except: [:new, :edit]
      resources "/questions", QuizQuestionController, except: [:new, :edit]

      resources "/payments", PaymentController, except: [:new, :edit]

      resources "/games", QuizSessionController, except: [:new, :edit] do
        get "/questions/:id/randomize_answers", GameQuestionController, :randomize_answers
        resources "/questions", GameQuestionController, except: [:new, :edit]
      end
      get "/games/leaderboard/weekly", QuizSessionController, :leaderboard_weekly
      get "/games/leaderboard/all-time", QuizSessionController, :leaderboard_alltime


    end

    post "/sessions", SessionController, :create
    post "/users", UserController, :create_user
    post "/users/me/upload", UserController, :upload_image_profile
    post "/users/username/available", UserController, :check_username
    get "/users/me", UserController, :show_me
    put "/users/me", UserController, :update_me

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
  end
end
