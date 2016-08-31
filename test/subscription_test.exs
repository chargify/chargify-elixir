defmodule SubscriptionTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test "list subscriptions when there are none" do
    use_cassette :stub, [
      url: "https://my-subdomain.chargify.com/subscriptions",
      headers: [{"Content-Type", "application/json; charset=utf-8"}],
      body: subscriptions_json(0),
      status_code: 200] do
        assert {:ok, json} = Chargify.Subscriptions.list
        assert json == []
    end
  end

  test "list subscriptions when there are some" do
    use_cassette :stub, [
      url: "https://my-subdomain.chargify.com/subscriptions",
      headers: [{"Content-Type", "application/json; charset=utf-8"}],
      body: subscriptions_json(2),
      status_code: 200] do
        assert {:ok, json} = Chargify.Subscriptions.list
        assert [
          %{
            "customer" => %{
              "email" => "email1@example.com",
              "first_name" => "First1",
              "id" => 1,
              "last_name" => "Last1",
            },
            "id" => 1,
            "product" => %{
              "description" => "Basic",
              "id" => 1,
            }
          },
          %{
            "customer" => %{
              "email" => "email2@example.com",
              "first_name" => "First2",
              "id" => 2,
              "last_name" => "Last2",
            },
            "id" => 2,
            "product" => %{
              "description" => "Basic",
              "id" => 2,
            }
          }
        ] = json
    end
  end

  test "get subscription when it exists" do
    use_cassette :stub, [
      url: "https://my-subdomain.chargify.com/subscriptions/1",
      headers: [{"Content-Type", "application/json; charset=utf-8"}],
      body: subscription_json(1),
      status_code: 200] do
        assert {:ok, json} = Chargify.Subscriptions.get(1)
        assert %{
          "customer" => %{
            "email" => "email1@example.com",
            "first_name" => "First1",
            "last_name" => "Last1",
          },
          "id" => 1,
          "product" => %{
            "description" => "Basic",
            "id" => 1,
          }
        } = json
    end
  end

  defp subscriptions_json(count) do
    indexes = 1..count |> Enum.take(count)
    Enum.map(indexes, &subscription_map(&1)) |> Poison.encode!
  end

  defp subscription_json(id) do
    subscription_map(id) |> Poison.encode!
  end

  defp subscription_map(i) do
    %{
      "subscription" => %{
        "id" => i,
        "customer" => %{
          "id" => i,
          "first_name" => "First#{i}",
          "last_name" => "Last#{i}",
          "email" => "email#{i}@example.com",
        },
        "product" => %{
          "id" => i,
          "description" => "Basic",
        }
      }
    }
  end
end
