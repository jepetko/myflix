require 'spec_helper'

describe QueueItem do

  it { should respond_to(:video) }
  it { should respond_to(:order_value) }
  it { should respond_to(:user) }

  it { should belong_to(:video) }
  it { should belong_to(:user) }

end