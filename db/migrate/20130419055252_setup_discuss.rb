class SetupDiscuss < ActiveRecord::Migration

  def change
    create_table :messages do |t|
      t.string      :subject
      t.text        :body
      t.integer     :discuss_user_id
      t.string      :ancestry
      t.datetime    :sent_at
      t.datetime    :received_at
      t.datetime    :read_at
      t.datetime    :trashed_at
      t.datetime    :deleted_at

      t.timestamps
    end
    add_index :messages, :discuss_user_id
    add_index :messages, :ancestry

    create_table :discuss_users do |t|
      t.references :user, polymorphic: true, default: 'User'
      t.string     :email
      t.string     :name

      t.timestamps
    end
    add_index :discuss_users, [:user_id, :user_type]

  end
end
