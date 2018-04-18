defmodule BijakhqWeb.Router do
  use BijakhqWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Phauxth.Authenticate, method: :token
  end

  scope "/api", BijakhqWeb do
    pipe_through :api

    post "/sessions", SessionController, :create
    resources "/users", UserController, except: [:new, :edit]
    get "/confirm", ConfirmController, :index
    post "/password_resets", PasswordResetController, :create
    put "/password_resets/update", PasswordResetController, :update

    resources "/categories", QuizCategoryController, except: [:new, :edit]
    resources "/questions", QuizQuestionController, except: [:new, :edit]
  end

  scope "/", BijakhqWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end
end
