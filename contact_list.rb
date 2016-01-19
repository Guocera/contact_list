#!/Users/YEE/.rvm/rubies/ruby-2.3.0/bin/ruby
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
              "\tupdate\t- Update an existing contact", \
              "\tdelete\t- Delete an existing contact", \
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
    when 'delete'
      id = command[1].to_i
      contact = Contact.find(id)
      if contact == 'Contact not found.'
        puts contact
      else
        contact.id = id
        contact.destroy
        puts "Successfully deleted contact."
      end
    when 'update'
      id = command[1].to_i
      contact = Contact.find(id)
      if contact == 'Contact not found.'
        puts contact
      else
        puts "\nFull name:"
        full_name = STDIN.gets.chomp
        puts
        puts "Email:"
        email = STDIN.gets.chomp
        puts
        contact.id = id
        contact.name = full_name
        contact.email = email
        contact.save
        puts "Successfully updated contact."
      end
    when 'new'
      puts "\nFull name:"
      full_name = STDIN.gets.chomp
      puts
      puts "Email:"
      email = STDIN.gets.chomp
      puts
      Contact.create(full_name, email)
      puts "Successfully added contact."
    when 'list'
      contacts = Contact.contacts.sort_by { |contact| contact[:id]}
      contacts.each { |contact| puts "#{contact[:id]}: #{contact[:name]} (#{contact[:email]})" }
      puts "---\n#{contacts.size} #{contacts.size == 1 ? 'record' : 'records'} total\n"
    when 'show'
      puts
      contact = Contact.find(command[1].to_i)
      if contact.is_a? Contact
        puts contact.name, contact.email
      else
        puts contact
      end
      puts
    when 'search'
      matched_list = Contact.search(command[1])
      matched_list.each do |cell|
        puts "#{cell[1]}: #{cell[0][:name]} (#{cell[0][:email]})"
      end
      puts "---\n#{matched_list.size} #{matched_list.size == 1 ? 'record' : 'records'} total\n"
    else
      pp command
      puts 'Please enter new, update, delete, list, show, or search'
    end
  end
end

#binding.pry
contact_list = ContactList.new

contact_list.menu







