class ChangeSchemaV1 < ActiveRecord::Migration[6.0]
  def change
    create_table :todo_categories, comment: 'Associative table to link todos and categories' do |t|
      t.timestamps null: false
    end

    create_table :todo_tags, comment: 'Associative table to link todos and tags' do |t|
      t.timestamps null: false
    end

    create_table :todos, comment: 'Stores todo items created by users' do |t|
      t.text :description

      t.datetime :due_date

      t.integer :recurrence, default: 0

      t.integer :priority, default: 0

      t.boolean :is_recurring

      t.string :title

      t.timestamps null: false
    end

    create_table :categories, comment: 'Stores categories that can be assigned to todos' do |t|
      t.string :name

      t.timestamps null: false
    end

    create_table :tags, comment: 'Stores tags that can be assigned to todos' do |t|
      t.string :name

      t.timestamps null: false
    end

    create_table :users, comment: 'Stores user account information' do |t|
      t.string :password_hash

      t.string :username

      t.timestamps null: false
    end

    create_table :attachments, comment: 'Stores files attached to todo items' do |t|
      t.string :file_path

      t.timestamps null: false
    end

    add_reference :todos, :user, foreign_key: true

    add_reference :todo_categories, :todo, foreign_key: true

    add_reference :todo_tags, :todo, foreign_key: true

    add_reference :todo_categories, :category, foreign_key: true

    add_reference :todo_tags, :tag, foreign_key: true

    add_reference :attachments, :todo, foreign_key: true
  end
end
