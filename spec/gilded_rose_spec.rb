require 'gilded_rose'

describe GildedRose do
  describe 'Aged Brie' do
    context 'when it is not passed its sell-by date' do
      it 'increases in quality by 1' do
        aged_brie = aged_brie(sell_in: 25)
        gilded_rose = GildedRose.new([aged_brie])
        
        expect { gilded_rose.update_quality }.to(
          change { aged_brie.quality }.by 1
        )
      end

      context 'and the quality is already 50' do
        it 'does not change in quality' do
          aged_brie = aged_brie(quality: 50)
          gilded_rose = GildedRose.new([aged_brie])
          
          expect { gilded_rose.update_quality }.not_to(
            change { aged_brie.quality }
          )
        end
      end
    end

    context 'when it hits its sell-by date' do
      it 'increases in quality by 2'
    end

    context 'when it has passed its sell-by date' do
      it 'increases in quality by 2'
    end
  end

  private
  
  def aged_brie(sell_in: 25, quality: 11)
    Item.new('Aged Brie', sell_in, quality)
  end
end
