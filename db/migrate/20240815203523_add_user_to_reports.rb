class AddUserToReports < ActiveRecord::Migration[6.1]
  def change
    add_reference :reports, :user, null: false, foreign_key: true
  end
end
