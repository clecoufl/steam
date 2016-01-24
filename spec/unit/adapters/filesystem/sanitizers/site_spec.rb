require 'spec_helper'

require_relative '../../../../../lib/locomotive/steam/adapters/filesystem/sanitizer.rb'
require_relative '../../../../../lib/locomotive/steam/adapters/filesystem/sanitizers/site.rb'

describe Locomotive::Steam::Adapters::Filesystem::Sanitizers::Site do

  let(:schema)    { nil }
  let(:entity)    { instance_double('SiteEntity', metafields_schema: schema) }
  let(:sanitizer) { described_class.new }

  describe '#apply_to_entity' do

    subject { sanitizer.apply_to_entity(entity) }

    it { expect(entity).to receive(:metafields_schema=).with(nil); subject }

  end

  describe '#clean_metafields_schema' do

    subject { sanitizer.send(:clean_metafields_schema, schema) }

    it { is_expected.to eq nil }

    describe 'with a schema' do

      # see the metafields_schema.yml in the fixtures folder
      let(:schema) { {:Social=>{:label=>{:fr=>"Social (FR)"}, :position=>1, :fields=>["facebook_id", "google_id"]}, :Github=>{:position=>0, :fields=>{:api_url=>{:label=>"API Url", :type=>"string", :hint=>"API endpoint"}, :expires_in=>{:label=>{:en=>"Expires in", :fr=>"Expire dans"}, :hint=>{:en=>"Cache - In milliseconds", :fr=>"Cache - En millisecondes"}, :type=>"integer", :min=>0, :max=>3600}}}} }

      it 'loads the full schema' do
        # First namespace
        expect(subject[0]['label']).to eq('default' => 'Social', 'fr' => 'Social (FR)')
        expect(subject[0]['position']).to eq 1
        expect(subject[0]['fields']).to eq([{ 'name' => 'facebook_id' }, { 'name' => 'google_id' }])

        # Second namespace
        expect(subject[1]['label']).to eq('default' => 'Github')
        expect(subject[1]['position']).to eq 0
        expect(subject[1]['fields'].count).to eq 2
        expect(subject[1]['fields'][0]).to eq('name' => 'api_url', 'label' => { 'default' => 'API Url' }, 'type' => 'string', 'hint' => { 'default' => 'API endpoint' })
      end

    end

  end

end
