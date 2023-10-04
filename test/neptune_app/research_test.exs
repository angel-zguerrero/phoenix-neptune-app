defmodule NeptuneApp.ResearchTest do
  use NeptuneApp.DataCase

  alias NeptuneApp.Research

  describe "collaborators" do
    alias NeptuneApp.Research.Collaborator

    import NeptuneApp.ResearchFixtures

    @invalid_attrs %{role: nil}

    test "list_collaborators/0 returns all collaborators" do
      collaborator = collaborator_fixture()
      assert Research.list_collaborators() == [collaborator]
    end

    test "get_collaborator!/1 returns the collaborator with given id" do
      collaborator = collaborator_fixture()
      assert Research.get_collaborator!(collaborator.id) == collaborator
    end

    test "create_collaborator/1 with valid data creates a collaborator" do
      valid_attrs = %{role: "some role"}

      assert {:ok, %Collaborator{} = collaborator} = Research.create_collaborator(valid_attrs)
      assert collaborator.role == "some role"
    end

    test "create_collaborator/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Research.create_collaborator(@invalid_attrs)
    end

    test "update_collaborator/2 with valid data updates the collaborator" do
      collaborator = collaborator_fixture()
      update_attrs = %{role: "some updated role"}

      assert {:ok, %Collaborator{} = collaborator} = Research.update_collaborator(collaborator, update_attrs)
      assert collaborator.role == "some updated role"
    end

    test "update_collaborator/2 with invalid data returns error changeset" do
      collaborator = collaborator_fixture()
      assert {:error, %Ecto.Changeset{}} = Research.update_collaborator(collaborator, @invalid_attrs)
      assert collaborator == Research.get_collaborator!(collaborator.id)
    end

    test "delete_collaborator/1 deletes the collaborator" do
      collaborator = collaborator_fixture()
      assert {:ok, %Collaborator{}} = Research.delete_collaborator(collaborator)
      assert_raise Ecto.NoResultsError, fn -> Research.get_collaborator!(collaborator.id) end
    end

    test "change_collaborator/1 returns a collaborator changeset" do
      collaborator = collaborator_fixture()
      assert %Ecto.Changeset{} = Research.change_collaborator(collaborator)
    end
  end

  describe "experiments" do
    alias NeptuneApp.Research.Experiment

    import NeptuneApp.ResearchFixtures

    @invalid_attrs %{name: nil, status: nil, description: nil, results: nil, conclusions: nil}

    test "list_experiments/0 returns all experiments" do
      experiment = experiment_fixture()
      assert Research.list_experiments() == [experiment]
    end

    test "get_experiment!/1 returns the experiment with given id" do
      experiment = experiment_fixture()
      assert Research.get_experiment!(experiment.id) == experiment
    end

    test "create_experiment/1 with valid data creates a experiment" do
      valid_attrs = %{name: "some name", status: :in_progress, description: "some description", results: "some results", conclusions: "some conclusions"}

      assert {:ok, %Experiment{} = experiment} = Research.create_experiment(valid_attrs)
      assert experiment.name == "some name"
      assert experiment.status == :in_progress
      assert experiment.description == "some description"
      assert experiment.results == "some results"
      assert experiment.conclusions == "some conclusions"
    end

    test "create_experiment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Research.create_experiment(@invalid_attrs)
    end

    test "update_experiment/2 with valid data updates the experiment" do
      experiment = experiment_fixture()
      update_attrs = %{name: "some updated name", status: :completed, description: "some updated description", results: "some updated results", conclusions: "some updated conclusions"}

      assert {:ok, %Experiment{} = experiment} = Research.update_experiment(experiment, update_attrs)
      assert experiment.name == "some updated name"
      assert experiment.status == :completed
      assert experiment.description == "some updated description"
      assert experiment.results == "some updated results"
      assert experiment.conclusions == "some updated conclusions"
    end

    test "update_experiment/2 with invalid data returns error changeset" do
      experiment = experiment_fixture()
      assert {:error, %Ecto.Changeset{}} = Research.update_experiment(experiment, @invalid_attrs)
      assert experiment == Research.get_experiment!(experiment.id)
    end

    test "delete_experiment/1 deletes the experiment" do
      experiment = experiment_fixture()
      assert {:ok, %Experiment{}} = Research.delete_experiment(experiment)
      assert_raise Ecto.NoResultsError, fn -> Research.get_experiment!(experiment.id) end
    end

    test "change_experiment/1 returns a experiment changeset" do
      experiment = experiment_fixture()
      assert %Ecto.Changeset{} = Research.change_experiment(experiment)
    end
  end

  describe "comments" do
    alias NeptuneApp.Research.Comment

    import NeptuneApp.ResearchFixtures

    @invalid_attrs %{content: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Research.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Research.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{content: "some content"}

      assert {:ok, %Comment{} = comment} = Research.create_comment(valid_attrs)
      assert comment.content == "some content"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Research.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{content: "some updated content"}

      assert {:ok, %Comment{} = comment} = Research.update_comment(comment, update_attrs)
      assert comment.content == "some updated content"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Research.update_comment(comment, @invalid_attrs)
      assert comment == Research.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Research.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Research.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Research.change_comment(comment)
    end
  end

  describe "scientific_operations" do
    alias NeptuneApp.Research.ScientificOperation

    import NeptuneApp.ResearchFixtures

    @invalid_attrs %{type: nil, result: nil, parameters: nil, remoteId: nil, remoteStatus: nil, remoteResult: nil}

    test "list_scientific_operations/0 returns all scientific_operations" do
      scientific_operation = scientific_operation_fixture()
      assert Research.list_scientific_operations() == [scientific_operation]
    end

    test "get_scientific_operation!/1 returns the scientific_operation with given id" do
      scientific_operation = scientific_operation_fixture()
      assert Research.get_scientific_operation!(scientific_operation.id) == scientific_operation
    end

    test "create_scientific_operation/1 with valid data creates a scientific_operation" do
      valid_attrs = %{type: "some type", result: %{}, parameters: %{}, remoteId: "some remoteId", remoteStatus: "some remoteStatus", remoteResult: %{}}

      assert {:ok, %ScientificOperation{} = scientific_operation} = Research.create_scientific_operation(valid_attrs)
      assert scientific_operation.type == "some type"
      assert scientific_operation.result == %{}
      assert scientific_operation.parameters == %{}
      assert scientific_operation.remoteId == "some remoteId"
      assert scientific_operation.remoteStatus == "some remoteStatus"
      assert scientific_operation.remoteResult == %{}
    end

    test "create_scientific_operation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Research.create_scientific_operation(@invalid_attrs)
    end

    test "update_scientific_operation/2 with valid data updates the scientific_operation" do
      scientific_operation = scientific_operation_fixture()
      update_attrs = %{type: "some updated type", result: %{}, parameters: %{}, remoteId: "some updated remoteId", remoteStatus: "some updated remoteStatus", remoteResult: %{}}

      assert {:ok, %ScientificOperation{} = scientific_operation} = Research.update_scientific_operation(scientific_operation, update_attrs)
      assert scientific_operation.type == "some updated type"
      assert scientific_operation.result == %{}
      assert scientific_operation.parameters == %{}
      assert scientific_operation.remoteId == "some updated remoteId"
      assert scientific_operation.remoteStatus == "some updated remoteStatus"
      assert scientific_operation.remoteResult == %{}
    end

    test "update_scientific_operation/2 with invalid data returns error changeset" do
      scientific_operation = scientific_operation_fixture()
      assert {:error, %Ecto.Changeset{}} = Research.update_scientific_operation(scientific_operation, @invalid_attrs)
      assert scientific_operation == Research.get_scientific_operation!(scientific_operation.id)
    end

    test "delete_scientific_operation/1 deletes the scientific_operation" do
      scientific_operation = scientific_operation_fixture()
      assert {:ok, %ScientificOperation{}} = Research.delete_scientific_operation(scientific_operation)
      assert_raise Ecto.NoResultsError, fn -> Research.get_scientific_operation!(scientific_operation.id) end
    end

    test "change_scientific_operation/1 returns a scientific_operation changeset" do
      scientific_operation = scientific_operation_fixture()
      assert %Ecto.Changeset{} = Research.change_scientific_operation(scientific_operation)
    end
  end

  describe "ingestions" do
    alias NeptuneApp.Research.Ingestion

    import NeptuneApp.ResearchFixtures

    @invalid_attrs %{code: nil, lastDate: nil}

    test "list_ingestions/0 returns all ingestions" do
      ingestion = ingestion_fixture()
      assert Research.list_ingestions() == [ingestion]
    end

    test "get_ingestion!/1 returns the ingestion with given id" do
      ingestion = ingestion_fixture()
      assert Research.get_ingestion!(ingestion.id) == ingestion
    end

    test "create_ingestion/1 with valid data creates a ingestion" do
      valid_attrs = %{code: "some code", lastDate: ~T[14:00:00]}

      assert {:ok, %Ingestion{} = ingestion} = Research.create_ingestion(valid_attrs)
      assert ingestion.code == "some code"
      assert ingestion.lastDate == ~T[14:00:00]
    end

    test "create_ingestion/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Research.create_ingestion(@invalid_attrs)
    end

    test "update_ingestion/2 with valid data updates the ingestion" do
      ingestion = ingestion_fixture()
      update_attrs = %{code: "some updated code", lastDate: ~T[15:01:01]}

      assert {:ok, %Ingestion{} = ingestion} = Research.update_ingestion(ingestion, update_attrs)
      assert ingestion.code == "some updated code"
      assert ingestion.lastDate == ~T[15:01:01]
    end

    test "update_ingestion/2 with invalid data returns error changeset" do
      ingestion = ingestion_fixture()
      assert {:error, %Ecto.Changeset{}} = Research.update_ingestion(ingestion, @invalid_attrs)
      assert ingestion == Research.get_ingestion!(ingestion.id)
    end

    test "delete_ingestion/1 deletes the ingestion" do
      ingestion = ingestion_fixture()
      assert {:ok, %Ingestion{}} = Research.delete_ingestion(ingestion)
      assert_raise Ecto.NoResultsError, fn -> Research.get_ingestion!(ingestion.id) end
    end

    test "change_ingestion/1 returns a ingestion changeset" do
      ingestion = ingestion_fixture()
      assert %Ecto.Changeset{} = Research.change_ingestion(ingestion)
    end
  end
end
