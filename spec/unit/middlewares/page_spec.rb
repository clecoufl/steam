require 'spec_helper'

require_relative '../../../lib/locomotive/steam/middlewares/base'
require_relative '../../../lib/locomotive/steam/middlewares/page'

describe Locomotive::Steam::Middlewares::Page do
  let(:app) { ->(env) { [200, env, 'app'] }}

  let :middleware do
    Locomotive::Steam::Middlewares::Page.new(app)
  end

  let(:page) do
    double(title: 'title', fullpath: 'fullpath')
  end

  before do
    expect(middleware).to receive(:fetch_page).with('wk') { page }
    expect(Locomotive::Common::Logger).to receive(:info).with("Found page \"title\" [fullpath]") { nil }
  end

  subject do
    middleware.call env_for('http://www.example.com', { 'steam.locale' => 'wk' })
  end

  specify 'return 200' do
    code, headers, response = subject
    expect(code).to eq(200)
  end

  specify 'set page' do
    code, headers, response = subject
    expect(headers['steam.page']).to eq(page)
  end

  def env_for url, opts={}
    Rack::MockRequest.env_for(url, opts)
  end
end
