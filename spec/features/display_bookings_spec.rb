feature "display bookings" do
  scenario "display guest's confirmed bookings" do
    make_request
    click_button("Log Out")
    login_as_host
    click_link("Requests")
    first(".requests-received").click_button("Confirm Booking")
    click_link("dashboard")
    click_button("Log Out")
    click_link('Login')
    fill_in('email', with: 'm.spencer@makers.com')
    fill_in('password', with: '2020')
    click_button('Login')
    click_link("Bookings")
    expect(page).to have_content("Hidden Gem of Beverly Hills")
    expect(page).to have_content("07/17/2019 12:00 AM")
  end

  scenario "display bookings that the host has confirmed" do
    make_request
    click_button("Log Out")
    login_as_host
    click_link("Requests")
    first(".requests-received").click_button("Confirm Booking")
    click_link("dashboard")
    click_link("Bookings")
    expect(page).to have_content("Hidden Gem of Beverly Hills")
    expect(page).to have_content("07/17/2019 12:00 AM")
  end
end