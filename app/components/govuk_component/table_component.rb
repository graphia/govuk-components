class GovukComponent::TableComponent < GovukComponent::Base
  renders_one :caption, GovukComponent::TableComponent::CaptionComponent
  renders_one :head, GovukComponent::TableComponent::HeadComponent
  renders_many :bodies, GovukComponent::TableComponent::BodyComponent

  attr_accessor :id, :first_cell_is_header

  def initialize(id: nil, rows: nil, head: nil, first_cell_is_header: false, classes: [], html_attributes: {})
    super(classes: classes, html_attributes: html_attributes)

    @id = id
    @first_cell_is_header = first_cell_is_header

    # when no rows are passed in it's likely we're taking the slot approach
    return unless rows.presence

    # if no head is passed in,use the first row for headers
    build(*(head ? [head, rows] : [rows[0], rows[1..]]))
  end

private

  def build(head_data, body_data)
    head(rows: [head_data])
    body(rows: body_data, first_cell_is_header: first_cell_is_header)
  end

  def default_classes
    %w(govuk-table)
  end
end
