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
        
        it 'does not increase in quality any further' do
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

    private

    def an_aged_brie(sell_in: 25, quality: 11)
      Item.new('Aged Brie', sell_in, quality)
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
        
        it 'does not increase in quality any further' do
          expect { update_quality }.not_to change { backstage_pass.quality }
        end
      end
    end

    context 'when there are more 10 days until the concert' do
      let(:backstage_pass) { a_backstage_pass(sell_in: 21) }
      
      it 'increases in quality by 1' do
        expect { update_quality }.to change { backstage_pass.quality }.by 1
      end

      context 'and the quality is already 50' do
        let(:backstage_pass) { a_backstage_pass(sell_in: 11, quality: 50) }
        
        it 'does not increase in quality any further' do
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
        
        it 'does not increase in quality any further' do
          expect { update_quality }.not_to change { backstage_pass.quality }
        end
      end
    end

    context 'when there are less than 6 days until the concert' do
      let(:backstage_pass) { a_backstage_pass(sell_in: 5) }

      it 'increases in quality by 3' do
        expect { update_quality }.to change { backstage_pass.quality }.by 3
      end

      context 'and the quality is already 50' do
        let(:backstage_pass) { a_backstage_pass(sell_in: 5, quality: 50) }
        
        it 'does not increase in quality any further' do
          expect { update_quality }.not_to change { backstage_pass.quality }
        end
      end
    end

    context 'when it is the day of the concert' do
      let(:backstage_pass) { a_backstage_pass(sell_in: 0) }

      it 'is worth nothing' do
        expect { update_quality }.to change { backstage_pass.quality }.to 0
      end
    end

    context 'when the concert has already finished' do
      let(:backstage_pass) { a_backstage_pass(sell_in: -1) }
      
      it 'is worth nothing' do
        expect { update_quality }.to change { backstage_pass.quality }.to 0
      end
    end

    private

    def a_backstage_pass(sell_in: 25, quality: 25)
      Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in, quality)
    end
  end

  describe 'Sulfuras, Hand of Ragnaros' do
    let(:sulfuras) { Item.new('Sulfuras, Hand of Ragnaros', 11, 80) }
    let(:gilded_rose) { GildedRose.new([sulfuras]) }
    subject(:update_quality) { gilded_rose.update_quality }

    it 'is never sold' do
      expect { update_quality }.not_to change { sulfuras.sell_in }.from 11
    end

    it 'never changes from a quality of 80' do
      expect { update_quality }.not_to change { sulfuras.quality }.from 80
    end
  end

  describe 'Normal item' do
    let(:normal_item) { a_normal_item }
    let(:gilded_rose) { GildedRose.new([normal_item]) }
    subject(:update_quality) { gilded_rose.update_quality }

    it 'reduces the number of days left to sell by 1' do
      expect { update_quality }.to change { normal_item.sell_in }.by -1
    end
    
    context 'when it has not passed its sell-by date' do
      let(:normal_item) { a_normal_item(sell_in: 25) }

      it 'degrades in quality by 1' do
        expect { update_quality }.to change { normal_item.quality }.by -1
      end

      context 'and the quality is already 0' do
        let(:normal_item) { a_normal_item(quality: 0) }

        it 'does not decrease in quality any further' do
          expect { update_quality }.not_to change { normal_item.quality }
        end
      end
    end

    context 'when it hits its sell-by date' do
      let(:normal_item) { a_normal_item(sell_in: 0) }
      
      it 'degrades in quality twice as fast' do
        expect { update_quality }.to change { normal_item.quality }.by -2
      end

      context 'and the quality is already 0' do
        let(:normal_item) { a_normal_item(sell_in: 0, quality: 0) }

        it 'does not decrease in quality any further' do
          expect { update_quality }.not_to change { normal_item.quality }
        end
      end
    end

    context 'when it is well passed its sell-by date' do
      let(:normal_item) { a_normal_item(sell_in: -3) }
      
      it 'degrades in quality twice as fast' do
        expect { update_quality }.to change { normal_item.quality }.by -2
      end

      context 'and the quality is already 0' do
        let(:normal_item) { a_normal_item(sell_in: -3, quality: 0) }

        it 'does not decrease in quality any further' do
          expect { update_quality }.not_to change { normal_item.quality }
        end
      end
    end

    private

    def a_normal_item(sell_in: 30, quality: 25)
      Item.new('Normal Item', sell_in, quality)
    end
  end

  describe 'Conjured items' do
    let(:gilded_rose) { GildedRose.new([conjured_item]) }
    subject(:update_quality) { gilded_rose.update_quality }

    context 'when it is not passed its sell-by date' do
      let(:conjured_item) { a_conjured_item(sell_in: 30) }

      it 'reduces the number of days left sell by 1' do
        expect { update_quality }.to change { conjured_item.sell_in }.by -1
      end
      
      it 'decays twice as fast as normal items' do
        expect { update_quality }.to change { conjured_item.quality }.by -2
      end

      context 'given it already has a quality of 0' do
        let(:conjured_item) { a_conjured_item(quality: 0) }
        
        it 'does not decrease in quality any further' do
          expect { update_quality }.not_to change { conjured_item.quality }
        end
      end
    end

    context 'when it hits its sell by date' do
      let(:conjured_item) { a_conjured_item(sell_in: 0) }
      
      it 'decays twice as fast as the normal item' do
        expect { update_quality }.to change { conjured_item.quality }.by -4
      end

      context 'given it already has a quality of 0' do
        let(:conjured_item) { a_conjured_item(sell_in: 0, quality: 0) }
        
        it 'does not decrease in quality any further' do
          expect { update_quality }.not_to change { conjured_item.quality }
        end
      end
    end

    context 'when it is passed its sell by date' do
      let(:conjured_item) { a_conjured_item(sell_in: -1) }

      it 'decays twice as fast as the normal item' do
        expect { update_quality }.to change { conjured_item.quality }.by -4
      end

      context 'given it already has a quality of 0' do
        let(:conjured_item) { a_conjured_item(sell_in: -1, quality: 0) }

        it 'does not decrease in quality any further' do
          expect { update_quality }.not_to change { conjured_item.quality }
        end
      end
    end

    private

    def a_conjured_item(sell_in: 30, quality: 25)
      Item.new('Conjured', sell_in, quality)
    end
  end
end
