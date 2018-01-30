class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each { |item| update_quality_of(item) }
  end

  private

  def update_quality_of(item)
    the_item =
      case item.name
        when 'Sulfuras, Hand of Ragnaros'
          Sulfuras.new(item)
        when 'Aged Brie'
          AgedBrie.new(item)
        when 'Backstage passes to a TAFKAL80ETC concert'
          BackstagePasses.new(item)
        when 'Conjured'
          ConjuredItem.new(item)
        else
          NormalItem.new(item)
    end

    the_item.update
  end
end

class ConjuredItem
  attr_reader :item
  
  def initialize(item)
    @item = item
  end

  def update
    item.sell_in -=1
    reduce_quality
    reduce_quality if expired?
  end

  def reduce_quality
    item.quality -=2 unless item.quality.zero?
  end

  def expired?
    item.sell_in < 0
  end
end

class NormalItem
  attr_reader :item
  
  def initialize(item)
    @item = item
  end

  def update
    item.sell_in -= 1
    reduce_quality
    reduce_quality if expired?
  end

  private

  def expired?
    item.sell_in < 0
  end

  def reduce_quality
    return if item.quality.zero?

    item.quality -= 1
  end
end

class Sulfuras
  def initialize(item)

  end
  
  def update
    # Do nothing
  end
end

class AgedBrie
  attr_reader :item
  
  def initialize(item)
    @item = item
  end

  def update
    item.sell_in -= 1
    increase_quality
    increase_quality if expired?
  end

  def expired?
    item.sell_in < 0
  end

  def increase_quality
    return if item.quality == 50

    item.quality += 1
  end
end

class BackstagePasses
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def update
    item.sell_in -= 1
    increase_quality
    increase_quality if item.sell_in < 11
    increase_quality if item.sell_in < 6
    item.quality = 0 if expired?
  end

  def expired?
    item.sell_in < 0
  end
  
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
