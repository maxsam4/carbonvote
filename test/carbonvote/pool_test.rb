require_relative '../test_helper'

require 'carbonvote'

describe Carbonvote::Pool do

  before do
    @settings = Carbonvote::Settings.instance
  end

  it "should detect if voter in black list" do
    pool = Carbonvote::Pool.new
    account = @settings.black_list.values.first
    assert pool.voter_in_black_list?(account)
  end

end
