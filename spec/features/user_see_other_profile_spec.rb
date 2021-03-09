require 'rails_helper'

# Начинаем описывать функционал, связанный с созданием игры
RSpec.feature 'USER see another profile', type: :feature do
  let(:user1) { FactoryGirl.create(:user, name: 'Пользователь №1', balance: 1000) }
  let(:user2) { FactoryGirl.create(:user, name: 'Пользователь №2', balance: 2000) }

  let!(:game1) { FactoryGirl.create(:game, finished_at: Time.now, is_failed: true, current_level: 10, prize: 1000, user: user2) }
  let!(:game2) { FactoryGirl.create(:game, current_level: 5, prize: 500, user: user2) }

  # Перед началом любого сценария нам надо авторизовать пользователя
  before(:each) do
    login_as user1
  end

  # Сценарий успешного просмотра чужого профиля
  scenario 'successfully' do
    visit '/'

    click_on 'Пользователь №2'

    expect(page).to have_current_path("/users/#{user2.id}")
    expect(page).not_to have_content('Сменить имя и пароль')

    # game2
    expect(page).to have_content('в процессе')
    expect(page).to have_content(I18n.l(Time.now, format: :short))
    expect(page).to have_content('500 ₽')
    
    # game1
    expect(page).to have_content('проигрыш')
    expect(page).to have_content(I18n.l(Time.now, format: :short))
    expect(page).to have_content('1 000 ₽')
  end
end
