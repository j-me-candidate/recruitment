require 'rails_helper'

RSpec.describe ReviewCreationWorker, type: :worker do
  let(:product) { create(:product) }
  let(:worker) { described_class.new }

  it 'creates a review with valid attributes' do
    worker.perform(product.id, 'Great product!', 5, 'John Doe', ['tag1', 'tag2'])

    expect(product.reviews.last).to have_attributes(
      body: 'Great product!',
      rating: 5.0,
      reviewer_name: 'John Doe',
      tags: ['tag1', 'tag2'])
  end

  it 'raises an error if product does not exist' do
    expect {
      worker.perform(-1, 'Great product!', 5, 'John Doe', ['tag1', 'tag2'])
    }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
