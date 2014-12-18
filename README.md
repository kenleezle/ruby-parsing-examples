Ruby Parsing Examples
=====================

This code runs on ruby-2.1.5.

[Gemfile.lock](Gemfile.lock) documents all gem requirements.

## Installation

Running bundle install will install all the prerequisite gems.

```
bundle install
```

## Available Rake Tasks

To ensure the proper version of rake is used for this project, prepend:
```
bundle exec
```
to your calls to:
```
rake
```

Without further ado, here are the available rake tasks:
```
% bundle exec rake --tasks
rake print  # Read all three file formats and print all three outputs
rake spec   # Run RSpec code examples
```

