# PgAudit

Audit and Readonly capabilities for a Postgres Database

## Installation

Add this line to your application's Gemfile:

    gem 'pg_audit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pg_audit


## Migrations

You then need to run the migration generator

	rails g pg_audit:migration


## Usage

There are two modules that can be included

1. PgAudit::Audit `include PgAudit::Audit`
2. PgAudit::Readonly `include PgAudit::Readonly`

There are additional class methods you can include to modify the default behaviour

PgAudit::Audit
	
1. columns_for_audit - return an array of the column names to be included in the audit
2. columns_to_ignore_for_audit - return an array of column names not to be included
3. audit_delete - return true/false whether you record delete transactions
4. audit_create - return true/false whether you record create transactions

PgAudit::Readonly

1. read_only_columns - return an array of columns that will be read only


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
