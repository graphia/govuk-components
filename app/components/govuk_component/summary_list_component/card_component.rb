class GovukComponent::SummaryListComponent::CardComponent < GovukComponent::Base
  attr_reader :title

  renders_many :actions
  renders_one :summary_list, "GovukComponent::SummaryListComponent"

  def initialize(title:, actions: [], html_attributes: {})
    @title = title
    actions.each { |a| with_action { a } } if actions.any?

    super(html_attributes: html_attributes)
  end

private

  def default_attributes
    { class: %w(govuk-summary-card) }
  end
end
