class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      next if item.name == "Sulfuras, Hand of Ragnaros"
      case item.name
        when 'Aged Brie'
          item.sell_in -= 1
          increase_quality_of(item)
          increase_quality_of(item) if expired?(item)
        when 'Backstage passes to a TAFKAL80ETC concert'
          item.sell_in -= 1
          increase_quality_of(item)
          increase_quality_of(item) if item.sell_in < 11
          increase_quality_of(item) if item.sell_in < 6
          item.quality = 0 if expired?(item)
        else
          item.sell_in -= 1
          reduce_quality_of(item)
          reduce_quality_of(item) if expired?(item)
      end
    end
  end

  private

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