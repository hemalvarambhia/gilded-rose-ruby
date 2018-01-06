class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      case item.name
        when 'Sulfuras, Hand of Ragnaros'
          update_sulfuras(item)
        when 'Aged Brie'
          update_aged_brie(item)
        when 'Backstage passes to a TAFKAL80ETC concert'
          updated_backstage_pass(item)
        else
          update_normal_item(item)
      end
    end
  end

  private

  def update_sulfuras(item)
    # Do nothing
  end

  def update_normal_item(item)
    item.sell_in -= 1
    reduce_quality_of(item)
    reduce_quality_of(item) if expired?(item)
  end

  def updated_backstage_pass(item)
    item.sell_in -= 1
    increase_quality_of(item)
    increase_quality_of(item) if item.sell_in < 11
    increase_quality_of(item) if item.sell_in < 6
    item.quality = 0 if expired?(item)
  end

  def update_aged_brie(item)
    item.sell_in -= 1
    increase_quality_of(item)
    increase_quality_of(item) if expired?(item)
  end

  def expired?(item)
    item.sell_in < 0
  end

  def reduce_quality_of(item)
    return if item.quality == 0

    item.quality -= 1
  end

  def increase_quality_of(item)
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