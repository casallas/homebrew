def check_for_blacklisted_formula names
  return if ARGV.force?

  names.each do |name|
    case name
    when 'tex', 'tex-live', 'texlive' then abort <<-EOS.undent
      Installing TeX from source is weird and gross, requires a lot of patches,
      and only builds 32-bit (and thus can't use Homebrew deps on Snow Leopard.)

      We recommend using a MacTeX distribution:
        http://www.tug.org/mactex/
    EOS

    when 'mercurial', 'hg' then abort <<-EOS.undent
      Mercurial can be install thusly:
        brew install pip && pip install mercurial
    EOS

    when 'npm' then abort <<-EOS.undent
      npm can be installed thusly by following the instructions at
        http://npmjs.org/

      To do it in one line, use this command:
        curl http://npmjs.org/install.sh | sh
    EOS


    when 'setuptools' then abort <<-EOS.undent
      When working with a Homebrew-built Python, distribute is preferred
      over setuptools, and can be used as the prerequisite for pip.

      Install distribute using:
        brew install distribute
    EOS
    end
  end
end


def editmake url
  path = Pathname.new url

  /(.*?)[-_.]?#{path.version}/.match path.basename

  unless $1.to_s.empty?
    name = $1
  else
    print "Formula name [#{path.stem}]: "
    gots = $stdin.gets.chomp
    if gots.empty?
      name = path.stem
    else
      name = gots
    end
  end

  "#{FORMULA_REPOSITORY}#{name.downcase}.rb"
end

def issues_for_formula name
  # bit basic as depends on the issue at github having the exact name of the
  # formula in it. Which for stuff like objective-caml is unlikely. So we
  # really should search for aliases too.

  name = f.name if Formula === name

  require 'open-uri'
  require 'yaml'

  issues = []

  open("http://github.com/api/v2/yaml/issues/search/#{HOMEBREW_GIT_USER}/homebrew/open/"+name) do |f|
    YAML::load(f.read)['issues'].each do |issue|
      issues << "http://github.com/#{HOMEBREW_GIT_USER}/homebrew/issues/#issue/%s" % issue['number']
    end
  end

  issues
rescue
  []
end

def clean f
  require 'cleaner'
  Cleaner.new f

  until paths.empty? do
    d = paths.pop
    if d.children.empty? and not f.skip_clean? d
      puts "rmdir: #{d} (empty)" if ARGV.verbose?
      d.rmdir
    end
  end
end

def brew_install
  require 'formula_installer'
  require 'hardware'

  ############################################################ sanity checks
  case Hardware.cpu_type when :ppc, :dunno
    abort "Sorry, Homebrew does not support your computer's CPU architecture.\n"+
          "For PPC support, see: http://github.com/sceaga/homebrew/tree/powerpc"
  end

  raise "Cannot write to #{HOMEBREW_CELLAR}" if HOMEBREW_CELLAR.exist? and not HOMEBREW_CELLAR.writable?
  raise "Cannot write to #{HOMEBREW_PREFIX}" unless HOMEBREW_PREFIX.writable?

  ################################################################# warnings
  begin
    if SystemCommand.platform == :mac
      if MACOS_VERSION >= 10.6
        opoo "You should upgrade to Xcode 3.2.3" if llvm_build < RECOMMENDED_LLVM
      else
        opoo "You should upgrade to Xcode 3.1.4" if (gcc_40_build < RECOMMENDED_GCC_40) or (gcc_42_build < RECOMMENDED_GCC_42)
      end
    end
  rescue
    # the reason we don't abort is some formula don't require Xcode
    # TODO allow formula to declare themselves as "not needing Xcode"
    opoo "Xcode is not installed! Builds may fail!"
  end

  if macports_or_fink_installed?
    opoo "It appears you have MacPorts or Fink installed."
    puts "Software installed with MacPorts and Fink are known to cause problems."
    puts "If you experience issues try uninstalling these tools."
  end

  ################################################################# install!
  installer = FormulaInstaller.new
  installer.install_deps = !ARGV.include?('--ignore-dependencies')

  ARGV.formulae.each do |f|
    if not f.installed? or ARGV.force?
      installer.install f
    else
      puts "Formula already installed: #{f.prefix}"
    end
  end
end

def xcode_version
  `xcodebuild -version 2>&1` =~ /Xcode (\d(\.\d)*)/
  return $1 ? $1 : nil
end

def _compiler_recommendation build, recommended
  message = (!build.nil? && build < recommended) ? "(#{recommended} or newer recommended)" : ""
  return build, message
end
