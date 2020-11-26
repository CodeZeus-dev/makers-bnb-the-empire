class Booking

  attr_reader :id, :space_id, :user_id, :check_in, :booked

  def initialize(check_in, booked = false, space_id, user_id, id)
    @check_in = check_in
    @booked = booked
    @space_id = space_id.to_s
    @user_id = user_id.to_s
    @id = id
  end

  def self.create(check_in:, booked:, space_id:, user_id:)
    result = DatabaseConnection.query("INSERT INTO bookings (check_in, booked, space_id, user_id)
                                  VALUES ('#{check_in}', '#{booked}', #{space_id}, '#{user_id}')
                                  RETURNING id, check_in, booked, space_id, user_id;")
    Booking.new(result[0]['check_in'], result[0]['booked'], result[0]['space_id'], result[0]['user_id'], result[0]['id'])
    # Test why the return order matters when running rspec!!! Check w/ different order
  end

  def self.retrieve_booking
    result = DatabaseConnection.query("SELECT * FROM bookings;")
    result.map do |booking|
      Booking.new(booking['check_in'], booking['booked'], booking['space_id'], booking['user_id'], booking['id'])
    end
  end

  def self.retrieve_requests_made(user_id:)
    result = DatabaseConnection.query("SELECT * FROM bookings JOIN spaces ON (space_id = spaces.id)
                                           WHERE bookings.user_id = '#{user_id}';")
    result
  end

  def self.retrieve_requests_received(host_id:)
    result = DatabaseConnection.query("SELECT bookings.user_id, bookings.check_in, spaces.name, spaces.user_id FROM bookings JOIN spaces ON (space_id = spaces.id)
                                           WHERE space_id IN (SELECT id FROM spaces WHERE user_id='#{host_id}');")
    result
  end

end