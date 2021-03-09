require 'rails_helper'

# Начинаем описывать функционал, связанный с созданием игры
RSpec.feature 'USER see another profile', type: :feature do
  let(:user_1) { FactoryGirl.create(:user, id: 1, name: 'Юзер_1', balance: 1000) }
  let(:user_2) { FactoryGirl.create(:user, id: 2, name: 'Юзер_2', balance: 2000) }

  let!(:game_1) { FactoryGirl.create(:game, created_at: Time.parse('2016.10.09, 13:00'), finished_at: Time.parse('2016.10.09, 13:10'), is_failed: true, current_level: 10, prize: 1000, user: user_2) }
  let!(:game_2) { FactoryGirl.create(:game, created_at: Time.parse('2016.10.10, 13:00'), current_level: 5, prize: 500, user: user_2) }

  # Перед началом любого сценария нам надо авторизовать пользователя
  before(:each) do
    login_as user_1
  end

  # Сценарий успешного просмотра чужого профиля
  scenario 'successfully' do
    visit '/'

    visit '/users/2'

    expect(page).not_to have_content('Сменить имя и пароль')

    # game_1
    expect(page).to have_content('проигрыш')
    expect(page).to have_content('09 окт., 13:00')
    expect(page).to have_content('1 000 ₽')
    
    # game_2
    expect(page).to have_content('в процессе')
    expect(page).to have_content('10 окт., 13:00')
    expect(page).to have_content('500 ₽')
  end
end
