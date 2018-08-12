defmodule Bijakhq.Repo.Migrations.UpdateTablesRemoveReferenceConstraints do
  use Ecto.Migration

  # def change do

    # alter table(:quiz_questions) do
    #   modify :category_id, references(:quiz_categories, on_delete: :delete_all)
    # end

    # alter table(:quiz_session_question) do
    #   modify :session_id, references(:quiz_sessions, on_delete: :delete_all)
    #   modify :question_id, references(:quiz_questions, on_delete: :delete_all)
    # end

    # alter table(:quiz_scores) do
    #   modify :user_id, references(:users, on_delete: :delete_all)
    #   modify :game_id, references(:quiz_sessions, on_delete: :delete_all)
    # end

    # def up do

    #   execute "ALTER TABLE quiz_session_question DROP CONSTRAINT quiz_session_question_session_id_fkey"
    #   execute "ALTER TABLE quiz_session_question DROP CONSTRAINT quiz_session_question_question_id_fkey"
    #   alter table(:quiz_session_question) do
    #     modify(:session_id, references(:quiz_sessions, on_delete: :delete_all))
    #     modify(:question_id, references(:quiz_questions, on_delete: :delete_all))
    #   end
    # end

    # def down do
    #   execute "ALTER TABLE quiz_session_question DROP CONSTRAINT quiz_session_question_session_id_fkey"
    #   execute "ALTER TABLE quiz_session_question DROP CONSTRAINT quiz_session_question_question_id_fkey"
    #   alter table(:quiz_session_question) do
    #     modify(:session_id, references(:quiz_sessions, on_delete: :nothing))
    #     modify(:question_id, references(:quiz_questions, on_delete: :nothing))
    #   end
    # end
  # end

  def up do
    drop constraint(:quiz_session_question, "quiz_session_question_session_id_fkey")
    drop constraint(:quiz_session_question, "quiz_session_question_question_id_fkey")
    alter table(:quiz_session_question) do
      modify(:session_id, references(:quiz_sessions, on_delete: :delete_all))
      modify(:question_id, references(:quiz_questions, on_delete: :delete_all))
    end
  end

  def down do
    drop constraint(:quiz_session_question, "quiz_session_question_session_id_fkey")
    drop constraint(:quiz_session_question, "quiz_session_question_question_id_fkey")
    alter table(:quiz_session_question) do
      modify(:session_id, references(:quiz_sessions, on_delete: :nothing))
      modify(:question_id, references(:quiz_questions, on_delete: :nothing))
    end
  end


end
