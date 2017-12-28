require_relative File.join('..', 'lib', 'gilded_rose')

describe GildedRose do
  describe 'Aged Brie' do
    context 'when it is not passed its sell-by date' do
      it 'increases in quality by 1'

      context 'and the quality is already 50' do
        it 'does not change in quality'
      end
    end

    context 'when it hits its sell-by date' do
      it 'increases in quality by 2'
    end

    context 'when it has passed its sell-by date' do
      it 'increases in quality by 2'
    end
  end

end
