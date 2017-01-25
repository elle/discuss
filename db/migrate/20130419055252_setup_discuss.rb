class SetupDiscuss < ActiveRecord::Migration

  def change
    create_table :discuss_messages do |t|
      t.string      :subject
      t.text        :body
      t.integer     :user_id, null: false
      t.string      :ancestry
      t.text        :draft_recipient_ids
      t.datetime    :sent_at
      t.datetime    :received_at
      t.datetime    :read_at
      t.datetime    :trashed_at
      t.datetime    :deleted_at
      t.boolean     :editable, default: true

      t.timestamps null: false
    end
    add_index :discuss_messages, :user_id
    add_index :discuss_messages, :ancestry
  end
end
