# -*- encoding: utf-8 -*-

begin
  eval(`ore gemspec`)
rescue Errno::ENOENT
  STDERR.puts "This gemspec requires Ore."
  STDERR.puts "Run `gem install ore` to install Ore."
end
