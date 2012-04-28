require 'rspec'

RSpec::Matchers.define :have_dependency do |name|
  match do |gemspec|
    gemspec.dependencies.any? { |dep| dep.name == name }
  end
end

RSpec::Matchers.define :have_development_dependency do |name|
  match do |gemspec|
    gemspec.development_dependencies.any? { |dep| dep.name == name }
  end
end
