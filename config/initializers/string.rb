class String
  def to_iso_8601
    Chronic.parse(self).utc.iso8601
  end
end