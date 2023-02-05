class GovukComponent::TableComponent::ColGroupComponent < GovukComponent::Base
  renders_many :cols, "ColComponent"

  def initialize(cols: [], html_attributes: {})
    super(html_attributes: html_attributes)

    return if cols.blank?

    cols.each { |c| with_col(span: c) }
  end

  def call
    tag.colgroup(**html_attributes) { safe_join(cols) }
  end

  def render?
    cols.any?
  end

private

  def default_attributes
    {}
  end

  class ColComponent < GovukComponent::Base
    attr_reader :span

    def initialize(span: 1, html_attributes: {})
      @span = span.to_s

      super(html_attributes: html_attributes)
    end

    def call
      tag.col(span: span, **html_attributes)
    end

  private

    def default_attributes
      {}
    end
  end
end
