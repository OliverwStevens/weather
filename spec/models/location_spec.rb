require 'rails_helper'

RSpec.describe Location, type: :model do
  describe 'validations' do
    context 'when validating ZIP code format' do
      it 'accepts valid US ZIP codes' do
        location = Location.new(zipcode: '12345')
        expect(location).to be_valid
      end

      it 'rejects invalid ZIP code formats' do
        invalid_zipcodes = ['1234', '123456', 'abcde', '12-345']
        invalid_zipcodes.each do |zipcode|
          location = Location.new(zipcode: zipcode)
          expect(location).not_to be_valid
          expect(location.errors[:zipcode]).to include('Must be a valid US ZIP code.')
        end
      end

      it 'allows blank ZIP code when IP address is present' do
        location = Location.new(zipcode: '', ip_address: '192.168.1.1')
        expect(location).to be_valid
      end
    end

    context 'when validating IP address format' do
      it 'accepts valid IPv4 addresses' do
        valid_ipv4s = ['192.168.1.1', '10.0.0.0', '172.16.254.1']
        valid_ipv4s.each do |ip|
          location = Location.new(ip_address: ip)
          expect(location).to be_valid
        end
      end

      it 'accepts valid IPv6 addresses' do
        valid_ipv6s = [
          '2001:0db8:85a3:0000:0000:8a2e:0370:7334',
          'fe80::1ff:fe23:4567:890a'
        ]
        valid_ipv6s.each do |ip|
          location = Location.new(ip_address: ip)
          expect(location).to be_valid
        end
      end

      it 'rejects invalid IP addresses' do
        invalid_ips = ['256.1.2.3', '1.2.3.256', 'abc.def.ghi.jkl', '192.168.1']
        invalid_ips.each do |ip|
          location = Location.new(ip_address: ip)
          expect(location).not_to be_valid
          expect(location.errors[:ip_address]).to include('Must be a valid IPv4 or IPv6 address')
        end
      end

      it 'allows blank IP address when ZIP code is present' do
        location = Location.new(ip_address: '', zipcode: '12345')
        expect(location).to be_valid
      end
    end

    context 'when validating presence of either ZIP code or IP address' do
      it 'is valid with only ZIP code' do
        location = Location.new(zipcode: '12345')
        expect(location).to be_valid
      end

      it 'is valid with only IP address' do
        location = Location.new(ip_address: '192.168.1.1')
        expect(location).to be_valid
      end

      it 'is valid with both ZIP code and IP address' do
        location = Location.new(zipcode: '12345', ip_address: '192.168.1.1')
        expect(location).to be_valid
      end

      it 'is invalid with neither ZIP code nor IP address' do
        location = Location.new
        expect(location).not_to be_valid
        expect(location.errors[:base]).to include('Either a ZIP code or an IP address must be provided.')
      end
    end
  end
end