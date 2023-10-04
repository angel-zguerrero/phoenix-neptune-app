defmodule NeptuneApp.Repo.Migrations.CreateIngestions do
  use Ecto.Migration

  def change do
    create table(:ingestions) do
      add :code, :string
      add :lastDate, :string

      timestamps()
    end
  end
end
