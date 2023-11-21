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

  it 'updates search status, completes the job' do
    keyword = create(:keyword)

    allow(GoogleSearchManager::GoogleSearchFetcher).to receive(:call).and_return('html_content')
    allow(GoogleSearchManager::GoogleSearchScraper).to receive(:call)
    allow(KeywordManager::SearchStatusUpdater).to receive(:call)

    expect(KeywordManager::SearchStatusUpdater).to receive(:call).with(keyword, 'searching').ordered
    expect(KeywordManager::SearchStatusUpdater).to receive(:call).with(keyword, 'complete').ordered

    expect(GoogleSearchManager::GoogleSearchFetcher).to receive(:call).with(keyword)
    expect(GoogleSearchManager::GoogleSearchScraper).to receive(:call).with(keyword, 'html_content')

    described_class.perform_now(keyword)
  end

  it 'handles errors, retries the job' do
    keyword = create(:keyword)

    allow(KeywordManager::SearchStatusUpdater).to receive(:call)

    expect(GoogleSearchManager::GoogleSearchFetcher).to receive(:call).with(keyword).and_raise(StandardError)

    expect(KeywordManager::SearchStatusUpdater).to receive(:call).with(keyword, 'failed').ordered
    expect(KeywordManager::SearchStatusUpdater).to receive(:call).with(keyword, 'retrying').ordered

    described_class.perform_now(keyword)
  end
end
