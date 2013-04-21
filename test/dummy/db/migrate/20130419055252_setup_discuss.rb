class SetupDiscuss < ActiveRecord::Migration

  def change
    create_table :messages do |t|
      t.string      :subject
      t.text        :body
      t.references  :discuss_user
      t.integer     :parent_id
      t.boolean     :draft,     default: false
      t.boolean     :trashed,   default: false
      t.boolean     :deleted,   default: false
      t.datetime    :read_at

      t.timestamps
    end
    add_index :messages, :discuss_user_id

    create_table :recipients do |t|
      t.references :message
      t.references :discuss_user

      t.timestamps
    end
    add_index :recipients, :message_id
    add_index :recipients, :discuss_user_id

    create_table :discuss_users do |t|
      t.references :user, polymorphic: true
      t.string     :email
      t.string     :first_name
      t.string     :last_name

      t.timestamps
    end
    add_index :discuss_users, [:user_id, :user_type]

  end
end
