class AddColumnsToCharges < ActiveRecord::Migration[5.2]
  def change
    add_column :pay_charges, :payment_intent, :string
    add_column :pay_charges, :captured, :boolean
  end
end
