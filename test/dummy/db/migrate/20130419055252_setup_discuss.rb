class SetupDiscuss < ActiveRecord::Migration

  def change
    create_table :messages do |t|
      t.string      :subject
      t.text        :body
      t.integer     :sender_id
      t.integer     :parent_id
      t.boolean     :draft,      default: false
      t.datetime    :trashed_at
      t.datetime    :deleted_at

      t.timestamps
    end
    add_index :messages, :sender_id

    create_table :message_recipients do |t|
      t.references :message
      t.references :discuss_user
      t.datetime   :trashed_at
      t.datetime   :deleted_at
      t.datetime   :read_at

      t.timestamps
    end
    add_index :message_recipients, :message_id
    add_index :message_recipients, :discuss_user_id

    create_table :discuss_users do |t|
      t.references :user, polymorphic: true, default: 'User'
      t.string     :email
      t.string     :name

      t.timestamps
    end
    add_index :discuss_users, [:user_id, :user_type]

  end
end
