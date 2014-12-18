module PersonHelper
  def people_from_all_three_formats
    people = []

    Person.loader = Person::PipeDelimitedLoader.instance
    people.concat Person.load_from_file('./spec/fixtures/pipe.txt')

    Person.loader = Person::CommaDelimitedLoader.instance
    people.concat Person.load_from_file('./spec/fixtures/comma.txt')

    Person.loader = Person::SpaceDelimitedLoader.instance
    people.concat Person.load_from_file('./spec/fixtures/space.txt')

    people
  end
end
