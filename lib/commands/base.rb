module Command
  # The base command
  class Base
    @command = '/command'

    class << self
      attr_reader :command
    end

    def self.command?(text, bot_name: '')
      text == @command || text == (@command + bot_name)
    end

    # Returns true iff text equals the context for this command
    def self.context?(text)
      false
    end

    attr_accessor :context

    attr_reader :result

    def initialize(json:, helpers:)
      @json = json
      @helpers = helpers
    end

    # If @context is set to true and self.context is implemented,
    # `run` should call `context_run` and do nothing else
    def run; end

    # Should be implemented if self.context? is implemented
    # If @context is set to true and self.context is implemented,
    # `run` should call `context_run` and do nothing else
    def context_run; end

    def default_result(ok:)
      { command: self.class.command, ok: ok }
    end
  end
end
