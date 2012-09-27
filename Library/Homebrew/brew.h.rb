FORMULA_META_FILES = %w[README README.md ChangeLog COPYING LICENSE LICENCE COPYRIGHT AUTHORS]
PLEASE_REPORT_BUG = "#{Tty.white}Please follow the instructions to report this bug at: #{Tty.em}\n#{HOMEBREW_GIT_URL}/wiki/new-issue#{Tty.reset}"

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

def github_info name
  formula_name = Formula.path(name).basename
  user = HOMEBREW_GIT_URL
  branch = HOMEBREW_GIT_BRANCH

  if system "#{SystemCommand.which_s} git"
    gh_user=`git config --global github.user 2>/dev/null`.chomp
    /^\*\s*(.*)/.match(`git --work-tree=#{HOMEBREW_REPOSITORY} branch 2>/dev/null`)
    unless $1.nil? || $1.empty? || gh_user.empty?
      branch = $1.chomp
      user = gh_user
    end
  end

  return "http://github.com/#{user}/homebrew/commits/#{branch}/Library/Formula/#{formula_name}"
end

def info f
  exec 'open', github_info(f.name) if ARGV.flag? '--github'

  puts "#{f.name} #{f.version}"
  puts f.homepage

  puts "Depends on: #{f.deps.join(', ')}" unless f.deps.empty?

  if f.prefix.parent.directory?
    kids=f.prefix.parent.children
    kids.each do |keg|
      next if keg.basename.to_s == '.DS_Store'
      print "#{keg} (#{keg.abv})"
      print " *" if f.installed_prefix == keg and kids.length > 1
      puts
    end
  else
    puts "Not installed"
  end

  if f.caveats
    puts
    puts f.caveats
    puts
  end

  history = github_info(f.name)
  puts history if history

rescue FormulaUnavailableError
  # check for DIY installation
  d=HOMEBREW_PREFIX+name
  if d.directory?
    ohai "DIY Installation"
    d.children.each {|keg| puts "#{keg} (#{keg.abv})"}
  else
    raise "No such formula or keg"
  end
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

########################################################## class PrettyListing
class PrettyListing
  def initialize path
    Pathname.new(path).children.sort{ |a,b| a.to_s.downcase <=> b.to_s.downcase }.each do |pn|
      case pn.basename.to_s
      when 'bin', 'sbin'
        pn.find { |pnn| puts pnn unless pnn.directory? }
      when 'lib'
        print_dir pn do |pnn|
          # dylibs have multiple symlinks and we don't care about them
          (pnn.extname == '.dylib' or pnn.extname == '.pc') and not pnn.symlink?
        end
      else
        if pn.directory?
          if pn.symlink?
            puts "#{pn} -> #{pn.readlink}"
          else
            print_dir pn
          end
        elsif not (FORMULA_META_FILES.include? pn.basename.to_s or pn.basename.to_s == '.DS_Store')
          puts pn
        end
      end
    end
  end

private
  def print_dir root
    dirs = []
    remaining_root_files = []
    other = ''

    root.children.sort.each do |pn|
      if pn.directory?
        dirs << pn
      elsif block_given? and yield pn
        puts pn
        other = 'other '
      else
        remaining_root_files << pn unless pn.basename.to_s == '.DS_Store'
      end
    end

    dirs.each do |d|
      files = []
      d.find { |pn| files << pn unless pn.directory? }
      print_remaining_files files, d
    end

    print_remaining_files remaining_root_files, root, other
  end

  def print_remaining_files files, root, other = ''
    case files.length
    when 0
      # noop
    when 1
      puts files
    else
      puts "#{root}/ (#{files.length} #{other}files)"
    end
  end
end


def gcc_42_build
  plat = SystemCommand.platform
  case plat
  when :linux
    5664
  when :mac
    `/usr/bin/gcc-4.2 -v 2>&1` =~ /build (\d{4,})/
    if $1
      $1.to_i 
    elsif system "/usr/bin/which gcc"
      # Xcode 3.0 didn't come with gcc-4.2
      # We can't change the above regex to use gcc because the version numbers
      # are different and thus, not useful.
      # FIXME I bet you 20 quid this causes a side effect — magic values tend to
      401
    else
      nil
    end
  else
    nil
  end
end
alias :gcc_build :gcc_42_build # For compatibility

def gcc_40_build
  plat = SystemCommand.platform
  case plat
  when :linux
    5664
  when :mac
    `/usr/bin/gcc-4.0 -v 2>&1` =~ /build (\d{4,})/
    if $1
      $1.to_i 
    else
      nil
    end
  else
    nil
  end
end

def llvm_build
  if SystemCommand.platform == :mac
    if MACOS_VERSION >= 10.6
      xcode_path = `/usr/bin/xcode-select -print-path`.chomp
      return nil if xcode_path.empty?
      `#{xcode_path}/usr/bin/llvm-gcc -v 2>&1` =~ /LLVM build (\d{4,})/
      $1.to_i
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
