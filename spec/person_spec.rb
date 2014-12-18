require './lib/person.rb'
describe Person do
  it 'reads a pipe delimited file' do
    Person.loader = Person::PipeDelimitedLoader.instance
    people = Person.load_from_file('./spec/fixtures/sample_data.psv')
    i = 0
    people.each do | person |
      expect(person.first_name).to eql "first_name#{i}"
      expect(person.last_name).to eql "last_name#{i}"
      expect(person.date_of_birth.class).to equal Date
      expect(person.favorite_color).to eql "favorite_color#{i}"
      i += 1
    end

    expect(people[0].date_of_birth.year).to eql 1943
    expect(people[0].date_of_birth.month).to eql 2
    expect(people[0].date_of_birth.day).to eql 13
    expect(people[0].gender).to eql 'Male'

    expect(people[1].date_of_birth.year).to eql 1967
    expect(people[1].date_of_birth.month).to eql 4
    expect(people[1].date_of_birth.day).to eql 23
    expect(people[1].gender).to eql 'Female'
  end
  it 'reads a comma delimited file' do
    Person.loader = Person::CommaDelimitedLoader.instance
    people = Person.load_from_file('./spec/fixtures/sample_data.csv')
    i = 0
    people.each do | person |
      expect(person.first_name).to eql "first_name#{i}"
      expect(person.last_name).to eql "last_name#{i}"
      expect(person.favorite_color).to eql "favorite_color#{i}"
      i += 1
    end

    expect(people[0].date_of_birth.year).to eql 1943
    expect(people[0].date_of_birth.month).to eql 2
    expect(people[0].date_of_birth.day).to eql 13
    expect(people[0].gender).to eql 'Male'

    expect(people[1].date_of_birth.year).to eql 1967
    expect(people[1].date_of_birth.month).to eql 4
    expect(people[1].date_of_birth.day).to eql 23
    expect(people[1].gender).to eql 'Female'
  end
  it 'reads a space delimited file' do
    Person.loader = Person::SpaceDelimitedLoader.instance
    people = Person.load_from_file('./spec/fixtures/sample_data.ssv')
    i = 0
    people.each do | person |
      expect(person.first_name).to eql "first_name#{i}"
      expect(person.last_name).to eql "last_name#{i}"
      expect(person.favorite_color).to eql "favorite_color#{i}"
      i += 1
    end

    expect(people[0].date_of_birth.year).to eql 1943
    expect(people[0].date_of_birth.month).to eql 2
    expect(people[0].date_of_birth.day).to eql 13
    expect(people[0].gender).to eql 'Male'

    expect(people[1].date_of_birth.year).to eql 1967
    expect(people[1].date_of_birth.month).to eql 4
    expect(people[1].date_of_birth.day).to eql 23
    expect(people[1].gender).to eql 'Female'
  end
  it 'sorts by gender and then last name' do
    Person.default_comparator =
      Person::GenderThenLastNameAscComparator.instance

    people = Array.new
    people.push(Person.new(gender: 'Male', last_name: 'Torvalds'))
    people.push(Person.new(gender: 'Female', last_name: 'Sobieski'))
    people.push(Person.new(gender: 'Female', last_name: 'Banks'))
    people.push(Person.new(gender: 'Male', last_name: 'Hanks'))
    people.sort!
    expect(people[0].last_name).to eql 'Banks'
    expect(people[1].last_name).to eql 'Sobieski'
    expect(people[2].last_name).to eql 'Hanks'
    expect(people[3].last_name).to eql 'Torvalds'
  end
  it 'sorts by birth date ascending' do
    Person.default_comparator = Person::DateOfBirthComparator.instance
    people = Array.new
    people.push(Person.new(date_of_birth: Date.parse('22/12/2004'),
                           last_name: '2nd-oldest'))
    people.push(Person.new(date_of_birth: Date.parse('23/12/2004'),
                           last_name: '3rd-oldest'))
    people.push(Person.new(date_of_birth: Date.parse('23/11/2004'),
                           last_name: 'oldest'))
    people.push(Person.new(date_of_birth: Date.parse('23/12/2005'),
                           last_name: 'youngest'))
    people.sort!
    expect(people[0].last_name).to eql 'oldest'
    expect(people[1].last_name).to eql '2nd-oldest'
    expect(people[2].last_name).to eql '3rd-oldest'
    expect(people[3].last_name).to eql 'youngest'
  end
  it 'sorts by last name descending' do
    Person.default_comparator = Person::LastNameDescComparator.instance
    people = Array.new
    people.push(Person.new(last_name: 'Tyson'))
    people.push(Person.new(last_name: 'Aaron'))
    people.push(Person.new(last_name: 'Zales'))
    people.push(Person.new(last_name: 'Abby'))
    people.sort!
    expect(people[0].last_name).to eql 'Zales'
    expect(people[1].last_name).to eql 'Tyson'
    expect(people[2].last_name).to eql 'Abby'
    expect(people[3].last_name).to eql 'Aaron'
  end
  it 'reads pipes, commas, spaces and sorts by gender, last name asc' do
    Person.default_comparator =
      Person::GenderThenLastNameAscComparator.instance

    people = Array.new

    Person.loader = Person::PipeDelimitedLoader.instance
    people.concat Person.load_from_file('./spec/fixtures/pipe.txt')

    Person.loader = Person::CommaDelimitedLoader.instance
    people.concat Person.load_from_file('./spec/fixtures/comma.txt')

    Person.loader = Person::SpaceDelimitedLoader.instance
    people.concat Person.load_from_file('./spec/fixtures/space.txt')

    people_lines = people.sort.collect(&:to_s)
    output_lines =
      File.readlines('./spec/fixtures/gender_last_name_asc_sorted')

    output_lines.map!(&:chomp)
    expect(people_lines).to eql output_lines
  end
  it 'reads pipes, commas, and spaces and sorts by date of birth asc' do
    Person.default_comparator = Person::DateOfBirthComparator.instance
    people = Array.new

    Person.loader = Person::PipeDelimitedLoader.instance
    people.concat Person.load_from_file('./spec/fixtures/pipe.txt')

    Person.loader = Person::CommaDelimitedLoader.instance
    people.concat Person.load_from_file('./spec/fixtures/comma.txt')

    Person.loader = Person::SpaceDelimitedLoader.instance
    people.concat Person.load_from_file('./spec/fixtures/space.txt')

    people_lines = people.sort.collect(&:to_s)
    output_lines = File.readlines('./spec/fixtures/birth_date_asc_sorted')
    output_lines.map!(&:chomp)
    expect(people_lines).to eql output_lines
  end
  it 'reads pipes, commas, and spaces and sorts by last name desc' do
    Person.default_comparator = Person::LastNameDescComparator.instance
    people = Array.new

    Person.loader = Person::PipeDelimitedLoader.instance
    people.concat Person.load_from_file('./spec/fixtures/pipe.txt')

    Person.loader = Person::CommaDelimitedLoader.instance
    people.concat Person.load_from_file('./spec/fixtures/comma.txt')

    Person.loader = Person::SpaceDelimitedLoader.instance
    people.concat Person.load_from_file('./spec/fixtures/space.txt')

    people_lines = people.sort.collect(&:to_s)
    output_lines = File.readlines('./spec/fixtures/last_name_desc_sorted')
    output_lines.map!(&:chomp)
    expect(people_lines).to eql output_lines
  end
end
