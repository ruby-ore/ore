require 'rspec'

RSpec::Matchers.define :have_directory do |*names|
  match do |directory|
    directory.join(*names).directory?
  end
end

RSpec::Matchers.define :have_file do |*names|
  match do |directory|
    directory.join(*names).file?
  end
end

RSpec::Matchers.define :have_executable do |*names|
  match do |directory|
    path = directory.join(*names)

    path.file? && path.executable?
  end
end

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
