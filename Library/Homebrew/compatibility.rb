
# maybe never used by anyone, but alas it must continue to exist
def versions_of(keg_name)
  `/bin/ls #{HOMEBREW_CELLAR}/#{keg_name}`.collect { |version| version.strip }.reverse
end

def dump_config
  require 'cmd/--config'
  Homebrew.__config
end

def dump_build_env env
  require 'cmd/--env'
  Homebrew.dump_build_env env
end

def x11_installed?
  if SystemCommand.platform == :linux
    File.exist?(SystemCommand.which 'X')
  else
    MacOS.x11_installed?
  end
end

def macports_or_fink_installed?
  if SystemCommand.platform == :linux
    return false
  else
    MacOS.macports_or_fink_installed?
  end
end

def outdated_brews
  require 'cmd/outdated'
  Homebrew.outdated_brews
end

def search_brews text
  require 'cmd/search'
  Homebrew.search_brews text
end
