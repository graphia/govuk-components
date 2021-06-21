require 'spec_helper'

RSpec.describe(GovukLinkHelper, type: 'helper') do
  include ActionView::Helpers::UrlHelper
  include ActionView::Context

  let(:text) { 'Menu' }
  let(:url) { '/stuff/menu/' }
  let(:args) { [text, url] }
  let(:kwargs) { {} }

  describe '#govuk_link_to' do
    subject { govuk_link_to(*args, **kwargs) }
    it { is_expected.to have_tag("a", with: { href: url, class: 'govuk-link' }) }

    describe "custom classes" do
      context 'when additional classes are passed in as strings' do
        let(:custom_class) { 'yellow' }
        let(:kwargs) { { class: custom_class } }

        specify 'has the custom classes' do
          expect(subject).to have_tag("a", with: { href: url, class: ['govuk-link', custom_class] })
        end
      end

      context 'when additional classes are passed in as arrays' do
        let(:custom_class) { %w(yellow) }
        let(:kwargs) { { class: custom_class } }

        specify 'has the custom classes' do
          expect(subject).to have_tag("a", with: { href: url, class: custom_class.append("govuk-link") })
        end
      end
    end

    context 'when provided with a block' do
      let(:link_text) { 'Onwards!' }
      let(:link_html) { tag.span(link_text) }
      subject { govuk_link_to(url) { link_html } }

      specify 'renders a link containing the block content' do
        expect(subject).to have_tag('a') do
          with_tag('span', text: link_text)
        end
      end
    end

    {
      button: %w(govuk-button),
      no_visited_state: %w(govuk-link govuk-link--no-visited-state),
      muted: %w(govuk-link govuk-link--muted),
      text_colour: %w(govuk-link govuk-link--text-colour),
      inverse: %w(govuk-link govuk-link--inverse),
      no_underline: %w(govuk-link govuk-link--no-underline),
    }.each do |style, css_class|
      describe "generating a #{style}-style link with '#{style}: true'" do
        let(:kwargs) { { style => true } }

        specify "link has the class: #{css_class}" do
          expect(subject).to have_tag('a', text: text, with: { href: url, class: css_class })
        end
      end
    end

    context "when provided with link text and url params" do
      let(:link_text) { 'Onwards!' }
      let(:link_params) { { controller: :some_controller, action: :some_action } }
      let(:link_url) { '/some/link' }

      subject { govuk_link_to link_text, link_params }

      before do
        allow(self).to receive(:url_for).with(link_params).and_return link_url
      end

      it { is_expected.to have_tag('a', text: link_text, with: { href: link_url, class: 'govuk-link' }) }
    end

    context "when provided with url params and the block" do
      let(:link_text) { 'Onwards!' }
      let(:link_html) { tag.span(link_text) }
      let(:link_params) { { controller: :some_controller, action: :some_action } }
      let(:link_url) { '/some/link' }

      subject { govuk_link_to(link_params) { link_html } }

      before do
        allow(self).to receive(:url_for).with(link_params).and_return link_url
      end

      it { is_expected.to have_tag('a', with: { href: link_url }) { with_tag(:span, text: link_text)} }
    end
  end

  describe '#govuk_mail_to' do
    let(:email_address) { %(test@something.org) }
    let(:email_address_with_mailto_prefix) { %(mailto:) + email_address }
    let(:args) { [email_address, text] }
    subject { govuk_mail_to(*args, **kwargs) }

    it { is_expected.to have_tag("a", with: { href: email_address_with_mailto_prefix, class: 'govuk-link' }) }

    describe "custom classes" do
      context 'when additional classes are passed in as strings' do
        let(:custom_class) { 'yellow' }
        let(:kwargs) { { class: custom_class } }

        specify 'has the custom classes' do
          expect(subject).to have_tag("a", with: { href: email_address_with_mailto_prefix, class: ['govuk-link', custom_class] })
        end
      end

      context 'when additional classes are passed in as arrays' do
        let(:custom_class) { %w(yellow) }
        let(:kwargs) { { class: custom_class } }

        specify 'has the custom classes' do
          expect(subject).to have_tag("a", with: { href: email_address_with_mailto_prefix, class: custom_class.append("govuk-link") })
        end
      end
    end

    context 'when provided with a block' do
      let(:link_text) { 'Onwards!' }
      let(:link_html) { tag.span(link_text) }
      subject { govuk_link_to(url) { link_html } }

      specify 'renders a link containing the block content' do
        expect(subject).to have_tag('a') do
          with_tag('span', text: link_text)
        end
      end
    end

    {
      button: %w(govuk-button),
      no_visited_state: %w(govuk-link govuk-link--no-visited-state),
      muted: %w(govuk-link govuk-link--muted),
      text_colour: %w(govuk-link govuk-link--text-colour),
      inverse: %w(govuk-link govuk-link--inverse),
      no_underline: %w(govuk-link govuk-link--no-underline),
    }.each do |style, css_class|
      describe "generating a #{style}-style link with '#{style}: true'" do
        let(:kwargs) { { style => true } }

        specify "link has the class: #{css_class}" do
          expect(subject).to have_tag('a', text: text, with: { href: email_address_with_mailto_prefix, class: css_class })
        end
      end
    end
  end

  describe '#govuk_button_to' do
    subject { govuk_button_to(*args, **kwargs) }
    let(:url) { '/stuff/menu/' }

    specify 'has form with correct url containing submit input with supplied text' do
      expect(subject).to have_tag('form', with: { action: url }) do
        with_tag('input', with: { class: 'govuk-button', value: text })
      end
    end

    describe "custom classes" do
      context 'when additional classes are passed in as strings' do
        let(:custom_class) { 'yellow' }
        let(:kwargs) { { class: custom_class } }

        specify 'has the custom classes' do
          expect(subject).to have_tag('form', with: { action: url }) do
            with_tag("input", with: { class: ['govuk-button', custom_class] })
          end
        end
      end

      context 'when additional classes are passed in as arrays' do
        let(:custom_class) { %w(yellow) }
        let(:kwargs) { { class: custom_class } }

        specify 'has the custom classes' do
          expect(subject).to have_tag('form', with: { action: url }) do
            with_tag("input", with: { class: ['govuk-button', custom_class] })
          end
        end
      end
    end
  end
end
