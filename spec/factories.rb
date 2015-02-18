FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "Foobar1"
    password_confirmation "Foobar1"
  end

  factory :rating do
    score 10
  end

  factory :rating2, class: Rating do
    score 20
  end

  factory :brewery do
    name "anonymous"
    year 1900
  end

  factory :brewery2, class: Brewery do
    name "anonymous2"
    year 2015
  end

  factory :style do
    name "Lager"
    description "Nice"
  end

  factory :beer do
    name "anonymous Lager"
    brewery
    style
  end

  factory :beer2, class: Beer do
    name "anonymous IPA"
    brewery
    style
  end
end