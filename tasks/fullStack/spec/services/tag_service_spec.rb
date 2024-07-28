require 'rails_helper'

RSpec.describe TagService do
  describe ".tags_with_default" do
    let(:product) { create(:product) }
    let(:shop) { product.shop }

    context "when the product does not exist" do
      it "returns the given and default tags" do
        result = TagService.tags_with_default(-1, "given_tag1,given_tag2")

        expect(result).to match_array(%w[default given_tag1 given_tag2])
      end
    end

    context "when the product exists" do
      context "when the shop has tags" do
        before do
          shop.update(tags: %w[shop_tag1 shop_tag2])
        end

        it "returns shop tags and given tags" do
          tags = "given_tag1,given_tag2"
          result = TagService.tags_with_default(product.id, tags)

          expect(result).to match_array(%w[shop_tag1 shop_tag2 given_tag1 given_tag2])
        end
      end

      context "when the shop does not have tags" do
        before do
          shop.update(tags: nil)
        end

        it "returns default tags and given tags" do
          tags = "given_tag1,given_tag2"
          result = TagService.tags_with_default(product.id, tags)

          expect(result).to match_array(%w[default given_tag1 given_tag2])
        end
      end
    end
  end
end
