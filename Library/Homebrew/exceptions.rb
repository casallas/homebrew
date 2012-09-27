
class NotAKegError < RuntimeError
end

class FormulaUnavailableError < RuntimeError
  attr :name
  def initialize name
    @name = name
    super "No available formula for #{name}"
  end
end

module Homebrew
  class InstallationError < RuntimeError
    attr :formula
    def initialize formula
      @formula = formula
    end
    def initialize formula, message
      super message
      @formula = formula
    end
  end
end

class BuildError < Homebrew::InstallationError
  attr :exit_status
  attr :command
  attr :env

  def initialize formula, cmd, args, es
    @command = cmd
    @env = ENV.to_hash
    @exit_status = es.exitstatus rescue 1
    args = args.map{ |arg| arg.gsub " ", "\\ " }.join(" ")
    super formula, "Failed executing: #{command} #{args}"
  end

  def was_running_configure?
    @command == './configure'
  end
end
