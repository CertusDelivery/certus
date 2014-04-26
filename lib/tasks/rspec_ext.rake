if defined? RSpec
  namespace :spec do
    desc "Run the code examples in spec/features"
    RSpec::Core::RakeTask.new(features: 'db:test:prepare') do |t|
      t.pattern = './spec/features/**/*{.feature}'
    end
  end
end