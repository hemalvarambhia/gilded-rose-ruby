class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each { |item| the_item(item).update_quality }
  end

  private

  def the_item(item)
    items = {
      'Sulfuras, Hand of Ragnaros' => Sulfuras,
      'Aged Brie' => AgedBrie,
      'Backstage passes to a TAFKAL80ETC concert' => BackstagePasses,
      'Conjured' => ConjuredItem
    }
    items.default = NormalItem

    items[item.name].new(item)
  end
end

module GildedRoseItem
  def expired?
    item.sell_in < 0
  end
end

class ConjuredItem
  include GildedRoseItem
  attr_reader :item
  
  def initialize(item)
    @item = item
  end

  def update_quality
    item.sell_in -=1
    reduce_quality
    reduce_quality if expired?
  end

  private

  def reduce_quality
    item.quality -=2 unless item.quality.zero?
  end
end

class NormalItem
  include GildedRoseItem
  attr_reader :item
  
  def initialize(item)
    @item = item
  end

  def update_quality
    item.sell_in -= 1
    reduce_quality
    reduce_quality if expired?
  end

  private

  def reduce_quality
    item.quality -= 1 unless item.quality.zero?
  end
end

class Sulfuras
  def initialize(item)

  end

  def update_quality
    # Do nothing
  end
end

class AgedBrie
  include GildedRoseItem
  attr_reader :item
  
  def initialize(item)
    @item = item
  end

  def update_quality
    item.sell_in -= 1
    increase_quality
    increase_quality if expired?
  end

  private

  def increase_quality
    return if item.quality == 50

    item.quality += 1
  end
end

class BackstagePasses
  include GildedRoseItem
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def update_quality
    item.sell_in -= 1
    increase_quality
    increase_quality if item.sell_in < 11
    increase_quality if item.sell_in < 6
    item.quality = 0 if expired?
  end

  private
  
  def increase_quality
    return if item.quality == 50

    item.quality += 1
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
