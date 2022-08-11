require 'spec_helper'

RSpec.describe(GovukComponent::BackLinkComponent, type: :component) do
  let(:href) { 'https://www.gov.uk/government/organisations/department-for-education' }
  let(:kwargs) { { href: href } }
  let(:component_css_class) { 'govuk-back-link' }

  describe 'configuration' do
    after { Govuk::Components.reset! }

    describe 'default_back_link_component_text' do
      let(:overriden_default_text) { 'Retreat' }

      before do
        Govuk::Components.configure do |config|
          config.default_back_link_component_text = overriden_default_text
        end
      end

      subject! { render_inline(GovukComponent::BackLinkComponent.new(**kwargs)) }

      specify 'renders the component with overriden default text' do
        expect(rendered_content).to have_tag(
          'a',
          with: { href: href, class: component_css_class },
          text: overriden_default_text
        )
      end
    end
  end
end
