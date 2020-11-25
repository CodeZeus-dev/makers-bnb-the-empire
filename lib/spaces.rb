class Space

  attr_reader :id, :name, :description, :location, :price, :user_id

  def initialize(id, name, description, location, price, user_id)
    @id = id
    @name = name
    @description = description
    @location = location
    @price = price.to_i
    @user_id = user_id
  end

  def self.create(name:, description:, location:, price:, user_id:)
    result = DatabaseConnection.query("INSERT INTO spaces (name, description, location, price, user_id)
                              VALUES ('#{name}', '#{description}', '#{location}', #{price}, '#{user_id}') RETURNING id, name, description, location, price, user_id;")
    Space.new(result[0]['id'], result[0]['name'], result[0]['description'], result[0]['location'], result[0]['price'], result[0]['user_id'])
  end

  def self.retrieve_available(date = nil)
    if !date
      result = DatabaseConnection.query("SELECT * FROM spaces;")
    else
      result = DatabaseConnection.query("SELECT name, description, location, price, user_id FROM spaces JOIN booking ON (spaces.id = booking.space_id)
                                             WHERE booking.check_in_date = '#{date}' AND booking.booked = FALSE")
    end
    result.map do |entry|
      Space.new(entry['id'], entry['name'], entry['description'], entry['location'], entry['price'], entry['user_id'])
    end
  end
end