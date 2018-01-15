require 'rails_helper'

RSpec.describe Task, :type => :model do

  it "updates data from firebird" do
    Task.sync_fb
    
    labmaest = Labmaest.first
    task = Task.find_by_itask(labmaest.ilabor)

    labmaest.nlabor = "testtask"
    labmaest.nunidad = "tst"
    actividad = labmaest.actividad
    actividad.nactividad = "testnactivity"
    actividad.save
    labmaest.save

    Task.sync_fb

    task.reload

    expect(task.ntask).to eq("testtask")
    expect(task.nunidad).to eq("tst")
    expect(task.nactivity).to eq("testnactivity")
  end

end
