defmodule NeptuneApp.Repo.Migrations.CreateScientificOperations do
  use Ecto.Migration

  def change do
    create table(:scientific_operations) do
      add :type, :string
      add :remoteId, :string
      add :remoteStatus, :string
      add :remoteResult, :map
      add :parameters, :map
      add :result, :map

      timestamps()
    end
  end
end
