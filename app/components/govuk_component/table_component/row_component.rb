class GovukComponent::TableComponent::RowComponent < GovukComponent::Base
  renders_many :cells, GovukComponent::TableComponent::CellComponent

  attr_reader :header, :first_cell_is_header

  def initialize(cell_data: nil, first_cell_is_header: false, header: false, classes: [], html_attributes: {})
    super(classes: classes, html_attributes: html_attributes)

    @header = header
    @first_cell_is_header = first_cell_is_header

    build_cells_from_cell_data(cell_data)
  end

private

  def build_cells_from_cell_data(cell_data)
    return if cell_data.blank?

    cell_data.map.with_index { |cd, i| cell(header: cell_is_header?(i), text: cd) }
  end

  def cell_is_header?(count)
    header || (first_cell_is_header && count.zero?)
  end

  def default_classes
    %w(govuk-table__row)
  end
end
