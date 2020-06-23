defmodule GildedRoseTest do
  use ExUnit.Case
  alias GildedRose.Item
  doctest GildedRose

  setup do
    products = GildedRose.new()
    {:ok, products: products}
  end

  test "'adjust products spec'", state do
    products = state[:products]
    [%GildedRose.Item{} | _] = GildedRose.items(products)
    
    assert :ok == GildedRose.adjust_product_types(products)
  end


  # - Standard Product Tests -
  test "STANDARD-> 'quality should never be negative'" do
    product = Item.new("+5 Dexterity Vest", 1, 0) #{name, sell_in, quality}
    {status, adjusted_product} = GildedRose.Products.adjust_standard_product(product)

    assert status == :ok
      && adjusted_product.quality == 0
      && adjusted_product.sell_in == 0
  end

  test "STANDARD-> 'negative sell_in should decrease by 2'" do
    product = Item.new("Elixir of the Mongoose", -1, 4) #{name, sell_in, quality}
    {status, adjusted_product} = GildedRose.Products.adjust_standard_product(product)

    assert status == :ok
      && adjusted_product.quality == 2
      && adjusted_product.sell_in == -2
  end


  # - Sulfuras Product Tests -
  test "SULFURAS-> 'should not decrease quality or sell_in'" do
    product = Item.new("Sulfuras, Hand of Ragnaros", 0, 80) #{name, sell_in, quality}
    {status, adjusted_product} = GildedRose.Products.adjust_sulfuras_product(product)

    assert status == :ok
      && adjusted_product.quality == 80
      && adjusted_product.sell_in == 0
  end


  # - Aged Brie Product Tests -
  test "AGED BRIE-> 'quality should increase'" do
    product = Item.new("Aged Brie", 2, 0) #{name, sell_in, quality}
    {status, adjusted_product} = GildedRose.Products.adjust_aged_brie_product(product)

    assert status == :ok
      && adjusted_product.quality == 1
      && adjusted_product.sell_in == 1
  end

  test "AGED BRIE-> 'quality should cap at 50'" do
    product = Item.new("Aged Brie", 2, 50) #{name, sell_in, quality}
    {status, adjusted_product} = GildedRose.Products.adjust_aged_brie_product(product)

    assert status == :ok
      && adjusted_product.quality == 50
      && adjusted_product.sell_in == 1
  end


  # - Backstage Product Tests -
  test "BACKSTAGE-> 'quality should increase by 1'" do
    product = Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20) #{name, sell_in, quality}
    {status, adjusted_product} = GildedRose.Products.adjust_backstage_product(product)

    assert status == :ok 
      && adjusted_product.quality == 21
      && adjusted_product.sell_in == 14
  end

  test "BACKSTAGE-> 'quality should increase by 2 when sell_in < 10'" do
    product = Item.new("Backstage passes to a TAFKAL80ETC concert", 9, 20) #{name, sell_in, quality}
    {status, adjusted_product} = GildedRose.Products.adjust_backstage_product(product)

    assert status == :ok 
      && adjusted_product.quality == 22
      && adjusted_product.sell_in == 8
  end

  test "BACKSTAGE-> 'quality should increase by 3 when sell_in < 5'" do
    product = Item.new("Backstage passes to a TAFKAL80ETC concert", 4, 20) #{name, sell_in, quality}
    {status, adjusted_product} = GildedRose.Products.adjust_backstage_product(product)

    assert status == :ok 
      && adjusted_product.quality == 23
      && adjusted_product.sell_in == 3
  end

  test "BACKSTAGE-> 'quality should cap at 50'" do
    product = Item.new("Backstage passes to a TAFKAL80ETC concert", 8, 50) #{name, sell_in, quality}
    {status, adjusted_product} = GildedRose.Products.adjust_backstage_product(product)

    assert status == :ok 
      && adjusted_product.quality == 50
      && adjusted_product.sell_in == 7
  end

  test "BACKSTAGE-> 'quality should drop to 0 when sell_in <= 0'" do
    product = Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 50) #{name, sell_in, quality}
    {status, adjusted_product} = GildedRose.Products.adjust_backstage_product(product)

    assert status == :ok 
      && adjusted_product.quality == 0
      && adjusted_product.sell_in == -1
  end


  # - Conjured Product Tests -
  test "CONJURED-> 'quality should decrease by 2'" do
    product = Item.new("Conjured Mana Cake", 10, 6) #{name, sell_in, quality}
    {status, adjusted_product} = GildedRose.Products.adjust_conjured_product(product)

    assert status == :ok 
      && adjusted_product.quality == 4
      && adjusted_product.sell_in == 9
  end


  test "CONJURED-> 'negative sell_in should decrease by 4'" do
    product = Item.new("Conjured Mana Cake", -1, 6) #{name, sell_in, quality}
    {status, adjusted_product} = GildedRose.Products.adjust_conjured_product(product)

    assert status == :ok
      && adjusted_product.quality == 2
      && adjusted_product.sell_in == -2
  end

  test "CONJURED-> 'quality should never be negative'" do
    product = Item.new("Conjured Mana Cake", -1, 1) #{name, sell_in, quality}
    {status, adjusted_product} = GildedRose.Products.adjust_conjured_product(product)

    assert status == :ok
      && adjusted_product.quality == 0
      && adjusted_product.sell_in == -2
  end
end
