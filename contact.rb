require 'csv'
require 'pg'
require 'pry'

# Represents a person in an address book.
class Contact
  @@contacts = Array.new
  @@csv_file = 'contacts.csv'
  # @@contact_info = CSV.read(@@csv_file)

  # Provides functionality for managing a list of Contacts in a database.
  class << self

    # Returns an Array of Contacts loaded from the database.
    def all
      conn = PG.connect(
        host: 'localhost',
        dbname: 'contact_list',
        user: 'development',
        password: 'development'
      )
      if @@contacts == []
        conn.exec('SELECT * FROM contacts;') do |contacts|
          contacts.each do |contact|
            @@contacts << {id: contact["id"].to_i, name: contact["name"], email: contact["email"]} 
          end       
        end
      end
      conn.close
      @@contacts
    end



    # Creates a new contact, adding it to the database, returning the new contact.
    def create(full_name, email)
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      contacts << ContactInfo.new(full_name, email)
      CSV.open(@@csv_file, 'w') do |csv| 
        contacts.each { |contact| csv << [contact[:name], contact[:email]] }
      end
      puts "Successfully added contact."
    end

    # Returns the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
      if id > contacts.size
        return "Contact not found." 
      end
      return contacts[id-1][:name], @@contacts[id-1][:email]
    end

    # Returns an array of contacts who match the given term.
    def search(term)
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
      matched_list = []
      contacts.each_with_index do |contact,i|
        matched_list << [contact, i] if ( (contact[:name].match(/#{term}/)) || (contact[:email].match(/#{term}/)) )
      end
      matched_list
    end

  end

end
