# frozen_string_literal: true

module ApplicationHelper
  def markdown(text)
    options = %i[
      hard_wrap autolink no_intra_emphasis tables fenced_code_blocks
      disable_indented_code_blocks strikethrough lax_spacing space_after_headers
      quote footnotes highlight underline
    ]

    Markdown.new(text, *options).to_html
  end

  def start_index(collection)
    (collection.limit_value * collection.current_page) - collection.limit_value + 1
  end

  def filter_method_for(attribute, type)
    filter_method = filter_key_for(attribute)
    return filter_method if filter_method.present?

    suffix = type == :string ? 'cont' : 'eq'
    "#{attribute}_#{suffix}".to_sym
  end

  def predicate_choices_for(attribute, type)
    names = type == :string ? %w[cont not_cont start not_start end not_end] : %w[eq not_eq]
    predicates = names.map { |name| [Ransack::Translate.predicate(name), name] }

    filter_key = filter_key_for(attribute)
    initial_value = filter_key.present? && params[:q][filter_key].present? ? filter_key.sub(/#{attribute}_/, '') : nil
    options_for_select(predicates, initial_value)
  end

  def filter_key_for(attribute)
    return if params[:q].nil?

    params[:q].each_key.find { |k| k.match?(/#{attribute}/) }
  end
end
