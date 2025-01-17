class Location < ApplicationRecord
  validates :zipcode, format: { with: /\A\d{5}\z/, message: "Must be a valid US ZIP code." }, allow_blank: true
  validates :ip_address, format: { with: /\A(?:#{Resolv::IPv4::Regex}|#{Resolv::IPv6::Regex})\z/, message: "Must be a valid IPv4 or IPv6 address" }, allow_blank: true
  validate :zipcode_or_ip_address_present

  private

  def zipcode_or_ip_address_present
    if zipcode.blank? && ip_address.blank?
      errors.add(:base, "Either a ZIP code or an IP address must be provided.")
    end
  end
end
