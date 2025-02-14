class Allownullemailorganisation < ActiveRecord::Migration[7.2]
  def change
    change_column_default :organisations, :email, nil
    change_column_null :organisations, :email, true  # Allow NULL values
  end
end
