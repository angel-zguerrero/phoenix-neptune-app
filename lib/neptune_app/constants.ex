defmodule NeptuneApp.Constants do
  @role_admin "admin"
  @role_scientist "scientist"

  defmacro role_admin, do: @role_admin
  defmacro role_scientist, do: @role_scientist
end
