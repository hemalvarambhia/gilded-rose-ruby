require 'gilded_rose'

describe GildedRose do
  describe 'Aged Brie' do
    let(:aged_brie) { an_aged_brie }
    let(:gilded_rose) { GildedRose.new([aged_brie]) }
    subject(:update_quality) { gilded_rose.update_quality }

    it 'reduces the number of days left sell by 1' do
      expect { update_quality }.to change { aged_brie.sell_in }.by -1
    end
    
    context 'when it is not passed its sell-by date' do
      let(:aged_brie) { an_aged_brie(sell_in: 25) }

      it 'increases in quality by 1' do
        expect { update_quality }.to change { aged_brie.quality }.by 1
      end

      context 'and the quality is already 50' do
        let(:aged_brie) { an_aged_brie(quality: 50) }
        
        it 'does not change in quality' do
          expect { update_quality }.not_to change { aged_brie.quality }
        end
      end
    end

    context 'when it hits its sell-by date' do
      let(:aged_brie) { an_aged_brie(sell_in: 0) }
      
      it 'increases in quality by 2' do
        expect { update_quality }.to change { aged_brie.quality }.by 2
      end
    end

    context 'when it has passed its sell-by date' do
      it 'increases in quality by 2'
    end
  end

  private
  
  def an_aged_brie(sell_in: 25, quality: 11)
    Item.new('Aged Brie', sell_in, quality)
  end
end
