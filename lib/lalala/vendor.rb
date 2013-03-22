module Lalala::Vendor

  def self.enable(name, dirname=nil)
    dirname ||= name

    # Find vendored version
    path = File.expand_path("../../../vendor/deps/#{dirname}/lib", __FILE__)

    # Find development version
    if ENV['LALALA_DEV']
      path = File.expand_path("../../../../#{dirname}/lib", __FILE__)
    end

    unless File.directory?(path)
      raise "Unable to find vendored dependency: #{name}"
    end

    $:.unshift(path)
  end

end
