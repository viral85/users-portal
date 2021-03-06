require 'csv'
class User < ApplicationRecord
  validates :name, presence: true
  validate :validate_strong_password

  def self.import(file)
    return if file.content_type != 'text/csv'

    result = []
    CSV.foreach(file, headers: true) do |row|
      user = User.create(row.to_hash)
      if user.errors.present?
        result << user.errors[:password].first
      else
        result << "#{user.name} was successfully saved"
      end
    end
    result
  end

  private

  def validate_strong_password
    if password.present?
      validate_password_length 
      validate_password_presence_of_character_type if errors[:password].empty?
      validate_password_repeating_char if errors[:password].empty?
    else
      errors.add(:password, :blank)
    end
  end

  def validate_password_length
    password_size = password.size
    return if password_size.between?(10, 16)

    errors.add(:password, "Change #{10 - password_size} characters of #{name}'s password") if password_size < 10
    errors.add(:password, "Change #{password_size - 16} characters of #{name}'s password") if password_size > 16
  end

  def validate_password_presence_of_character_type
    required_changes = 0
    required_changes += 1 unless password.match(/[A-Z]/).present?
    required_changes += 1 unless password.match(/[a-z]/).present?
    required_changes += 1 unless password.match(/\d/).present?
    return unless required_changes.positive?

    errors.add(:password, "Change #{required_changes} characters of #{name}'s password")
  end

  def validate_password_repeating_char
    required_changes = password.scan(/(.)(\1+)/)
                               .map { |match_str| match_str[0] + match_str[1] }
                               .reject { |match_str| match_str.size < 3 }
                               .count

    return unless required_changes.positive?

    errors.add(:password, "Change #{required_changes} characters of #{name}'s password")
  end
end
