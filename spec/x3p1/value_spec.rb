require_relative '../../lib/x3p1/value'

RSpec.describe X3p1::Value do
  let(:graph) do
    {
      3 => 10,
      10 => 5,
      5 => 16,
      16 => 8,
      8 => 4,
      4 => 2,
      2 => 1,
      1 => 4
    }
  end

  context 'forward' do
    it 'has correct values' do
      for x, result in graph
        expect(described_class.next(x)).to eq(result)
      end
    end
  end

  context 'backward' do
    it 'has correct values' do
      for x, result in graph
        if x.odd?
          expect(described_class.prev1(result)).to eq(x)
        else
          expect(described_class.prev2(result)).to eq(x)
        end
      end
    end

    it 'has two results in some cases' do
      expect(described_class.prev1(4)).to eq(1)
      expect(described_class.prev2(4)).to eq(8)
    end

    it 'has one result in some cases' do
      expect(described_class.prev1(5)).to be_nil
      expect(described_class.prev2(5)).to eq(10)
    end
  end
end
