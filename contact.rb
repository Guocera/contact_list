require 'csv'

# Represents a person in an address book.
class Contact

  attr_reader :name, :email, :csv_file, :contacts

  def initialize(name, email)
    # TODO: Assign parameter values to instance variables.
  end

  # Provides functionality for managing a list of Contacts in a database.
  class << self

    # Returns an Array of Contacts loaded from the database.
    def all
      # TODO: Return an Array of Contact instances made from the data in 'contacts.csv'.
      @csv_file = 'contacts.csv'
      contact_info = CSV.read(@csv_file)
      @contacts = contactify(contact_info)
    end
    ContactInfo = Struct.new(:name, :email)
    def contactify(contact_info)
      contact_info.collect do |row|
        ContactInfo.new(row[0], row[1])
      end
    end


    # Creates a new contact, adding it to the database, returning the new contact.
    def create(name, email)
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      self.contacts << ContactInfo.new(full_name, email)
      CSV.open(csv_file, 'w') do |csv| 
      contacts.each { |customer| csv << [customer[:name], customer[:email]] }
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
