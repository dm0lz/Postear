Given /^i am "(.*?)"$/ do |arg1|
  #pending # express the regexp above with the code you wish you had
end

When /^i hit the postear page$/ do
  #pending # express the regexp above with the code you wish you had
end

Then /^i should see my differents accounts$/ do
  #pending # express the regexp above with the code you wish you had
  #binding.pry
  PersonUser.first.nil?.should be_false
end

Then /^i should be able to select the ones i want to post to$/ do
  pending # express the regexp above with the code you wish you had
end
