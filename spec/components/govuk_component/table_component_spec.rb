require 'spec_helper'

RSpec.describe(GovukComponent::TableComponent, type: :component) do
  let(:id) { 'important-table' }
  let(:component_css_class) { 'govuk-table' }
  let(:caption_text) { "What a nice table" }

  let(:kwargs) { { id: id } }

  subject! do
    render_inline(GovukComponent::TableComponent.new(**kwargs)) do |table|
      table.caption(text: "What a nice table")

      table.head do |head|
        head.row {}
      end

      table.body do |body|
        body.row {}
      end
    end
  end

  specify "renders a table with thead and tbody elements" do
    expect(rendered_component).to have_tag("table", with: { class: "govuk-table" })
  end

  specify "table has the provided id" do
    expect(rendered_component).to have_tag("table", with: { id: id })
  end

  specify "renders a thead element" do
    expect(rendered_component).to have_tag("table > thead")
  end

  specify "renders a tbody element" do
    expect(rendered_component).to have_tag("table > tbody")
  end

  context "when there is more than one tbody" do
    let(:expected_count) { 2 }

    subject! do
      render_inline(GovukComponent::TableComponent.new(**kwargs)) do |table|
        table.caption(text: "What a nice table")

        expected_count.times { table.body {} }
      end
    end

    specify "mutiple tbody elements are rendered" do
      expect(rendered_component).to have_tag("table > tbody", count: expected_count)
    end
  end

  describe "passing data directly into the table component" do
    describe "captions" do
      let(:rows) { [%w(a b c), %w(d e f)] }

      context "when the caption is passed in as an argument" do
        let(:caption_text) { "Argument-supplied caption" }

        subject! do
          render_inline(GovukComponent::TableComponent.new(**kwargs.merge(rows: rows, caption: caption_text)))
        end

        specify "renders the caption with the provided text" do
          expect(rendered_component).to have_tag("table") do
            with_tag("caption", text: caption_text)
          end
        end
      end

      context "when no caption is passed in" do
        let(:caption_text) { nil }

        subject! do
          render_inline(GovukComponent::TableComponent.new(**kwargs.merge(rows: rows, caption: caption_text)))
        end

        specify "renders no caption element" do
          expect(rendered_component).to have_tag("table") do
            without_tag("caption")
          end
        end
      end
    end

    context "when the rows are passed in as a multidimensional array" do
      context "of arrays" do
        context "when the first row contains headers and there are three rows of data" do
          let(:rows) do
            [
              %w(header-col-1 header-col-2 header-col-3 header-col-4),
              %w(row-1-col-1 row-1-col-2 row-1-col-3 row-1-col-4),
              %w(row-2-col-1 row-2-col-2 row-2-col-3 row-2-col-4),
              %w(row-3-col-1 row-3-col-2 row-3-col-3 row-3-col-4),
            ]
          end

          let(:body_rows) { rows[1..] }

          subject! do
            render_inline(GovukComponent::TableComponent.new(**kwargs.merge(rows: rows)))
          end

          specify "renders one header row" do
            expect(rendered_component).to have_tag("table", with: { class: component_css_class }) do
              with_tag("thead", with: { class: "govuk-table__head" }) do
                with_tag("tr", with: { class: "govuk-table__row" }, count: 1)
              end
            end
          end

          specify "renders three body rows" do
            expect(rendered_component).to have_tag("table", with: { class: component_css_class }) do
              with_tag("tbody", with: { class: "govuk-table__body" }) do
                with_tag("tr", with: { class: "govuk-table__row" }, count: 3)
              end
            end
          end
        end

        context "when there are three rows of data and the headers are passed in separately" do
          let(:head) do
            %w(header-col-1 header-col-2 header-col-3 header-col-4)
          end

          let(:rows) do
            [
              %w(row-1-col-1 row-1-col-2 row-1-col-3 row-1-col-4),
              %w(row-2-col-1 row-2-col-2 row-2-col-3 row-2-col-4),
              %w(row-3-col-1 row-3-col-2 row-3-col-3 row-3-col-4),
            ]
          end

          subject! do
            render_inline(GovukComponent::TableComponent.new(**kwargs.merge(head: head, rows: rows)))
          end

          specify "renders one header row" do
            expect(rendered_component).to have_tag("table", with: { class: component_css_class }) do
              with_tag("thead", with: { class: "govuk-table__head" }) do
                with_tag("tr", with: { class: "govuk-table__row" }, count: 1)
              end
            end
          end

          specify "renders three body rows" do
            expect(rendered_component).to have_tag("table", with: { class: component_css_class }) do
              with_tag("tbody", with: { class: "govuk-table__body" }) do
                with_tag("tr", with: { class: "govuk-table__row" }, count: 3)
              end
            end
          end

          specify "the head contains the right columns" do
            expect(rendered_component).to have_tag("table > thead > tr") do
              with_tag("th", count: 4)

              head.each do |header_value|
                with_tag("th", text: header_value)
              end
            end
          end

          specify "the rows each have the right contents" do
            expect(rendered_component).to have_tag("table > tbody") do
              with_tag("td", count: 4 * rows.size)

              rows.each do |row|
                row.each do |cell_value|
                  with_tag("td", text: cell_value)
                end
              end
            end
          end
        end
      end
    end

    context "when :first_cell_is_header is true" do
      let(:number_of_rows) { 3 }
      let(:row_header_text) { 'should be a header' }
      let(:row_cell_text) { 'should be a regular cell' }

      let(:head) { %w(header-col-1 header-col-2 header-col-3) }
      let(:rows) do
        number_of_rows.times.map { [row_header_text, row_cell_text, row_cell_text] }
      end

      subject! do
        render_inline(GovukComponent::TableComponent.new(**kwargs.merge(head: head, rows: rows, first_cell_is_header: true)))
      end

      specify "renders the header content in table header (th) cells" do
        expect(rendered_component).to have_tag("table > tbody") do
          with_tag('th', text: row_header_text, count: number_of_rows)
          with_tag('td', text: row_cell_text, count: number_of_rows * 2)
        end
      end

      specify "the header is always first" do
        html.css('tbody > tr').map(&:elements).each { |r| expect(r.first.name).to eql('th') }
      end
    end
  end

  context "when the rows are built using nested slots" do
    subject! do
      render_inline(GovukComponent::TableComponent.new) do |table|
        table.head do |head|
          head.row do |row|
            helper.safe_join(1.upto(3).map { |i| row.cell(header: true, text: "header-col-#{i}") })
          end
        end

        table.body do |body|
          1.upto(3) do |i|
            body.row do |row|
              row.cell(text: "row-#{i}-col-1")
              row.cell(text: "row-#{i}-col-2")
              row.cell(text: "row-#{i}-col-3")
            end
          end
        end
      end
    end

    specify "renders a table" do
      expect(rendered_component).to have_tag('table', with: { class: "govuk-table" })
    end

    specify "the table has the right head content" do
      expect(rendered_component).to have_tag('table') do
        with_tag('thead') do
          with_tag('tr', with: { class: "govuk-table__row" }, count: 1) do
            with_tag('th', with: { class: "govuk-table__header" }, count: 3)
          end
        end
      end
    end

    specify "the table has the right body content" do
      expect(rendered_component).to have_tag('table') do
        with_tag('tbody') do
          with_tag('tr', count: 3)

          1.upto(3).map { |i| 1.upto(3).map { |j| "row-#{i}-col-#{j}" } }.each do |row|
            row.each { |value| with_tag('tr > td', text: value) }
          end
        end
      end
    end
  end

  context 'when some data is numeric' do
    subject! do
      render_inline(GovukComponent::TableComponent.new) do |table|
        table.head do |head|
          head.row do |row|
            row.cell(text: "non-numeric", header: true)
            row.cell(text: "numeric", header: true, numeric: true)
          end
        end

        table.body do |body|
          1.upto(3) do |i|
            body.row do |row|
              row.cell(text: "non-numeric")
              row.cell(text: i, numeric: true)
            end
          end
        end
      end
    end

    specify "renders the numeric header with a numeric class" do
      expect(rendered_component).to have_tag("table > thead > tr > th", text: "numeric", with: { class: %w(govuk-table__header--numeric) })
    end

    specify "renders the numeric cells with a numeric classes" do
      1.upto(3).each do |i|
        expect(rendered_component).to have_tag("table > tbody > tr > td", text: i, with: { class: %w(govuk-table__cell--numeric) })
      end
    end
  end

  describe "captions" do
    specify "renders a caption with the correct text" do
      expect(rendered_component).to have_tag("table", with: { class: component_css_class }) do
        with_tag("caption", text: caption_text)
      end
    end

    describe "customising the caption size" do
      %w(s m l xl)
        .each
        .with_object({}) { |size, h| h[size] = "govuk-table__caption--#{size}" }
        .each do |size, expected_class|
          context "when #{size}" do
            let(:size) { size }

            subject do
              render_inline(GovukComponent::TableComponent.new(**kwargs)) do |table|
                table.caption(text: "Caption size: #{size}", size: size)
              end
            end

            specify "class '#{expected_class} is added" do
              expect(rendered_component).to have_tag('caption', with: { class: ["govuk-table__caption", "govuk-table__caption--#{size}"] })
            end
          end
        end
    end

    describe "when an invalid size is supplied" do
      let(:invalid_size) { 'xxxxxs' }
      let(:caption) { GovukComponent::TableComponent::CaptionComponent.new(text: "Bad size", size: invalid_size) }

      specify "fails with an appropriate error messsage" do
        expect { render_inline(caption) }.to raise_error(ArgumentError, /bad size #{invalid_size}/)
      end
    end

    describe "when the caption is provided in a block" do
      let(:fancy_caption_text) { "Fancy caption" }
      let(:fancy_caption) { helper.tag.span(fancy_caption_text) }

      subject do
        render_inline(GovukComponent::TableComponent.new(**kwargs)) do |table|
          table.caption { fancy_caption }
        end
      end

      specify "renders the custom caption content" do
        expect(rendered_component).to have_tag("caption > span", text: fancy_caption_text)
      end
    end

    describe "when no caption is provided" do
      subject do
        render_inline(GovukComponent::TableComponent.new(**kwargs)) do |table|
          table.head {}
          table.body {}
        end
      end

      specify "no caption tag is rendered" do
        expect(rendered_component).to have_tag("table") { without_tag("caption") }
      end
    end
  end

  describe "custom colum widths" do
    subject! do
      render_inline(GovukComponent::TableComponent.new) do |table|
        table.head do |head|
          head.row do |row|
            GovukComponent::TableComponent::CellComponent::WIDTHS.each_key do |width|
              row.cell(text: width, header: true, width: width)
            end
          end
        end
      end
    end

    specify "adds the width class correctly" do
      GovukComponent::TableComponent::CellComponent::WIDTHS.each_key do |width, expected_class|
        expect(rendered_component).to have_tag("table > thead > tr > th", with: { class: expected_class }, text: width)
      end
    end
  end

  it_behaves_like 'a component that accepts custom classes'
  it_behaves_like 'a component that accepts custom HTML attributes'
end

RSpec.describe(GovukComponent::TableComponent::HeadComponent, type: :component) do
  let(:component_css_class) { 'govuk-table__head' }
  let(:kwargs) { {} }

  it_behaves_like 'a component that accepts custom classes'
  it_behaves_like 'a component that accepts custom HTML attributes'
end

RSpec.describe(GovukComponent::TableComponent::BodyComponent, type: :component) do
  let(:component_css_class) { 'govuk-table__body' }
  let(:kwargs) { {} }

  it_behaves_like 'a component that accepts custom classes'
  it_behaves_like 'a component that accepts custom HTML attributes'
end

RSpec.describe(GovukComponent::TableComponent::RowComponent, type: :component) do
  let(:component_css_class) { 'govuk-table__row' }
  let(:kwargs) { {} }

  it_behaves_like 'a component that accepts custom classes'
  it_behaves_like 'a component that accepts custom HTML attributes'
end

RSpec.describe(GovukComponent::TableComponent::CellComponent, type: :component) do
  let(:component_css_class) { 'govuk-table__cell' }
  let(:kwargs) { {} }

  it_behaves_like 'a component that accepts custom classes'
  it_behaves_like 'a component that accepts custom HTML attributes'
end

RSpec.describe(GovukComponent::TableComponent::CaptionComponent, type: :component) do
  let(:component_css_class) { 'govuk-table__caption' }
  let(:kwargs) { { text: "Some caption" } }

  it_behaves_like 'a component that accepts custom classes'
  it_behaves_like 'a component that accepts custom HTML attributes'
end
