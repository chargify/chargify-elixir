defmodule CustomerTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney, options: [clear_mock: true]

  test "list customers when there are none" do
    use_cassette :stub, [
      url: "https://my-subdomain.chargify.com/customers",
      headers: [{"Content-Type", "application/json; charset=utf-8"}],
      body: customers_json(0),
      status_code: 200] do
        assert {:ok, json} = Chargify.Customers.list
        assert json == []
    end
  end

  test "list customers when there are some" do
    use_cassette :stub, [
      url: "https://my-subdomain.chargify.com/customers",
      headers: [{"Content-Type", "application/json; charset=utf-8"}],
      body: customers_json(2),
      status_code: 200] do
        assert {:ok, json} = Chargify.Customers.list
        assert [
          %{
            "id" => 1,
            "first_name" => "First1",
            "last_name" => "Last1",
            "email" => "email1@example.com",
            "organization" => "Company1",
            "reference" => "1",
            "address" => "1 Main St",
            "city" => "City1",
            "state" => "State1",
            "zip" => "1"},
          %{
            "id" => 2,
            "first_name" => "First2",
            "last_name" => "Last2",
            "email" => "email2@example.com",
            "organization" => "Company2",
            "reference" => "2",
            "address" => "2 Main St",
            "city" => "City2",
            "state" => "State2",
            "zip" => "2"},
        ] = json
    end
  end

  test "get customer when it exists" do
    use_cassette :stub, [
      url: "https://my-subdomain.chargify.com/customers/1",
      headers: [{"Content-Type", "application/json; charset=utf-8"}],
      body: customer_json(1),
      status_code: 200] do
        assert {:ok, json} = Chargify.Customers.get(1)
        assert %{
          "id" => 1,
          "first_name" => "First1",
          "last_name" => "Last1",
          "email" => "email1@example.com",
          "organization" => "Company1",
          "reference" => "1",
          "address" => "1 Main St",
          "city" => "City1",
          "state" => "State1",
          "zip" => "1"} = json
    end
  end

  defp customers_json(count) do
    indexes = 1..count |> Enum.take(count)
    Enum.map(indexes, &customer_map(&1)) |> Poison.encode!
  end

  defp customer_json(id) do
    customer_map(id) |> Poison.encode!
  end

  defp customer_map(i) do
    %{
      "customer" => %{
        "id" => i,
        "address" => "#{i} Main St",
        "city" => "City#{i}",
        "email" => "email#{i}@example.com",
        "first_name" => "First#{i}",
        "last_name" => "Last#{i}",
        "organization" => "Company#{i}",
        "reference" => "#{i}",
        "state" => "State#{i}",
        "zip" => "#{i}"
      }
    }
  end
end
