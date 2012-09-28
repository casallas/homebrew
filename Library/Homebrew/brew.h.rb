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

def xcode_version
  `xcodebuild -version 2>&1` =~ /Xcode (\d(\.\d)*)/
  return $1 ? $1 : nil
end

def _compiler_recommendation build, recommended
  message = (!build.nil? && build < recommended) ? "(#{recommended} or newer recommended)" : ""
  return build, message
end
