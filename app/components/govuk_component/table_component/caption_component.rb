class GovukComponent::TableComponent::CaptionComponent < GovukComponent::Base
  attr_reader :text, :size

  SIZES = %w(s m l xl).freeze

  def initialize(text: nil, id: nil, size: 'm', classes: [], html_attributes: {})
    super(classes: classes, html_attributes: html_attributes)

    @id   = id
    @text = text
    @size = size
  end

  def call
    tag.caption(caption_content, class: classes, **html_attributes)
  end

  def render?
    caption_content.present?
  end

private

  def caption_content
    @caption_content ||= (content || text)
  end

  def default_classes
    %w(govuk-table__caption).tap do |c|
      c << caption_size_class if @size
    end
  end

  def caption_size_class
    fail(ArgumentError, "bad size #{size}, must be in #{SIZES}") unless size.in?(SIZES)

    %(govuk-table__caption--#{size})
  end
end
