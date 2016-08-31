defmodule RemoteProductTest do
  use ExUnit.Case

  @tag :remote
  test "foo" do
    {:created, product_family} = Chargify.ProductFamilies.create(%{
      "name" => "Acme Online",
      "handle" => "acme-online",
      "description" => "A product family",
    })

    product_family_id = product_family["id"]

    {:created, product} = Chargify.Products.create(%{
      "name" => "Pro Plan",
      "product_family_id" => product_family_id,
      "interval_unit" => "month",
      "interval" => 1,
      "price_in_cents" => 9900
    })
    assert %{
      "name" => "Pro Plan",
      "product_family" => %{
        "id" => product_family_id,
      },
      "interval_unit" => "month",
      "interval" => 1,
      "price_in_cents" => 9900
    } = product

    id = product["id"]

    {:ok, products} = Chargify.Products.list(per_page: 1)
    assert hd(products)["id"] == id

    {:ok, product} = Chargify.Products.get(id)
    assert product["id"] == id
  end
end
