require 'spec_helper'
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
      let(:aged_brie) { an_aged_brie(sell_in: -1) }
      
      it 'increases in quality by 2' do
        expect { update_quality }.to change { aged_brie.quality }.by 2
      end
    end
  end

  describe 'Backstage Passes' do
    let(:gilded_rose) { GildedRose.new([backstage_pass]) }
    subject(:update_quality) { gilded_rose.update_quality }
    let(:backstage_pass) { a_backstage_pass }

    it 'reduces the number of days left to sell by 1' do
      expect { update_quality }.to change { backstage_pass.sell_in }.by -1
    end
    
    context 'when it is not passed its sell by date' do
      let(:backstage_pass) { a_backstage_pass(sell_in: 30) }
      
      it 'increases in quality by 1' do
        expect { update_quality }.to change { backstage_pass.quality }.by 1
      end

      context 'and the quality is already 50' do
        let(:backstage_pass) { a_backstage_pass(quality: 50) }
        
        it 'does not change in quality' do
          expect { update_quality }.not_to change { backstage_pass.quality }
        end
      end
    end

    context 'when there are 11 days until the concert' do
      let(:backstage_pass) { a_backstage_pass(sell_in: 11) }
      
      it 'increases in quality by 1' do
        expect { update_quality }.to change { backstage_pass.quality }.by 1
      end

      context 'and the quality is already 50' do
        let(:backstage_pass) { a_backstage_pass(sell_in: 11, quality: 50) }
        
        it 'does not change in quality' do
          expect { update_quality }.not_to change { backstage_pass.quality }
        end
      end
    end

    context 'when there are 10 days until the concert' do
      let(:backstage_pass) { a_backstage_pass(sell_in: 10) }
      
      it 'increases in quality by 2' do
        expect { update_quality }.to change { backstage_pass.quality }.by 2
      end

      context 'and it already has a quality of 50' do
        let(:backstage_pass) { a_backstage_pass(sell_in: 10, quality: 50) }
        
        it 'does not change in quality' do
          expect { update_quality }.not_to change { backstage_pass.quality }
        end
      end
    end
  end

  private
  
  def an_aged_brie(sell_in: 25, quality: 11)
    Item.new('Aged Brie', sell_in, quality)
  end

  def a_backstage_pass(sell_in: 25, quality: 25)
    Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in, quality)
  end
end
