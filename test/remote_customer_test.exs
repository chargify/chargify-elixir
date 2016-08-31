defmodule CustomerTest do
  use ExUnit.Case

  test "list customers and then get one of them" do
    {:created, customer} = Chargify.Customers.create(%{
      "first_name" => "Test",
      "last_name" => "Tester",
      "email" => "test@example.com"
    })
    assert %{
      "first_name" => "Test",
      "last_name" => "Tester",
      "email" => "test@example.com"
    } = customer

    id = customer["id"]

    {:ok, customers} = Chargify.Customers.list(per_page: 1, direction: "desc")
    assert hd(customers)["id"] == id

    {:ok, customer} = Chargify.Customers.get(id)
    assert customer["id"] == id
  end
end
