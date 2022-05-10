class CreateExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :expenses do |t|
      
      t.decimal   :amount, default: 0.0
      t.decimal   :vat_amount, default: 0.0
      t.decimal   :tax_amount, default: 0.0
      t.decimal   :vat, default: 24.0
      t.decimal   :total_amount, default: 0.0
      t.decimal   :tax, default: 0
      t.date      :created_on
      t.string    :doc_type
      t.string    :doc_number
      t.text      :description
      t.string    :category
      t.string    :payment_type
      t.boolean   :is_credit, :default => false

      t.timestamps
    end
  end
end
