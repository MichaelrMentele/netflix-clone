require 'spec_helper'

describe User do 
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:email) }
  it { is_expected.to have_many(:queue_items).order('position ASC') }
end