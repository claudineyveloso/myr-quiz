class AddCommentToCustomers < ActiveRecord::Migration[7.2]
  def change
    add_column :customers, :comment, :text
  end
end
