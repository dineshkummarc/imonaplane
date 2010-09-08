Given /^today is "([^"]*)"$/ do |date|
  Timecop.travel Date.parse(date)
end

After do
  Timecop.return
end