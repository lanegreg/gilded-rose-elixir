defmodule GildedRose do
  use Agent
  alias GildedRose.Item
  alias GildedRose.Products

  def new() do
    {:ok, agent} =
      Agent.start_link(fn ->
        [ # {name, sell_in, quality}
          Item.new("+5 Dexterity Vest", 10, 20),
          Item.new("Aged Brie", 2, 0),
          Item.new("Elixir of the Mongoose", 5, 7),
          Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
          Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
          Item.new("Conjured Mana Cake", 3, 6),
          Item.new("Phoenix of the Quarantine", 2, 10),
        ]
      end)

    agent
  end

  def items(agent), do: Agent.get(agent, & &1)


  @doc "Adjusts each product in 'products' list"
  def adjust_product_types(products) do
    for i <- 0..(Agent.get(products, &length/1) - 1) do
      product = Agent.get(products, &Enum.at(&1, i))

      product =
        cond do
          String.starts_with?(product.name, "Backstage") ->
            Products.adjust_backstage_product(product)

          String.starts_with?(product.name, "Aged Brie") ->
            Products.adjust_aged_brie_product(product)

          String.starts_with?(product.name, "Sulfuras") ->
            Products.adjust_sulfuras_product(product)

          String.starts_with?(product.name, "Conjured") ->
            Products.adjust_conjured_product(product)

          true ->
            Products.adjust_standard_product(product)
        end

      Agent.update(products, &List.replace_at(&1, i, product))
    end

    :ok
  end

  @deprecated "Old func"
  def update_quality(agent) do

    for i <- 0..(Agent.get(agent, &length/1) - 1) do
      item = Agent.get(agent, &Enum.at(&1, i))

      item =
        cond do
          item.name != "Aged Brie" && item.name != "Backstage passes to a TAFKAL80ETC concert" ->
            if item.quality > 0 do
              if item.name != "Sulfuras, Hand of Ragnaros" do
                %{item | quality: item.quality - 1}
              else
                item
              end
            else
              item
            end

          true ->
            cond do
              item.quality < 50 ->
                item = %{item | quality: item.quality + 1}

                cond do
                  item.name == "Backstage passes to a TAFKAL80ETC concert" ->
                    item =
                      cond do
                        item.sell_in < 11 ->
                          cond do
                            item.quality < 50 ->
                              %{item | quality: item.quality + 1}

                            true ->
                              item
                          end

                        true ->
                          item
                      end

                    cond do
                      item.sell_in < 6 ->
                        cond do
                          item.quality < 50 ->
                            %{item | quality: item.quality + 1}

                          true ->
                            item
                        end

                      true ->
                        item
                    end

                  true ->
                    item
                end

              true ->
                item
            end
        end

      item =
        cond do
          item.name != "Sulfuras, Hand of Ragnaros" ->
            %{item | sell_in: item.sell_in - 1}

          true ->
            item
        end

      item =
        cond do
          item.sell_in < 0 ->
            cond do
              item.name != "Aged Brie" ->
                cond do
                  item.name != "Backstage passes to a TAFKAL80ETC concert" ->
                    cond do
                      item.quality > 0 ->
                        cond do
                          item.name != "Sulfuras, Hand of Ragnaros" ->
                            %{item | quality: item.quality - 1}

                          true ->
                            item
                        end

                      true ->
                        item
                    end

                  true ->
                    %{item | quality: item.quality - item.quality}
                end

              true ->
                cond do
                  item.quality < 50 ->
                    %{item | quality: item.quality + 1}

                  true ->
                    item
                end
            end

          true ->
            item
        end

      Agent.update(agent, &List.replace_at(&1, i, item))
    end

    :ok
  end
end
