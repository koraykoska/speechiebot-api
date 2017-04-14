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

    attr_reader :result

    def initialize(json:, helpers:)
      @json = json
      @helpers = helpers
    end

    def run; end

    def default_result(ok:)
      { command: self.class.command, ok: ok }
    end
  end
end
