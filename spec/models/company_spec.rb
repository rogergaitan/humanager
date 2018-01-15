require 'rails_helper'

RSpec.describe Company, :type => :model do

  it "updates data from firebird" do
    Company.sync_fb
    
    empmaestcc = Empmaestcc.first
    empagropecuaria = empmaestcc.empagropecuaria
    company = Company.find_by_code(empmaestcc.iemp)

    empmaestcc.ncc = "testcompany"    	   
    empagropecuaria.srotulorpt1 = "testsrotulorpt1"
    empagropecuaria.srotulorpt2 = "testsrotulorpt2"
    empagropecuaria.srotulorpt3 = "testsrotulorpt3"
    empagropecuaria.sinfopiepagina = "testsinfopagina"

    empmaestcc.save
    empagropecuaria.save

    Company.sync_fb

    company.reload

    expect(company.name).to eq("testcompany")
    expect(company.label_reports_1).to eq("testsrotulorpt1")
    expect(company.label_reports_2).to eq("testsrotulorpt2")
    expect(company.label_reports_3).to eq("testsrotulorpt3")
    expect(company.page_footer).to eq("testsinfopagina")
  end

end
