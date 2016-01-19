#!/usr/local/rvm/rubies/ruby-2.1.3/bin/ruby
require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList
  attr_reader :contacts, :csv_file

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def initialize

  end



  def menu
    if ARGV == []
      puts "Here is a list of available commands:", \
              "\tnew\t- Create a new contact", \
              "\tlist\t- List all contacts", \
              "\tshow ##\t- Show contact ##", \
              "\tsearch\t- Search contacts"
      command = gets.chomp.split(' ')
    else
      command = ARGV
    end
    select_command(command)
  end

  def select_command(command)
    case command[0]
    when 'new'
      puts "\nFull name:"
      full_name = gets.chomp
      puts
      puts "Email:"
      email = gets.chomp
      puts
      Contact.create(full_name, email)
    when 'list'
      contacts = Contact.all
      contacts.each { |contact| puts "#{contact[:id]}: #{contact[:name]} (#{contact[:email]})" }
      puts "---\n#{contacts.size} #{contacts.size == 1 ? 'record' : 'records'} total\n"
    when 'show'
      puts
      puts Contact.find(command[1].to_i)
      puts
    when 'search'
      matched_list = Contact.search(command[1]).each do |cell|
        puts "#{cell[1]+1}: #{cell[0][:name]} (#{cell[0][:email]})"
      end
      puts "---\n#{matched_list.size} #{matched_list.size == 1 ? 'record' : 'records'} total\n"
    else
      pp command
      puts 'Please enter new, list, show, or search'
    end
  end
end

#binding.pry
contact_list = ContactList.new

contact_list.menu







