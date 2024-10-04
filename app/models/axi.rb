class Axi < ApplicationRecord
  has_many :themes  
  has_many :result_quizzes

  validates :name,
            length: { maximum: 100 },
            presence: true

  scope :by_id, ->(id) { where(id: id) }


  def css_class
    case name.downcase
    when 'environmental'
      'environmental'
    when 'social'
      'social'
    when 'governance'
      'governance'
    else
      'default'
    end
  end

  def background_color
    case name.downcase
    when 'environmental'
      '#d1d58a'
    when 'social'
      '#02747F'
    when 'governança'
      '#9B5B94'
    else
      '#ffffff'
    end
  end

  def text_color_class
    case name.downcase
    when 'environmental'
      'color-environmental'
    when 'social'
      'color-social'
    when 'governança'
      'color-governanca'
    else
      'color-default'
    end
  end

  def main_theme
    themes.first.name # Exemplo de como pegar o tema principal
  end

end
