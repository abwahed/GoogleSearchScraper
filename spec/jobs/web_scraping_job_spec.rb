# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebScrapingJob, type: :job do

  it 'enqueues WebScrapingJob to default queue' do
    ActiveJob::Base.queue_adapter = :test
    expect do
      create(:keyword)
    end.to have_enqueued_job(WebScrapingJob).on_queue('default')
  end

  it 'calls perform with the correct arguments' do
    keyword = create(:keyword)
    allow(WebScrapingJob).to receive(:perform_later)
    expect(WebScrapingJob).to receive(:perform_later).with(keyword)
    WebScrapingJob.perform_later(keyword)
  end

  it 'parses search results and notifies completed' do
    keyword = create(:keyword)
    allow_any_instance_of(WebScrapingJob).to receive(:notify_completed)
    allow_any_instance_of(WebScrapingJob).to receive(:notify_failed)

    html = '<html><body><div class="ad_cclk">Ad1</div><a href="#">Link1</a><div id="result-stats">Results: 10</div></body></html>'
    allow_any_instance_of(Selenium::WebDriver::Driver).to receive(:page_source).and_return(html)

    expect_any_instance_of(SearchResult).to receive(:save)
    WebScrapingJob.perform_now(keyword)
  end

  it 'notifies failed on exception' do
    keyword = create(:keyword)
    allow_any_instance_of(WebScrapingJob).to receive(:notify_completed)
    allow_any_instance_of(WebScrapingJob).to receive(:notify_failed).and_call_original

    allow_any_instance_of(Selenium::WebDriver::Driver).to receive(:page_source).and_raise(StandardError.new('Test error'))

    expect_any_instance_of(SearchResult).not_to receive(:save)
    WebScrapingJob.perform_now(keyword)
  end
end
