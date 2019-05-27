require 'rails_helper'

RSpec.describe Movie, type: :model do
  it "is valid with a title,production_year,running_time,rating" do
    movie = Movie.new(
      title: 'DIC',
      production_year: 2000,
      running_time: 120,
      rating: 'G')
    expect(movie).to be_valid
  end

  it "is invalid without a title" do
    movie = Movie.new(title: nil)
    movie.valid?
    expect(movie.errors[:title]).to include "を入力してください"
  end

  it "is invalid with a duplicate title" do
    Movie.create(
      title: 'DIC',
      production_year: 2000,
      running_time: 120,
      rating: 'G')
    movie = Movie.new(
      title: 'DIC',
      production_year: 3000,
      running_time: 150,
      rating: 'PG12')
    movie.valid?
    expect(movie.errors[:title]).to include("はすでに存在します")
  end

  it "is invalid with title is 101 or more characters" do
    movie = Movie.new(title: 'a' * 101)
    movie.valid?
    expect(movie.errors[:title]).to include("は100文字以内で入力してください")
  end

  # 配列（上記の場合はバリデーションエラー）は、全文一致じゃないとダメ！
  # pending "add some examples to (or delete) #{__FILE__}" ←最初から書いてあった
end
