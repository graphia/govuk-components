class GovukComponent::AccordionComponent < GovukComponent::Base
  renders_many :sections, ->(heading_text: nil, summary_text: nil, expanded: false, html_attributes: {}, &block) do
    GovukComponent::AccordionComponent::SectionComponent.new(
      expanded: expanded,
      heading_level: heading_level,      # set once at parent level, passed to all children
      html_attributes: html_attributes,
      summary_text: summary_text,
      heading_text: heading_text,
      &block
    )
  end

  attr_reader :id, :heading_level

  def initialize(heading_level: 2, html_attributes: {})
    @heading_level = heading_tag(heading_level)

    super(html_attributes: html_attributes)
  end

private

  def default_attributes
    { class: %w(govuk-accordion), data: { module: 'govuk-accordion' } }
  end

  def heading_tag(level)
    fail(ArgumentError, "heading_level must be 1-6") unless level.in?(1..6)

    %(h#{level})
  end
end
