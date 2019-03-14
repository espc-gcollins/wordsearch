defmodule WS do

  def random_letter() do
    # Enum.random(['-'])
    Enum.random(~w(a b c d e f g h i j k l m n o p q r s t u v x y z))
  end

  def random_direction() do
    Enum.random([
      %{ x: 1, y: 1 },
      %{ x: 1, y: 0 },
      %{ x: 0, y: 1 }
      ])
  end

  def draw_board(letters) do
    bounds = bounds(letters)
    for y <- bounds.y1..bounds.y2, x <- bounds.x1..bounds.x2 do
      Enum.find(letters, %{ x: x, y: y, l: random_letter() }, fn item ->
        item.x == x && item.y == y
      end)
    end
    |> Enum.each(fn item ->
        IO.write(to_string(item.l))
        if item.x == bounds.x2 do
          IO.write("\n")
        end
    end)
  end

  def bounds([%{x: x, y: y} | points]) do
    Enum.reduce(points, %{x1: x, x2: x, y1: y, y2: y}, fn point, box ->
        %{
          x1: min(point.x, box.x1),
          y1: min(point.y, box.y1),
          x2: max(point.x, box.x2),
          y2: max(point.y, box.y2)
        }
      end)
  end

  def place(word) do
    %{
      x: Enum.random(1..20),
      y: Enum.random(1..10),
      w: String.codepoints(word),
      d: random_direction()
    }
  end

  def letters(words) do
    words
    |> Enum.map(&place/1)
    |> Enum.flat_map(fn word_map ->
      word_map.w
      |> Enum.with_index
      |> Enum.map(fn ({item, i}) ->
        %{
          x: word_map.x + (word_map.d.x * i),
          y: word_map.y + (word_map.d.y * i),
          l: item
        }
      end)
    end)
  end

end

words = System.argv() #["apple", "pear"]

WS.draw_board(WS.letters(words))
