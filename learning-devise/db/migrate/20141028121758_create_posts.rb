class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, index: true
      t.string :title
      t.text :context
      t.boolean :restricted

      t.timestamps
    end
  end
end
