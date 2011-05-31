# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{business_time}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["bokmann"]
  s.date = %q{2010-12-22}
  s.description = %q{Have you ever wanted to do things like "6.business_days.from_now" and have weekends and holidays taken into account?  Now you can.}
  s.email = %q{dbock@codesherpas.com}
  s.files = ["test/helper.rb", "test/test_business_days.rb", "test/test_business_days_eastern.rb", "test/test_business_days_utc.rb", "test/test_business_hours.rb", "test/test_business_hours_eastern.rb", "test/test_business_hours_utc.rb", "test/test_calculating_business_duration.rb", "test/test_config.rb", "test/test_date_extensions.rb", "test/test_fixnum_extensions.rb", "test/test_time_extensions.rb", "test/test_time_with_zone_extensions.rb"]
  s.homepage = %q{http://github.com/bokmann/business_time}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Support for doing time math in business hours and days}
  s.test_files = ["test/helper.rb", "test/test_business_days.rb", "test/test_business_days_eastern.rb", "test/test_business_days_utc.rb", "test/test_business_hours.rb", "test/test_business_hours_eastern.rb", "test/test_business_hours_utc.rb", "test/test_calculating_business_duration.rb", "test/test_config.rb", "test/test_date_extensions.rb", "test/test_fixnum_extensions.rb", "test/test_time_extensions.rb", "test/test_time_with_zone_extensions.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 2.0.0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 2.0.0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 2.0.0"])
  end
end
