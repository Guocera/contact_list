#!/Users/YEE/.rvm/rubies/ruby-2.3.0/bin/ruby
require 'pry'
require 'pg'
require 'active_record'
require_relative 'contact_list'
require_relative 'contact'

ActiveRecord::Base.establish_connection(
  adapter: :postgresql,
  database: 'contact_list'
  )
contact_list = ContactList.new

contact_list.menu