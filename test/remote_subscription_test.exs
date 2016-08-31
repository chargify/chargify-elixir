defmodule RemoteSubscriptionTest do
  use ExUnit.Case

  @tag :remote
  test "create a Subscription and then retrieve it" do
    {:created, subscription} = Chargify.Subscriptions.create(%{
      "product_handle" => "basic",
      "customer_attributes" => %{
        "first_name" => "Test",
        "last_name" => "Tester",
        "email" => "test@example.com"
      },
      "payment_profile_attributes" => %{
        "first_name" => "Test",
        "last_name" => "Tester",
        "full_number" => "4111111111111111",
        "expiration_month" => "12",
        "expiration_year" => "2020"
      }
    })
    assert %{
      "customer" => %{
        "first_name" => "Test",
        "last_name" => "Tester",
        "email" => "test@example.com"
      },
      "product" => %{
        "description" => "Basic",
      }
    } = subscription

    id = subscription["id"]

    {:ok, subscription} = Chargify.Subscriptions.list(per_page: 1, direction: "desc")
    assert hd(subscription)["id"] == id

    {:ok, subscription} = Chargify.Subscriptions.get(id)
    assert subscription["id"] == id
  end
end
