require 'pry'
require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
 
end


if ARGV == []
  puts "Here is a list of available commands:", \
          "\tnew\t- Create a new contact", \
          "\tlist\t- List all contacts", \
          "\tshow\t- Show a contact", \
          "\tsearch\t- Search contacts"
end