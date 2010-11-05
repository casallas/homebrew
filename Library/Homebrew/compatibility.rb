
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

def gcc_42_build
  plat = SystemCommand.platform
  case plat
  when :linux
    5664
  when :mac
    MacOS.gcc_42_build_version
  else
    nil
  end
end

alias :gcc_build :gcc_42_build

def gcc_40_build
  plat = SystemCommand.platform
  case plat
  when :linux
    5664
  when :mac
    MacOS.gcc_40_build_version
  else
    nil
  end
end

def llvm_build
  if SystemCommand.platform == :mac
    MacOS.llvm_build_version
  end
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

class Formula
  # in compatability because the naming is somewhat confusing
  def self.resolve_alias name
    opoo 'Formula.resolve_alias is deprecated and will eventually be removed'

    # Don't resolve paths or URLs
    return name if name.include?("/")

    aka = HOMEBREW_REPOSITORY/:Library/:Aliases/name
    if aka.file?
      aka.realpath.basename('.rb').to_s
    else
      name
    end
  end
end
