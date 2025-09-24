# typed: false

class MakeTitleAndDescriptionNonNullable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :communities, :title, false
    change_column_null :communities, :description, false
  end
end
