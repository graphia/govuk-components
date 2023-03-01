require 'spec_helper'

RSpec.describe(GovukComponent::SummaryListComponent, type: :component) do
  describe 'configuration' do
    after { Govuk::Components.reset! }

    describe 'default_summary_list_borders' do
      before do
        Govuk::Components.configure do |config|
          config.default_summary_list_borders = false
        end
      end

      subject! { render_inline(GovukComponent::SummaryListComponent.new) }

      specify "renders the borders based on the config setting" do
        expect(rendered_content).to have_tag("dl", with: { class: "govuk-summary-list--no-border" })
      end
    end

    describe 'require_summary_list_action_visually_hidden_text' do
      before do
        Govuk::Components.configure do |config|
          config.require_summary_list_action_visually_hidden_text = true
        end
      end

      context "when visually_hidden_text is supplied" do
        let(:visually_hidden_text) { "visually hidden info" }
        subject! do
          render_inline(GovukComponent::SummaryListComponent.new) do |sl|
            sl.with_row do |row|
              row.with_key(text: "key one")
              row.with_value(text: "value one")
              row.with_action(text: "action one", href: "/action-one", visually_hidden_text: visually_hidden_text)
            end
          end
        end

        specify "renders a span with the visually hidden text" do
          expect(rendered_content).to have_tag("span", text: visually_hidden_text, with: { class: "govuk-visually-hidden" })
        end
      end

      context "when visually_hidden_text is omitted" do
        subject do
          render_inline(GovukComponent::SummaryListComponent.new) do |sl|
            sl.with_row do |row|
              row.with_key(text: "key one")
              row.with_value(text: "value one")
              row.with_action(text: "action one", href: "/action-one")
            end
          end
        end

        specify "raises an error when no visually hidden text is supplied" do
          expect { subject }.to raise_error(ArgumentError, "missing keyword: visually_hidden_text")
        end
      end
    end

    describe "summary_list_action_visually_hidden_space" do
      before do
        Govuk::Components.configure do |config|
          config.summary_list_action_visually_hidden_space = true
        end
      end

      let(:visually_hidden_text) { "visually hidden info" }

      subject! do
        render_inline(GovukComponent::SummaryListComponent.new) do |sl|
          sl.with_row do |row|
            row.with_key(text: "key one")
            row.with_value(text: "value one")
            row.with_action(text: "action one", href: "/action-one", visually_hidden_text: visually_hidden_text)
          end
        end
      end

      specify "renders a span with a space inside the visually hidden text" do
        expect(rendered_content).to have_tag("span", text: "&nbsp;#{visually_hidden_text}", with: { class: "govuk-visually-hidden" })
      end
    end
  end
end
