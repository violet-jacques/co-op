ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "spec_helper"
require "rspec/rails"

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you"re not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you"re not using ActiveRecord, or you"d prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  config.include Devise::Test::IntegrationHelpers, type: :request
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

RSpec::Matchers.define :delegate_field do |field|
  match do |type_class|
    value = double(:value) # rubocop:disable RSpec/VerifiedDoubles
    model = instance_double(model_class, (model_method || field) => value).as_null_object

    graphql_field = field.to_s.camelcase(:lower).to_sym
    expect(resolve_class_field(type: type_class, field: graphql_field, object: model)).to eq value
  end

  failure_message do
    "expected that #{field} would be delegated to the #{model_method || field} method on an instance of #{model_class} but it wasn't"
  end

  chain :to, :model_class
  chain :method, :model_method
end

def resolve_class_field(type:, field:, object: nil, arguments: {}, context: {})
  GraphQLFieldResolver.new(type: type, field: field, object: object, arguments: arguments, context: context).resolve
end

# frozen_string_literal: true

class GraphQLFieldResolver
  def initialize(schema: GraphQL::Schema, type:, field:, object: nil, arguments: {}, context: {})
    @schema = schema
    @type = type
    @field = field
    @object = object
    @arguments = arguments
    @context = context
  end

  def resolve(camelize: true)
    formatted_field = camelize ? field.to_s.camelize(:lower) : field.to_s

    type.fields[formatted_field].resolve_field(type_instance, input_instance, context_instance)
  end

  private

  attr_reader :schema, :type, :field, :object, :arguments, :context

  def query_instance
    @_query_instance ||= GraphQL::Query.new(schema)
  end

  def context_instance
    @_context_instance ||= GraphQL::Query::Context.new(query: query_instance, values: context, object: nil)
  end

  def type_instance
    @_type_instance ||= type.authorized_new(object, context_instance)
  end

  def input_instance
    input_class = Class.new(GraphQL::Schema::InputObject)
    input_class.arguments_class = arguments_class
    input_class.new(arguments, context: nil, defaults_used: {})
  end

  def arguments_class
    Class.new(GraphQL::Query::Arguments).tap do |klass|
      klass.argument_definitions = argument_definitions
    end
  end

  def argument_definitions
    @_argument_definitions ||= arguments.each_with_object({}) do |(arg_name, _arg_value), new_args|
      argument = GraphQL::Argument.new
      argument.name = arg_name.to_s
      new_args[arg_name.to_s] = argument
    end
  end
end
