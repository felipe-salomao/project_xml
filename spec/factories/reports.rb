FactoryBot.define do
  factory :report do
    file_data { "MyText" }
    serie { "MyString" }
    nNF { "MyString" }
    dhEmi { "2024-08-13 23:52:01" }
    emit { "MyText" }
    dest { "MyText" }
    produtos { "MyText" }
    impostos { "MyText" }
    totalizadores { "MyText" }
  end
end
