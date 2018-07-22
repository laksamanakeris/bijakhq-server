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

      resources "/games", QuizSessionController, except: [:new, :edit] do
        resources "/questions", GameQuestionController, except: [:new, :edit]
      end


    end

    post "/sessions", SessionController, :create
    post "/users", UserController, :create_user
    get "/users/me", UserController, :show_me
    resources "/users", UserController, except: [:new, :edit]
    get "/confirm", ConfirmController, :index
    post "/password_resets", PasswordResetController, :create
    put "/password_resets/update", PasswordResetController, :update

    # Phone verification
    post "/verification", VerificationController, :authenticate
    post "/verification/:request_id", VerificationController, :verify
    post "/verification/:request_id/cancel", VerificationController, :cancel

    get "/categories", QuizCategoryController, :index
    resources "/questions", QuizQuestionController, except: [:new, :edit]

    get "/", SettingController, :landing
  end

  scope "/", BijakhqWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end
end
