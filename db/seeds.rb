# coding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# import production users
User.import

dir = File.dirname(__FILE__)
name = File.basename(__FILE__)
name = File.basename(name, File.extname(name))
dir = File.join(dir, name)

# import devs & end-users
require File.join(dir, 'user')

# import org units
require File.join(dir, 'org_unit')

# import project names
require File.join(dir, 'project_name')
