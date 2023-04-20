class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ ::URL_REGEX
      record.errors.add attribute, (options[:message] || 'must be a URL for GIF, JPG or PNG image.')
    end
  end
end