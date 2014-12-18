require 'singleton'
require 'date'
class Person
  attr_accessor :first_name, :last_name
  attr_accessor :gender, :date_of_birth
  attr_accessor :favorite_color

  attr_accessor :printer
  attr_accessor :comparator

  class << self
    attr_accessor :loader
    attr_accessor :default_comparator
    attr_accessor :default_printer
  end

  def self.load_from_file(path_to_file)
    @loader.load_from_file(path_to_file)
  end

  def initialize(options = {})
    @first_name = options[:first_name]
    @last_name = options[:last_name]
    @gender = options[:gender]
    @date_of_birth = options[:date_of_birth]
    @favorite_color = options[:favorite_color]
    @printer = Person.default_printer
    @comparator = Person.default_comparator
  end

  def to_s
    printer.to_s(self)
  end

  def <=>(other)
    comparator.compare(self, other)
  end
  # Ensure that fields are displayed in the following order:
  # last name, first name, gender, date of birth, favorite color.
  # Display dates in the format M/D/YYYY.
  class DefaultToString
    include Singleton
    def to_s(person)
      "#{person.last_name} #{person.first_name} #{person.gender} "\
      "#{person.date_of_birth.strftime('%-m/%-d/%Y')} "\
      "#{person.favorite_color}"
    end
  end
  class CommaDelimitedLoader
    include Singleton
    def load_from_file(path_to_file)
      people = []
      File.readlines(path_to_file).map(&:chomp).each do | line |
        fields = line.split(', ')
        people.push(Person.new(
          last_name: fields[0],
          first_name: fields[1],
          gender: fields[2],
          favorite_color: fields[3],
          date_of_birth: Date.strptime(fields[4], '%m/%d/%Y')
        ))
      end
      people
    end
  end
  class SpaceDelimitedLoader
    include Singleton
    def load_from_file(path_to_file)
      people = []
      File.readlines(path_to_file).map!(&:chomp).each do | line |
        fields = line.split(' ')
        people.push(Person.new(
          last_name: fields[0],
          first_name: fields[1],
          gender: fields[3] == 'M' ? 'Male' : 'Female',
          favorite_color: fields[5],
          date_of_birth: Date.strptime(fields[4], '%m-%d-%Y')
        ))
      end
      people
    end
  end
  class PipeDelimitedLoader
    include Singleton
    def load_from_file(path_to_file)
      people = []
      File.readlines(path_to_file).map(&:chomp).each do | line |
        fields = line.split(' | ')
        people.push(Person.new(
          last_name: fields[0],
          first_name: fields[1],
          gender: fields[3] == 'M' ? 'Male' : 'Female',
          favorite_color: fields[4],
          date_of_birth: Date.strptime(fields[5], '%m-%d-%Y')
        ))
      end
      people
    end
  end
  class FirstNameComparator
    include Singleton
    def compare(person1, person2)
      person1.first_name <=> person2.first_name
    end
  end
  class LastNameAscComparator
    include Singleton
    def compare(person1, person2)
      person1.last_name <=> person2.last_name
    end
  end
  class LastNameDescComparator
    include Singleton
    def compare(person1, person2)
      -1 * (person1.last_name <=> person2.last_name)
    end
  end

  class DateOfBirthComparator
    include Singleton
    def compare(person1, person2)
      retval = person1.date_of_birth <=> person2.date_of_birth
      return retval unless retval == 0
      LastNameAscComparator.instance.compare(person1, person2)
    end
  end
  class GenderThenLastNameAscComparator
    include Singleton
    def compare(person1, person2)
      retval = person1.gender <=> person2.gender
      return retval unless retval == 0
      LastNameAscComparator.instance.compare(person1, person2)
    end
  end
  @loader = CommaDelimitedLoader.instance # Set CSV as the default loader
  @default_comparator = LastNameAscComparator.instance
  @default_printer = DefaultToString.instance
end
