require "rails_helper"

describe V2::M::GenresController, type: :controller do
  subject{response}

  render_views

  let(:user){FactoryGirl.create :user}

  before  do
    request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
  end

  describe "GET index" do
    let(:m_genres_json) do
      m_genres = M::Genre.all.each_with_object [] do |m_genre, m_genres|
        m_genres << {id: m_genre.id, name: m_genre.name}
      end

      {m_genres: m_genres}.to_json
    end

    before do
      load Rails.root.join "db/seeds.rb"
      xhr :get, :index
    end

    it {is_expected.to be_success}

    it "is expected to return all m_genres"do
      expect(subject.body).to eq m_genres_json
    end
  end
end
