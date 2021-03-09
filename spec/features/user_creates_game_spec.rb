require 'rails_helper'

RSpec.feature 'USER creates game', type: :feature do
  # Чтобы пользователь мог начать игру, нам надо
  # создать пользователя
  let(:user) { FactoryGirl.create :user }

  # и создать 15 вопросов с разными уровнями сложности
  # Обратите внимание, что текст вопроса и вариантов ответа нам
  # здесь важен, так как именно их мы потом будем проверяеть
  let!(:questions) do
    (0..14).to_a.map do |i|
      FactoryGirl.create(
        :question, level: i,
        text: "Когда была куликовская битва номер #{i}?",
        answer1: '1380', answer2: '1381', answer3: '1382', answer4: '1383'
      )
    end
  end

  # Перед началом любого сценария нам надо авторизовать пользователя
  before(:each) do
    login_as user
  end

  scenario 'successfully' do
    visit '/'

    # Кликаем по ссылке "Новая игра"
    click_link 'Новая игра'

    # Ожидаем, что попадем на нужный url
    # expect(page).to have_current_path '/games/1'
    # Ожидаем, что на экране вопрос игры (самый простой)
    expect(page).to have_content('Когда была куликовская битва номер 0?')

    # Ожидаем, что на экране варианты ответа на вопрос
    expect(page).to have_content('1380')
    expect(page).to have_content('1381')
    expect(page).to have_content('1382')
    expect(page).to have_content('1383')
  end
end
