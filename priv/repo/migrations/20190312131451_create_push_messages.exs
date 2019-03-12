defmodule Bijakhq.Repo.Migrations.CreatePushMessages do
  use Ecto.Migration

  def change do
    create table(:pn_messages) do
      add :message, :string
      add :is_completed, :boolean, default: false, null: false
      add :total_tokens, :integer
      add :author_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:pn_messages, [:author_id])
  end
end
