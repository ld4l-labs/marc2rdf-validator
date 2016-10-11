require 'rspec/core/formatters/console_codes'

class Ld4pFormatter
  RSpec::Core::Formatters.register self, :example_group_started, :example_passed,
                                         :example_failed, :close

  def initialize output
    @output = output
  end

  def example_group_started notification
    @output << RSpec::Core::Formatters::ConsoleCodes.wrap("\n#{RSpec::Core::Formatters::ConsoleCodes.wrap(notification.group.description, :yellow)}:\n", :bold)
  end

  def example_passed notification # ExampleNotification
    @output << RSpec::Core::Formatters::ConsoleCodes.wrap("\n\t\u2713\t", :success)
    @output << "#{RSpec::Core::Formatters::ConsoleCodes.wrap(notification.example.description, :cyan)}"
    @output << "\t#{RSpec::Core::Formatters::ConsoleCodes.wrap(notification.example.location, :blue)}\n"
  end

  def example_failed notification # ExampleNotification
    @output << RSpec::Core::Formatters::ConsoleCodes.wrap("\n\tFail!\t", :failure)
    @output << "#{RSpec::Core::Formatters::ConsoleCodes.wrap(notification.example.description, :cyan)}"
    @output << "\t#{RSpec::Core::Formatters::ConsoleCodes.wrap(notification.example.location, :blue)}\n"
  end

  def close notification
    @output << RSpec::Core::Formatters::ConsoleCodes.wrap("\nTHE END.\n", :yellow)
  end
end
