require 'csv'

# Represents a person in an address book.
class Contact

  @@csv_file = 'contacts.csv'
  @@contact_info = CSV.read(@@csv_file)

  # Provides functionality for managing a list of Contacts in a database.
  class << self

    # Returns an Array of Contacts loaded from the database.
    def contacts
      @@contacts ||= contactify(@@contact_info)
      @@contacts
    end
    ContactInfo = Struct.new(:name, :email)
    def contactify(contact_info)
      contact_info.collect do |row|
        ContactInfo.new(row[0], row[1])
      end
    end


    # Creates a new contact, adding it to the database, returning the new contact.
    def create(full_name, email)
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      self.contacts << ContactInfo.new(full_name, email)
      CSV.open(@@csv_file, 'w') do |csv| 
        self.contacts.each { |contact| csv << [contact[:name], contact[:email]] }
      end
      puts "Successfully added contact."
    end

    # Returns the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
    end

    # Returns an array of contacts who match the given term.
    def search(term)
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
    end

  end

end
