require 'csv'
require 'pg'
require 'pry'

# Represents a person in an address book.
class Contact
  @@contacts = Array.new
  @@csv_file = 'contacts.csv'

  DATABASE_NAME = 'contact_list'

  # Provides functionality for managing a list of Contacts in a database.
  class << self

    # Returns an Array of Contacts loaded from the database.
    def contacts
      if @@contacts == []
        conn = PG::Connection.open(dbname: DATABASE_NAME)
        conn.exec('SELECT * FROM contacts;') do |contacts|
          contacts.each do |contact|
            @@contacts << {id: contact["id"].to_i, name: contact["name"], email: contact["email"]} 
          end       
        end
      conn.close
      end
      @@contacts
    end

    # Creates a new contact, adding it to the database, returning the new contact.
    def create(full_name, email)
      contact = Contact.new(name: full_name, email: email)
      contact.save
    end

    # Returns the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      if id <= contacts.size
        conn = PG::Connection.open(dbname: DATABASE_NAME)
        contact = conn.exec_params("SELECT * FROM contacts WHERE id = $1::int;", [id])
        conn.close
        Contact.new(name: contact[0]['name'], email: contact[0]['email'])
#        return contact[0]['name'], contact[0]['email']
      else
        "Contact not found." 
      end
    end

    # Returns an array of contacts who match the given term.
    def search(term)
      matched_list = []
      conn = PG::Connection.open(dbname: DATABASE_NAME)
      conn.exec("SELECT * FROM contacts WHERE name LIKE  '%#{term}%' OR email LIKE '%#{term}%'") do |contacts|
        contacts.each do |contact|
          matched_list << [{name: contact['name'], email: contact['email']}, contact['id']]
        end
      end
      conn.close
      matched_list
    end
  end

  attr_accessor :name, :email, :id

  def initialize(args = {})
    @name = args[:name]
    @email = args[:email]
  end

  def save
    conn = PG::Connection.open(dbname: DATABASE_NAME)
    if id
      conn.exec_params("UPDATE contacts SET name = $1, email = $2 WHERE id = $3::int;", [name, email, id])
    else
      conn.exec_params("INSERT INTO contacts(name, email) VALUES($1, $2);", [name, email])
    end
    conn.close
  end

  def destroy
    conn = PG::Connection.open(dbname: DATABASE_NAME)
    conn.exec_params("DELETE FROM contacts WHERE id = $1;", [id])
    conn.close
  end

end
