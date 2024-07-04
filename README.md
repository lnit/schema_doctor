# SchemaDoctor

Automatic database documentation tool, for Ruby on Rails project.

## Installation

Add the gem to your project

```rb
gem "rails"

group :development do
  gem "schema_doctor"
end
```

Then `bundle install` and you are ready to go.

## Usage

```sh
rails schema:analyze # Analyze Database Schema.
rails schema:export  # Export HTML.
```
