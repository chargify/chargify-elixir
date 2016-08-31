defmodule RemoteProductTest do
  use ExUnit.Case

  @tag :remote
  test "foo" do
    product_family_name = UUID.uuid4(:hex)
    product_name        = UUID.uuid4(:hex)
    
    {:created, product_family} = Chargify.ProductFamilies.create(%{
      "name" => product_family_name,
      "description" => "A product family",
    })

    product_family_id = product_family["id"]

    {:created, product} = Chargify.Products.create(%{
      "name" => product_name,
      "product_family_id" => product_family_id,
      "interval_unit" => "month",
      "interval" => 1,
      "price_in_cents" => 9900
    })
    assert %{
      "name" => product_name,
      "product_family" => %{
        "id" => product_family_id,
      },
      "interval_unit" => "month",
      "interval" => 1,
      "price_in_cents" => 9900
    } = product

    id = product["id"]

    {:ok, products} = Chargify.Products.list
    assert products
      |> Enum.map(fn product -> Map.get(product, "id") end) 
      |> Enum.member?(id)

    {:ok, product} = Chargify.Products.get(id)
    assert product["id"] == id
  end
end
