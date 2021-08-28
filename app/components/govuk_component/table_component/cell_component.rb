class GovukComponent::TableComponent::CellComponent < GovukComponent::Base
  attr_reader :text, :header, :numeric, :width

  alias_method :numeric?, :numeric

  WIDTHS = {
    "full"           => "govuk-input govuk-!-width-full",
    "three-quarters" => "govuk-input govuk-!-width-three-quarters",
    "two-thirds"     => "govuk-input govuk-!-width-two-thirds",
    "one-half"       => "govuk-input govuk-!-width-one-half",
    "one-third"      => "govuk-input govuk-!-width-one-third",
    "one-quarter"    => "govuk-input govuk-!-width-one-quarter",
  }.freeze

  def initialize(header: false, text: nil, numeric: false, width: nil, classes: [], html_attributes: {})
    super(classes: classes, html_attributes: html_attributes)

    @header  = header
    @text    = text
    @numeric = numeric
    @width   = width
  end

private

  def width?
    width.present?
  end

  def cell_content
    content || text
  end

  def cell_element
    header ? :th : :td
  end

  def default_classes
    if header
      %w(govuk-table__header).tap do |c|
        c << "govuk-table__header--numeric" if numeric?
        c << width_class if width?
      end
    else
      %w(govuk-table__cell).tap do |c|
        c << "govuk-table__cell--numeric" if numeric?
        c << width_class if width?
      end
    end
  end

  def width_class
    WIDTHS.fetch(width)
  end
end
