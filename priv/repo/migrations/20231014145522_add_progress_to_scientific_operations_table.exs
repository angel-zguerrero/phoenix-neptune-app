defmodule NeptuneApp.Repo.Migrations.AddProgressToScientificOperationsTable do
  use Ecto.Migration

  def change do
    alter table(:scientific_operations) do
      add :progress, :float, after: :email, null: false, default: 0
    end
  end
end
