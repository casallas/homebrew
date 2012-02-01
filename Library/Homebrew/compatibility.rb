
def dump_config
  require 'cmd/--config'
  Homebrew.__config
end

def dump_build_env env
  require 'cmd/--env'
  Homebrew.dump_build_env env
end

def macports_or_fink_installed?
  if SystemCommand.platform == :linux
    return false
  else
    MacOS.macports_or_fink_installed?
  end
end
