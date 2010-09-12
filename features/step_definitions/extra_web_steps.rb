When /^the change event for "([^"]*)" gets triggered$/ do |selector|
  page.evaluate_script "$('#{selector}').trigger('change');" rescue nil
end
