defmodule Bijakhq.QuizzesTest do
  use Bijakhq.DataCase

  alias Bijakhq.Quizzes

  describe "quiz_categories" do
    alias Bijakhq.Quizzes.QuizCategory

    @valid_attrs %{description: "some description", title: "some title"}
    @update_attrs %{description: "some updated description", title: "some updated title"}
    @invalid_attrs %{description: nil, title: nil}

    def quiz_category_fixture(attrs \\ %{}) do
      {:ok, quiz_category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Quizzes.create_quiz_category()

      quiz_category
    end

    test "list_quiz_categories/0 returns all quiz_categories" do
      quiz_category = quiz_category_fixture()
      assert Quizzes.list_quiz_categories() == [quiz_category]
    end

    test "get_quiz_category!/1 returns the quiz_category with given id" do
      quiz_category = quiz_category_fixture()
      assert Quizzes.get_quiz_category!(quiz_category.id) == quiz_category
    end

    test "create_quiz_category/1 with valid data creates a quiz_category" do
      assert {:ok, %QuizCategory{} = quiz_category} = Quizzes.create_quiz_category(@valid_attrs)
      assert quiz_category.description == "some description"
      assert quiz_category.title == "some title"
    end

    test "create_quiz_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Quizzes.create_quiz_category(@invalid_attrs)
    end

    test "update_quiz_category/2 with valid data updates the quiz_category" do
      quiz_category = quiz_category_fixture()
      assert {:ok, quiz_category} = Quizzes.update_quiz_category(quiz_category, @update_attrs)
      assert %QuizCategory{} = quiz_category
      assert quiz_category.description == "some updated description"
      assert quiz_category.title == "some updated title"
    end

    test "update_quiz_category/2 with invalid data returns error changeset" do
      quiz_category = quiz_category_fixture()
      assert {:error, %Ecto.Changeset{}} = Quizzes.update_quiz_category(quiz_category, @invalid_attrs)
      assert quiz_category == Quizzes.get_quiz_category!(quiz_category.id)
    end

    test "delete_quiz_category/1 deletes the quiz_category" do
      quiz_category = quiz_category_fixture()
      assert {:ok, %QuizCategory{}} = Quizzes.delete_quiz_category(quiz_category)
      assert_raise Ecto.NoResultsError, fn -> Quizzes.get_quiz_category!(quiz_category.id) end
    end

    test "change_quiz_category/1 returns a quiz_category changeset" do
      quiz_category = quiz_category_fixture()
      assert %Ecto.Changeset{} = Quizzes.change_quiz_category(quiz_category)
    end
  end

  describe "quiz_questions" do
    alias Bijakhq.Quizzes.QuizQuestion

    @valid_attrs %{answer: "some answer", optionB: "some optionB", optionC: "some optionC", question: "some question"}
    @update_attrs %{answer: "some updated answer", optionB: "some updated optionB", optionC: "some updated optionC", question: "some updated question"}
    @invalid_attrs %{answer: nil, optionB: nil, optionC: nil, question: nil}

    def quiz_question_fixture(attrs \\ %{}) do
      {:ok, quiz_question} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Quizzes.create_quiz_question()

      quiz_question
    end

    test "list_quiz_questions/0 returns all quiz_questions" do
      quiz_question = quiz_question_fixture()
      assert Quizzes.list_quiz_questions() == [quiz_question]
    end

    test "get_quiz_question!/1 returns the quiz_question with given id" do
      quiz_question = quiz_question_fixture()
      assert Quizzes.get_quiz_question!(quiz_question.id) == quiz_question
    end

    test "create_quiz_question/1 with valid data creates a quiz_question" do
      assert {:ok, %QuizQuestion{} = quiz_question} = Quizzes.create_quiz_question(@valid_attrs)
      assert quiz_question.answer == "some answer"
      assert quiz_question.optionB == "some optionB"
      assert quiz_question.optionC == "some optionC"
      assert quiz_question.question == "some question"
    end

    test "create_quiz_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Quizzes.create_quiz_question(@invalid_attrs)
    end

    test "update_quiz_question/2 with valid data updates the quiz_question" do
      quiz_question = quiz_question_fixture()
      assert {:ok, quiz_question} = Quizzes.update_quiz_question(quiz_question, @update_attrs)
      assert %QuizQuestion{} = quiz_question
      assert quiz_question.answer == "some updated answer"
      assert quiz_question.optionB == "some updated optionB"
      assert quiz_question.optionC == "some updated optionC"
      assert quiz_question.question == "some updated question"
    end

    test "update_quiz_question/2 with invalid data returns error changeset" do
      quiz_question = quiz_question_fixture()
      assert {:error, %Ecto.Changeset{}} = Quizzes.update_quiz_question(quiz_question, @invalid_attrs)
      assert quiz_question == Quizzes.get_quiz_question!(quiz_question.id)
    end

    test "delete_quiz_question/1 deletes the quiz_question" do
      quiz_question = quiz_question_fixture()
      assert {:ok, %QuizQuestion{}} = Quizzes.delete_quiz_question(quiz_question)
      assert_raise Ecto.NoResultsError, fn -> Quizzes.get_quiz_question!(quiz_question.id) end
    end

    test "change_quiz_question/1 returns a quiz_question changeset" do
      quiz_question = quiz_question_fixture()
      assert %Ecto.Changeset{} = Quizzes.change_quiz_question(quiz_question)
    end
  end

  describe "quiz_sessions" do
    alias Bijakhq.Quizzes.QuizSession

    @valid_attrs %{completed_at: "2010-04-17 14:00:00.000000Z", description: "some description", is_active: true, is_completed: true, name: "some name", prize: "some prize", prize_description: "some prize_description", time: "2010-04-17 14:00:00.000000Z", total_questions: 42}
    @update_attrs %{completed_at: "2011-05-18 15:01:01.000000Z", description: "some updated description", is_active: false, is_completed: false, name: "some updated name", prize: "some updated prize", prize_description: "some updated prize_description", time: "2011-05-18 15:01:01.000000Z", total_questions: 43}
    @invalid_attrs %{completed_at: nil, description: nil, is_active: nil, is_completed: nil, name: nil, prize: nil, prize_description: nil, time: nil, total_questions: nil}

    def quiz_session_fixture(attrs \\ %{}) do
      {:ok, quiz_session} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Quizzes.create_quiz_session()

      quiz_session
    end

    test "list_quiz_sessions/0 returns all quiz_sessions" do
      quiz_session = quiz_session_fixture()
      assert Quizzes.list_quiz_sessions() == [quiz_session]
    end

    test "get_quiz_session!/1 returns the quiz_session with given id" do
      quiz_session = quiz_session_fixture()
      assert Quizzes.get_quiz_session!(quiz_session.id) == quiz_session
    end

    test "create_quiz_session/1 with valid data creates a quiz_session" do
      assert {:ok, %QuizSession{} = quiz_session} = Quizzes.create_quiz_session(@valid_attrs)
      assert quiz_session.completed_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert quiz_session.description == "some description"
      assert quiz_session.is_active == true
      assert quiz_session.is_completed == true
      assert quiz_session.name == "some name"
      assert quiz_session.prize == "some prize"
      assert quiz_session.prize_description == "some prize_description"
      assert quiz_session.time == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert quiz_session.total_questions == 42
    end

    test "create_quiz_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Quizzes.create_quiz_session(@invalid_attrs)
    end

    test "update_quiz_session/2 with valid data updates the quiz_session" do
      quiz_session = quiz_session_fixture()
      assert {:ok, quiz_session} = Quizzes.update_quiz_session(quiz_session, @update_attrs)
      assert %QuizSession{} = quiz_session
      assert quiz_session.completed_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert quiz_session.description == "some updated description"
      assert quiz_session.is_active == false
      assert quiz_session.is_completed == false
      assert quiz_session.name == "some updated name"
      assert quiz_session.prize == "some updated prize"
      assert quiz_session.prize_description == "some updated prize_description"
      assert quiz_session.time == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert quiz_session.total_questions == 43
    end

    test "update_quiz_session/2 with invalid data returns error changeset" do
      quiz_session = quiz_session_fixture()
      assert {:error, %Ecto.Changeset{}} = Quizzes.update_quiz_session(quiz_session, @invalid_attrs)
      assert quiz_session == Quizzes.get_quiz_session!(quiz_session.id)
    end

    test "delete_quiz_session/1 deletes the quiz_session" do
      quiz_session = quiz_session_fixture()
      assert {:ok, %QuizSession{}} = Quizzes.delete_quiz_session(quiz_session)
      assert_raise Ecto.NoResultsError, fn -> Quizzes.get_quiz_session!(quiz_session.id) end
    end

    test "change_quiz_session/1 returns a quiz_session changeset" do
      quiz_session = quiz_session_fixture()
      assert %Ecto.Changeset{} = Quizzes.change_quiz_session(quiz_session)
    end
  end

  # describe "quiz_session_question" do
  #   alias Bijakhq.Quizzes.SessionQuestion

  #   @valid_attrs %{is_completed: true, sequence: 42, total_correct: 42}
  #   @update_attrs %{is_completed: false, sequence: 43, total_correct: 43}
  #   @invalid_attrs %{is_completed: nil, sequence: nil, total_correct: nil}

  #   def session_question_fixture(attrs \\ %{}) do
  #     {:ok, session_question} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Quizzes.create_session_question()

  #     session_question
  #   end

  #   @tag :skip
  #   test "list_quiz_session_question/0 returns all quiz_session_question" do
  #     session_question = session_question_fixture()
  #     assert Quizzes.list_quiz_session_question() == [session_question]
  #   end

  #   @tag :skip
  #   test "get_session_question!/1 returns the session_question with given id" do
  #     session_question = session_question_fixture()
  #     assert Quizzes.get_session_question!(session_question.id) == session_question
  #   end

  #   @tag :skip
  #   test "create_session_question/1 with valid data creates a session_question" do
  #     assert {:ok, %SessionQuestion{} = session_question} = Quizzes.create_session_question(@valid_attrs)
  #     assert session_question.is_completed == true
  #     assert session_question.sequence == 42
  #     assert session_question.total_correct == 42
  #   end

  #   @tag :skip
  #   test "create_session_question/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Quizzes.create_session_question(@invalid_attrs)
  #   end

  #   @tag :skip
  #   test "update_session_question/2 with valid data updates the session_question" do
  #     session_question = session_question_fixture()
  #     assert {:ok, session_question} = Quizzes.update_session_question(session_question, @update_attrs)
  #     assert %SessionQuestion{} = session_question
  #     assert session_question.is_completed == false
  #     assert session_question.sequence == 43
  #     assert session_question.total_correct == 43
  #   end

  #   @tag :skip
  #   test "update_session_question/2 with invalid data returns error changeset" do
  #     session_question = session_question_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Quizzes.update_session_question(session_question, @invalid_attrs)
  #     assert session_question == Quizzes.get_session_question!(session_question.id)
  #   end

  #   @tag :skip
  #   test "delete_session_question/1 deletes the session_question" do
  #     session_question = session_question_fixture()
  #     assert {:ok, %SessionQuestion{}} = Quizzes.delete_session_question(session_question)
  #     assert_raise Ecto.NoResultsError, fn -> Quizzes.get_session_question!(session_question.id) end
  #   end


  #   test "change_session_question/1 returns a session_question changeset" do
  #     session_question = session_question_fixture()
  #     assert %Ecto.Changeset{} = Quizzes.change_session_question(session_question)
  #   end
  # end

  describe "quiz_game_users" do
    alias Bijakhq.Quizzes.QuizUser

    @valid_attrs %{is_player: true, is_viewer: true}
    @update_attrs %{is_player: false, is_viewer: false}
    @invalid_attrs %{is_player: nil, is_viewer: nil}

    def quiz_user_fixture(attrs \\ %{}) do
      {:ok, quiz_user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Quizzes.create_quiz_user()

      quiz_user
    end

    test "list_quiz_game_users/0 returns all quiz_game_users" do
      quiz_user = quiz_user_fixture()
      assert Quizzes.list_quiz_game_users() == [quiz_user]
    end

    test "get_quiz_user!/1 returns the quiz_user with given id" do
      quiz_user = quiz_user_fixture()
      assert Quizzes.get_quiz_user!(quiz_user.id) == quiz_user
    end

    test "create_quiz_user/1 with valid data creates a quiz_user" do
      assert {:ok, %QuizUser{} = quiz_user} = Quizzes.create_quiz_user(@valid_attrs)
      assert quiz_user.is_player == true
      assert quiz_user.is_viewer == true
    end

    test "create_quiz_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Quizzes.create_quiz_user(@invalid_attrs)
    end

    test "update_quiz_user/2 with valid data updates the quiz_user" do
      quiz_user = quiz_user_fixture()
      assert {:ok, quiz_user} = Quizzes.update_quiz_user(quiz_user, @update_attrs)
      assert %QuizUser{} = quiz_user
      assert quiz_user.is_player == false
      assert quiz_user.is_viewer == false
    end

    test "update_quiz_user/2 with invalid data returns error changeset" do
      quiz_user = quiz_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Quizzes.update_quiz_user(quiz_user, @invalid_attrs)
      assert quiz_user == Quizzes.get_quiz_user!(quiz_user.id)
    end

    test "delete_quiz_user/1 deletes the quiz_user" do
      quiz_user = quiz_user_fixture()
      assert {:ok, %QuizUser{}} = Quizzes.delete_quiz_user(quiz_user)
      assert_raise Ecto.NoResultsError, fn -> Quizzes.get_quiz_user!(quiz_user.id) end
    end

    test "change_quiz_user/1 returns a quiz_user changeset" do
      quiz_user = quiz_user_fixture()
      assert %Ecto.Changeset{} = Quizzes.change_quiz_user(quiz_user)
    end
  end
end
