class JavaVersion

  class VersionFormatError < StandardError; end

  attr_accessor :family_number, :update_number

  REG_VERSION = /^JDK(\d+)u(\d+)$/

  LIMITED_UPDATE_STEP = 20

  def self.valid?(version_str)
    return version_str =~ REG_VERSION
  end

  def self.parse(version_str)
    raise VersionFormatError unless valid?(version_str)

    version_str =~ REG_VERSION

    v = self.new
    v.family_number = $1.to_i
    v.update_number = $2.to_i

    return v
  end

  def lt(target)
    if @family_number != target.family_number
      return @family_number < target.family_number
    end

    return @update_number < target.update_number
  end

  # comparable '<=>' を使う！
  def gt(target)
    if @family_number != target.family_number
      return @family_number > target.family_number
    end

    return @update_number > target.update_number
  end

  def next_limited_update
    @update_number = (@update_number / LIMITED_UPDATE_STEP + 1 ) * LIMITED_UPDATE_STEP
    self
  end
end
