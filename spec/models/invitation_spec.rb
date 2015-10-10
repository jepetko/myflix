require 'spec_helper'

describe Invitation do

  it { should belong_to :user }
  it { should respond_to :user_id }
  it { should respond_to :full_name }
  it { should respond_to :email }
  it { should respond_to :token }

  it { should validate_presence_of :user }
  it { should validate_presence_of :email }

end