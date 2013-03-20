module Lalala::Vendor

  def self.enable(name, dirname=nil)
    dirname ||= name

    # Find development version
    path = File.expand_path("../../../../#{dirname}/lib", __FILE__)

    # Find vandored version
    unless File.directory?(path)
      path = File.expand_path("../../../vendor/deps/#{dirname}/lib", __FILE__)
    end

    unless File.directory?(path)
      raise "Unable to find vendored dependency: #{name}"
    end

    $:.unshift(path)
  end

end
