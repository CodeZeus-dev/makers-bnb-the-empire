feature 'registration' do
  scenario 'user visits home and signs up' do
    visit('/')
    fill_in('name', with: 'Malachi')
    fill_in('email', with: 'm.spencer@makers.com')
    fill_in('password', with: 'p20201124')
    click_button('Submit')

    expect(current_path).to eq('/dashboard')
    expect(page).to have_content('Welcome, Malachi')
  end
end