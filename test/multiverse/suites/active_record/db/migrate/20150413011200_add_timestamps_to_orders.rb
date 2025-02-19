# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/newrelic-ruby-agent/blob/main/LICENSE for complete details.
# frozen_string_literal: true

class AddTimestampsToOrders < ActiveRecord::VERSION::STRING >= "5.0.0" ? ActiveRecord::Migration[5.0] : ActiveRecord::Migration
  def self.up
    change_table(:orders) do |t|
      t.timestamps
    end
  end

  def self.down
    remove_column(:orders, :updated_at)
    remove_column(:orders, :created_at)
  end
end
