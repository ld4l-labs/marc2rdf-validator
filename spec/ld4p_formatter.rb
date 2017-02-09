# This formatter enables rspec to produce a more human-readable report.
# Instead of .....F.....FF..., etc, and then a dump of the failed tests,
# it tells you when tests both pass or fail and uses colors to delineate the
# different contexts, and also refers to the code lines of both passing and failed tests.

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
    @output << "\n\t\t#{console_code.wrap(notification.example.execution_result.exception.message, :failure)}\n"
  end

  # def dump_failures notification
  #   @output << notification.failed_examples.map do |example|
  #     full_description = example.full_description
  #     location = example.location
  #     message = example.execution_result.exception.message
  #     "#{full_description} - #{location} #{message}"
  #   end.join("\n\n\t")
  # end

  def close notification
    @output << console_code.wrap("\nTHE END.\n", :yellow)
  end
end
