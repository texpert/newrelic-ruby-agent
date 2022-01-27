# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/newrelic-ruby-agent/blob/main/LICENSE for complete details.

class CreateUsersAndAliases < ActiveRecord::VERSION::STRING >= "5.0.0" ? ActiveRecord::Migration["#{ActiveRecord::VERSION::STRING[0]}.0"] : ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
    end

    create_table :groups_users, :id => false do |t|
      t.integer :group_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :groups
    drop_table :groups_users
  end
end
