# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList
  attr_reader :contacts

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def menu
    if ARGV == []
      puts 'Here is a list of available commands:', \
              "\tnew\t- Create a new contact", \
              "\tupdate ##\t- Update an existing contact", \
              "\tdelete ##\t- Delete an existing contact", \
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
      contact = Contact.find_by(id: id)
      if exist? contact
        contact.destroy
        puts 'Successfully deleted contact.'
      else
        puts 'No contact found.'
      end
    when 'update'
      id = command[1].to_i
      contact = Contact.find_by(id: id)
      if exist? contact
        puts '\nFull name:'
        full_name = STDIN.gets.chomp
        puts
        puts 'Email:'
        email = STDIN.gets.chomp
        puts
        contact.update(name: full_name, email: email)
        puts 'Successfully updated contact.'
      else
        puts 'No contact found.'
      end
    when 'new'
      puts "\nFull name:"
      full_name = STDIN.gets.chomp
      puts
      puts 'Email:'
      email = STDIN.gets.chomp
      puts
      Contact.create(name: full_name, email: email)
      puts 'Successfully added contact.'
    when 'list'
      contacts = Contact.all.order(:id)
      contacts.each { |contact| puts "#{contact[:id]}: #{contact[:name]} (#{contact[:email]})" }
      puts "---\n#{contacts.size} #{contacts.size == 1 ? 'record' : 'records'} total\n"
    when 'show'
      puts
      contact = Contact.find_by(id: command[1].to_i)
      if exist? contact
        puts contact.name, contact.email
      else
        puts 'No contact found.'
      end
      puts
    when 'search'
      matched_list = Contact.where('name LIKE :term OR email LIKE :term', {term: "%#{command[1]}%"})
      matched_list.each do |cell|
        puts "#{cell[:id]}: #{cell[:name]} (#{cell[:email]})"
      end
      puts "---\n#{matched_list.size} #{matched_list.size == 1 ? 'record' : 'records'} total\n"
    else
      puts 'Please enter new, update, delete, list, show, or search'
    end
  end

  def exist? contact
    contact.is_a? Contact
  end
end