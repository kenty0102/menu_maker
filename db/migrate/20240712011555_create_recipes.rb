class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :image_url
      t.string :source_url
      t.string :source_site_name
      t.datetime :scraped_at

      t.timestamps
    end
  end
end
