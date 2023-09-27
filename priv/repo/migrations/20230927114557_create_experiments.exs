defmodule NeptuneApp.Repo.Migrations.CreateExperiments do
  use Ecto.Migration

  def change do
    create table(:experiments) do
      add :name, :string
      add :description, :string
      add :results, :string
      add :conclusions, :string
      add :status, :string

      timestamps()
    end
  end
end
