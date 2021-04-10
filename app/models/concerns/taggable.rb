module Taggable
  extend ActiveSupport::Concern

  included do
    ham_many :taggeings, class_name: "#{name}Tagging"
    has_many :tags, through: :taggings
  end

  class_methods do
    def tagged_with(tag, *others, any: false)
      tags = [tag, *others]

      joins[:tags]
      .merge(reflect_on_association(:tags).klass.with_name(tags)
      .merge(
        if tags.size == 1
          all
        elsif any
          distinct
        else
          group(primary_key).having("count(*) = ?", tags.size)
        end
      )
    end
  end
end