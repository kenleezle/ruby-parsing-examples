require 'rubygems'
require 'bundler/setup'
require './lib/person.rb'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

desc 'Read all three file formats and print all three outputs'
task :print do
  Person.default_comparator =
    Person::GenderThenLastNameAscComparator.instance

  people = Array.new

  Person.loader = Person::PipeDelimitedLoader.instance
  people.concat Person.load_from_file('./spec/fixtures/pipe.txt')

  Person.loader = Person::CommaDelimitedLoader.instance
  people.concat Person.load_from_file('./spec/fixtures/comma.txt')

  Person.loader = Person::SpaceDelimitedLoader.instance
  people.concat Person.load_from_file('./spec/fixtures/space.txt')

  puts 'Output 1:'
  puts people.sort.collect(&:to_s)
  puts

  people.each do | person |
    person.comparator = Person::DateOfBirthComparator.instance
  end

  puts 'Output 2:'
  puts people.sort.collect(&:to_s)
  puts

  people.each do | person |
    person.comparator = Person::LastNameDescComparator.instance
  end

  puts 'Output 3:'
  puts people.sort.collect(&:to_s)
end
