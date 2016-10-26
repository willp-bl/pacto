# -*- encoding : utf-8 -*-
module Pacto
  class Configuration
    attr_accessor :adapter, :strict_matchers,
                  :contracts_path, :logger, :generator_options,
                  :hide_deprecations, :default_consumer, :default_provider,
                  :stenographer_log_file, :color, :proxy, :insecure_tls
    attr_reader :hook

    def initialize # rubocop:disable Metrics/MethodLength
      @middleware = Pacto::Core::HTTPMiddleware.new
      @middleware.add_observer Pacto::Cops, :investigate
      @generator = Pacto::Generator.contract_generator
      @middleware.add_observer @generator, :generate
      @default_consumer = Pacto::Consumer.new
      @default_provider = Pacto::Provider.new
      @adapter = Stubs::WebMockAdapter.new(@middleware)
      @strict_matchers = true
      @contracts_path = '.'
      @hook = Hook.new {}
      @generator_options = { schema_version: 'draft3' }
      @color = $stdout.tty?
      @proxy = ENV['PACTO_PROXY']
    end

    def insecure_tls
      if ENV['PACTO_INSECURE_TLS']
        return true
      end
        false
    end

    def logger
      @logger ||= new_simple_logger
    end

    def stenographer_log_file
      @stenographer_log_file ||= File.expand_path('pacto_stenographer.log')
    end

    def register_hook(hook = nil, &block)
      if block_given?
        @hook = Hook.new(&block)
      else
        fail 'Expected a Pacto::Hook' unless hook.is_a? Hook
        @hook = hook
      end
    end

    private

    def new_simple_logger
      Logger::SimpleLogger.instance.tap do | logger |
        if ENV['PACTO_DEBUG']
          logger.level = :debug
        else
          logger.level = :default
        end
      end
    end
  end
end
