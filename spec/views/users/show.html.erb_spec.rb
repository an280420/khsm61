require 'rails_helper'

# тест на шаблон users/show.html.erb
RSpec.describe 'users/show', type: :view do
  let(:game) do
    FactoryGirl.build_stubbed(
      :game, id: 15, created_at: Time.parse('2016.10.09, 13:00'), current_level: 10, prize: 1000
    )
  end

  context 'user not registration' do
    before(:each) do
      assign(:user, FactoryGirl.build_stubbed(:user, name: 'Вадик', balance: 5000))

      render
    end

    it 'renders player name' do
      expect(rendered).to match 'Вадик'
    end

    it 'not render change pass if user is anonim' do
      expect(rendered).not_to match 'Сменить имя и пароль'
    end
  end

  context "user is registration" do
    before(:each) do
      user = FactoryGirl.create(:user, name: 'Вадик', balance: 5000)
      
      sign_in user
    
      assign(:user, user)
      assign(:game, game)
    end
    
    it 'shows player name' do
      render
    
      expect(rendered).to match 'Вадик'
    end
    
    it 'shows password change link' do
      render
    
      expect(rendered).to match 'Сменить имя и пароль'
    end
    
    it 'shows game elements' do
      render partial: 'users/game', object: game
    
      expect(rendered).to match '15'
      expect(rendered).to match '09 окт., 13:00'
    end
  end
end
