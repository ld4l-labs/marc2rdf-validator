require 'rspec/core/formatters/console_codes'

class Ld4pFormatter
  RSpec::Core::Formatters.register self, :example_group_started, :example_passed,
                                         :example_failed, :close

  def initialize output
    @output = output
  end

  def console_code
    RSpec::Core::Formatters::ConsoleCodes
  end

  def example_group_started notification
    @output << console_code.wrap("\n#{console_code.wrap(notification.group.description, :yellow)}:\n", :bold)
  end

  def example_passed notification # ExampleNotification
    @output << console_code.wrap("\n\t\u2713\t", :success)
    @output << "#{console_code.wrap(notification.example.description, :cyan)}"
    @output << "\t#{console_code.wrap(notification.example.location, :blue)}\n"
  end

  def example_failed notification # ExampleNotification
    @output << console_code.wrap("\n\tFail!\t", :failure)
    @output << "#{console_code.wrap(notification.example.description, :cyan)}"
    @output << "\t#{console_code.wrap(notification.example.location, :blue)}\n"
  end

  def close notification
    @output << console_code.wrap("\nTHE END.\n", :yellow)
  end
end
