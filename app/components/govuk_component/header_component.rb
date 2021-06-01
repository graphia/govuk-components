class GovukComponent::HeaderComponent < GovukComponent::Base
  renders_many :items, "Item"
  renders_one :product_description

  attr_accessor :logo, :logo_href, :service_name, :service_name_href, :product_name, :menu_button_label, :navigation_label

  def initialize(classes: [],
                 html_attributes: {},
                 logo: 'GOV.UK',
                 logo_href: '/',
                 menu_button_label: 'Show or hide navigation menu',
                 navigation_classes: [],
                 navigation_label: 'Navigation menu',
                 product_name: nil,
                 service_name: nil,
                 service_name_href: '/',
                 container_classes: nil)

    super(classes: classes, html_attributes: html_attributes)

    @logo               = logo
    @logo_href          = logo_href
    @service_name       = service_name
    @service_name_href  = service_name_href
    @product_name       = product_name
    @menu_button_label  = menu_button_label
    @navigation_classes = navigation_classes
    @navigation_label   = navigation_label
    @container_classes  = container_classes
  end

private

  def default_classes
    %w(govuk-header)
  end

  def navigation_classes
    combine_classes(%w(govuk-header__navigation), @navigation_classes)
  end

  def container_classes
    combine_classes(%w(govuk-header__container govuk-width-container), @container_classes)
  end

  class Item < GovukComponent::Slot
    attr_accessor :title, :href, :active

    def initialize(title:, href: nil, active: false, classes: [], html_attributes: {})
      super(classes: classes, html_attributes: html_attributes)

      self.title  = title
      self.href   = href
      self.active = active
    end

    def active?
      active
    end

    def active_class
      %w(govuk-header__navigation-item--active) if active?
    end

    def link?
      href.present?
    end

  private

    def default_classes
      %w(govuk-header__navigation-item)
    end
  end
end
