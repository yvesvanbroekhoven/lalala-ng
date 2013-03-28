module Lalala
  VERSION = "4.0.0"
  BUILD   = "{{BUILD_NUMBER}}"

  if BUILD != "{{BUILD_NUMBER}}"
    BUILD_VERSION = "#{VERSION}.dev.#{BUILD}"
  else
    BUILD_VERSION = VERSION
  end
end
