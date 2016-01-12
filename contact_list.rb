require 'pry'
require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList
  attr_reader :contacts, :csv_file

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def initialize
    @csv_file = 'contact_list.csv'
    contact_info = CSV.read('contact_list.csv')
    @contacts = contactify(contact_info)
  end

  ContactInfo = Struct.new(:name, :email)
  def contactify(contact_info)
    contact_info.collect do |row|
      ContactInfo.new(row[0], row[1])
    end
  end

  def menu
    if ARGV == []
      puts "Here is a list of available commands:", \
              "\tnew\t- Create a new contact", \
              "\tlist\t- List all contacts", \
              "\tshow ##\t- Show contact ##", \
              "\tsearch\t- Search contacts"
    end
  end

  def select_command
    command = gets.chomp.split(' ')
    puts
    case command[0]
    when 'new'
      new_contact
    when 'list'
      contacts.each_with_index { |contact,i| puts "#{i+1}: #{contact[:name]} (#{contact[:email]})" }
      puts "---\n#{contacts.size} #{contacts.size == 1 ? 'record' : 'records'} total\n"
    when 'show'
      show_contacts(command[1].to_i)
    when 'search'
      puts search_contacts(command[1])
    else
      pp command
      puts 'Please enter new, list, show, or search'
    end
  end

  def search_contacts(search)
    contacts.select { |contact| ( (contact[:name].match(/#{search}/)) || (contact[:email].match(/#{search}/)) )}
  end

  def show_contacts(id)
    if id > contacts.size
      puts "Contact not found." 
      return
    end
    puts
    puts contacts[id-1][:name], contacts[id-1][:email]
    puts
  end

  def new_contact
    puts "\nFull name:"
    full_name = gets.chomp
    puts
    puts "Email:"
    email = gets.chomp
    puts
    self.contacts << ContactInfo.new(full_name, email)
    CSV.open(csv_file, 'w') do |csv| 
      contacts.each do |customer|
        csv << [customer[:name], customer[:email]]
      end
    end
    puts "Successfully added contact."
  end
end

#binding.pry
contact_list = ContactList.new
contact_list.menu
contact_list.select_command




