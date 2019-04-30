require 'spec_helper'

RSpec.describe PetfinderV2::Services::OptionsValidator do
  let(:valid_opts) do
    {
      age: [ :adult, :senior ],
      gender: :male,
      coat: [ :short, :medium ],
      breed: [ 'Staffordshire Bull Terrier', 'Pitbull' ]
    }
  end

  describe "#run" do
    it "should return an empty array if all options are valid" do
      expect(described_class.new(valid_opts).run).to eq([])
    end

    it "should return an array of errors when there are invalid options" do
      invalid_opts = valid_opts.merge({ age: [ :tinypup, :young ] })
      res = described_class.new(invalid_opts).run
      expect(res).to_not be_empty
      expect(res[0].match(/tinypup/)).to be_truthy
    end
  end

end
