class GovukComponent::TableComponent::BodyComponent < GovukComponent::Base
  renders_many :rows, GovukComponent::TableComponent::RowComponent

  def initialize(rows: nil, first_cell_is_header: false, classes: [], html_attributes: {})
    super(classes: classes, html_attributes: html_attributes)

    build_rows_from_row_data(rows, first_cell_is_header)
  end

private

  def build_rows_from_row_data(data, first_cell_is_header)
    return if data.blank?

    data.each { |d| row(cell_data: d, first_cell_is_header: first_cell_is_header) }
  end

  def default_classes
    %w(govuk-table__body)
  end
end
