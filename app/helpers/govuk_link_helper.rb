module GovukLinkHelper
  EXTRA_OPTIONS = {
    button: false,
    no_visited_state: false,
    muted: false,
    text_colour: false,
    inverse: false,
    no_underline: false
  }.freeze

  def govuk_link_to(name = nil, options = nil, extra_options = {}, &block)
    extra_options = options if block_given?

    html_options = extra_options&.slice!(*EXTRA_OPTIONS.keys) || {}
    extra_options = EXTRA_OPTIONS.merge(extra_options || {})

    classes = build_classes(*extra_options.values_at(*EXTRA_OPTIONS.keys))
    html_options = inject_class(html_options, class_name: classes)

    if block_given?
      link_to(name, html_options, &block)
    else
      link_to(name, options, html_options)
    end
  end

  def govuk_mail_to(*args, button: false, no_visited_state: false, muted: false, text_colour: false, inverse: false, no_underline: false, **kwargs, &block)
    classes = build_classes(button, no_visited_state, muted, text_colour, inverse, no_underline)

    mail_to(*args, **inject_class(kwargs, class_name: classes), &block)
  end

  def govuk_button_to(*args, **kwargs)
    button_to(*args, **inject_class(kwargs, class_name: 'govuk-button'))
  end

private

  def build_classes(button, no_visited_state, muted, text_colour, inverse, no_underline)
    [
      link_class(button),
      no_visited_state_class(no_visited_state),
      muted_class(muted),
      text_colour_class(text_colour),
      inverse_class(inverse),
      no_underline_class(no_underline),
    ].compact.join(" ")
  end

  def inject_class(attributes, class_name:)
    attributes.with_indifferent_access.tap do |attrs|
      attrs[:class] = Array.wrap(attrs[:class]).prepend(class_name)
    end
  end

  def link_class(button)
    button ? 'govuk-button' : 'govuk-link'
  end

  def no_visited_state_class(no_visited_state)
    'govuk-link--no-visited-state' if no_visited_state
  end

  def muted_class(muted)
    'govuk-link--muted' if muted
  end

  def text_colour_class(colour)
    'govuk-link--text-colour' if colour
  end

  def inverse_class(inverse)
    'govuk-link--inverse' if inverse
  end

  def no_underline_class(no_underline)
    'govuk-link--no-underline' if no_underline
  end
end

ActiveSupport.on_load(:action_view) { include GovukLinkHelper }
