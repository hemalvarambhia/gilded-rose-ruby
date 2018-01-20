class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      case item.name
        when 'Sulfuras, Hand of Ragnaros'
          Sulfuras.new(item).update
        when 'Aged Brie'
          AgedBrie.new(item).update
        when 'Backstage passes to a TAFKAL80ETC concert'
          BackstagePasses.new(item).update
        else
          NormalItem.new(item).update
      end
    end
  end
end

class NormalItem
  attr_reader :item
  
  def initialize(item)
    @item = item
  end

  def update
    item.sell_in -= 1
    reduce_quality_of(item)
    reduce_quality_of(item) if expired?(item)
  end

  private

  def expired?(item)
    item.sell_in < 0
  end

  def reduce_quality_of(item)
    return if item.quality == 0

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
