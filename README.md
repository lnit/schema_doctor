# SchemaDoctor

Automatic database documentation tool, for Ruby on Rails project.

## Demo

- **[Sample Output](https://lnit.github.io/schema_doctor/)**
  - Generated from [Mastodon](https://github.com/mastodon/mastodon)'s [schema](https://github.com/mastodon/mastodon/blob/9be77fc0dbb01c1a8a54cd3da97e16c7941df367/db/schema.rb).

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
