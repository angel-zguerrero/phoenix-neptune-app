defmodule NeptuneAppWeb.ErrorJSONTest do
  use NeptuneAppWeb.ConnCase, async: true

  test "renders 404" do
    assert NeptuneAppWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert NeptuneAppWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
