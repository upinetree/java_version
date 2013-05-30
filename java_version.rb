class JavaVersion

  include Comparable

  class VersionFormatError < StandardError; end

  attr_accessor :family_number, :update_number

  REG_VERSION = /^JDK(\d+)u(\d+)$/

  LIMITED_UPDATE_STEP = 20

  def self.valid?(version_str)
    begin
      parse(version_str)
    rescue
      return false
    else
      return true
    end
  end

  def self.parse(version_str)
    versions = version_str.scan(REG_VERSION).first
    raise VersionFormatError if versions.nil?

    v = self.new
    v.family_number = versions[0].to_i
    v.update_number = versions[1].to_i

    return v
  end

  def <=>(target)
    if @family_number != target.family_number
      return @family_number <=> target.family_number
    end

    return @update_number <=> target.update_number
  end

  def lt(target); self < target; end
  def gt(target); self > target; end

  def next_limited_update
    @update_number = (@update_number / LIMITED_UPDATE_STEP + 1 ) * LIMITED_UPDATE_STEP
    self
  end
end
