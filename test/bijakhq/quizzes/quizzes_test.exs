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
end
