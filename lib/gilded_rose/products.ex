defmodule GildedRose.Products do

  def adjust_standard_product(product) do
    #IO.puts("\n#{product.name} -> adjust_standard_product()")

    adjusted_product =
      cond do
        product.quality <= 0 ->
          %{product | quality: 0, sell_in: product.sell_in - 1}

        product.quality >= 50 ->
          %{product | quality: 50, sell_in: product.sell_in - 1}

        true ->
          cond do
            product.sell_in >= 0 ->
              %{product | quality: product.quality - 1, sell_in: product.sell_in - 1}

            true ->
              if product.quality > 1 do
                %{product | quality: product.quality - 2, sell_in: product.sell_in - 1}
              else
                %{product | quality: product.quality - 1, sell_in: product.sell_in - 1}
              end
          end
      end

    #IO.puts("quality:#{adjusted_product.quality} | sell_in:#{adjusted_product.sell_in}")
    {:ok, adjusted_product}
  end


  def adjust_sulfuras_product(product) do
    #IO.puts("\n#{product.name} -> adjust_sulfuras_product()")

    adjusted_product = product

    #IO.puts("quality:#{adjusted_product.quality} | sell_in:#{adjusted_product.sell_in}")
    {:ok, adjusted_product}
  end


  def adjust_aged_brie_product(product) do
    #IO.puts("\n#{product.name} -> adjust_aged_brie_product()")

    adjusted_product =
      cond do
        product.quality < 50 ->
          %{product | quality: product.quality + 1, sell_in: product.sell_in - 1}

        true ->
          %{product | sell_in: product.sell_in - 1}
      end

    #IO.puts("quality:#{adjusted_product.quality} | sell_in:#{adjusted_product.sell_in}")
    {:ok, adjusted_product}
  end


  def adjust_backstage_product(product) do
    #IO.puts("\n#{product.name} -> adjust_backstage_product()")

    adjusted_product =
      cond do
        product.sell_in > 10 ->
          if product.quality < 50 do
            %{product | quality: product.quality + 1, sell_in: product.sell_in - 1}
          else
            %{product | quality: 50, sell_in: product.sell_in - 1}
          end

        product.sell_in > 5 ->
          if product.quality <= 48 do
            %{product | quality: product.quality + 2, sell_in: product.sell_in - 1}
          else
            %{product | quality: 50, sell_in: product.sell_in - 1}
          end

        product.sell_in > 0 ->
          if product.quality <= 47 do
            %{product | quality: product.quality + 3, sell_in: product.sell_in - 1}
          else
            %{product | quality: 50, sell_in: product.sell_in - 1}
          end

        true ->
          %{product | quality: 0, sell_in: product.sell_in - 1}
      end

    #IO.puts("quality:#{adjusted_product.quality} | sell_in:#{adjusted_product.sell_in}")
    {:ok, adjusted_product}
  end


  def adjust_conjured_product(product) do
    #IO.puts("\n#{product.name} -> adjust_conjured_product()")

    adjusted_product =
      cond do
        product.quality <= 0 ->
          %{product | quality: 0, sell_in: product.sell_in - 1}

        product.quality >= 50 ->
          %{product | quality: 50, sell_in: product.sell_in - 1}

        true ->
          cond do 
            product.sell_in >= 0 ->
              if product.quality >= 2 do
                %{product | quality: product.quality - 2, sell_in: product.sell_in - 1}
              else
                %{product | quality: 0, sell_in: product.sell_in - 1}
              end

            true ->
              if product.quality >= 4 do
                %{product | quality: product.quality - 4, sell_in: product.sell_in - 1}
              else
                %{product | quality: 0, sell_in: product.sell_in - 1}
              end
          end
      end

    #IO.puts("quality:#{adjusted_product.quality} | sell_in:#{adjusted_product.sell_in}")
    {:ok, adjusted_product}
  end
end