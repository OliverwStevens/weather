# spec/services/weather_service_spec.rb
require 'rails_helper'

RSpec.describe WeatherService, type: :service do
  let(:location) { create(:location, ip_address: '8.8.8.8') }
  subject { described_class.new(location) }

  describe '#fetch_weather_data' do
    it 'returns highs and lows when data is available' do
      allow(subject).to receive(:get_lat_lng_from_ip).and_return([37.42301, -122.083352])
      allow(subject).to receive(:forecast).and_return(
        [
          [62.3, 65.2, 66.6, 65.3, 58.0, 55.3, 58.5], # Highs
          [34.4, 36.6, 43.5, 50.5, 43.7, 41.8, 43.3]  # Lows
        ]
      )
    
      highs, lows = subject.fetch_weather_data
    
      expect(highs).to eq([62.3, 65.2, 66.6, 65.3, 58.0, 55.3, 58.5])
      expect(lows).to eq([34.4, 36.6, 43.5, 50.5, 43.7, 41.8, 43.3])
    end
  
  end
end
