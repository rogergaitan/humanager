require 'rails_helper'

RSpec.describe User, :type => :model do

  it "updates user data from firebird" do
    User.sync_fb

    abausuario = Abausuario.first
    user = User.find_by_username(abausuario.nusr)
    abausuario.snombre = "testname"
    abausuario.sapellido = "testlastname"
    abausuario.semail = "test@test.com"
    abausuario.save

    User.sync_fb

    user.reload

    expect(user.name).to eq("testname testlastname")
    expect(user.email).to eq("test@test.com")
  end

end
