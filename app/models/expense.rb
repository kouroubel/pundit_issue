class Expense < ApplicationRecord

  validates :created_on, presence: true
  validates :category, presence: true
  validates :doc_type, presence: true
  validates :payment_type, presence: true
  validates :tax, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  
  validate  :doc_type_and_payment_type  #Only "Πίστωση" is allowed when doc_type is "Πιστωτικό"  
  
  before_save :calculate_vat_amount
  before_save :calculate_tax_amount
  before_save :calculate_total_amount
  
  before_save :update_is_credit
  
  attr_accessor :balance  #this adds the method :balance to Expense without the need to store it in the database (used to calculate the supplier balance in transactions)
  
  CATEGORIES = [:"Αγορά οικοπέδου", :"Οικοδομική άδεια", :"Φέρων οπλισμός", :"Τοιχοποιία", :"Ηλεκτρολογικά",
                :"Υδραυλικά", :"Θέρμανση", :"Σοβάδες", :"Μόνωση", :"Ελαιοχρωματισμοί", :"Κάγκελα-Αλουμίνια",
                :"Πλακάκια", :"Μάρμαρα", :"Εξωτερικά κουφώματα", :"Εσωτερικά κουφώματα", :"Είδη υγιεινής", :"Κουζίνες",
                :"Γυψοσανίδες", :"Διαμόρφωση εξωτερικού χώρου", :"Γενικά έξοδα", :"ΙΚΑ", :"Κατεδάφιση", :"Εκσκαφή οικοπέδου",
                :"ΔΕΗ", :"ΕΥΑΘ", :"Αέριο", :"Δήμος", :"Τηλεπικοινωνίες", :"Συμβολαιογράφοι-Δικηγόροι"]
  def self.categories
    CATEGORIES.map { |category| [category, category] }.sort
  end
  
  DOC_TYPES= [:"Τιμολόγιο - Δελτίο Αποστολής", :"Τιμολόγιο", :"Τιμολόγιο Παροχής Υπηρεσιών", :"Πιστωτικό Τιμολόγιο Επιστροφής", :"Πιστωτικό Τιμολόγιο Έκπτωσης"]
  def self.doc_types
    DOC_TYPES.map { |doc_type| [doc_type, doc_type] }
  end
  
  PAYMENT_TYPES= [:"Πίστωση", :"Μετρητά", :"Κατάθεση", :"Πιστωτική Κάρτα"]
  def self.payment_types
    PAYMENT_TYPES.map { |payment_type| [payment_type, payment_type] }
  end
  
  
  def doc_type_and_payment_type
    if (self.doc_type =="Πιστωτικό Τιμολόγιο Επιστροφής" or self.doc_type == "Πιστωτικό Τιμολόγιο Έκπτωσης" and self.payment_type != "Πίστωση")
      errors.add(:payment_type, "Ο τρόπος πληρωμής για πιστωτικό τιμολόγιο μπορεί να είναι μόνo πίστωση.")
    end
  end
  
  #this is called after an expense_item has been removed. The save will trigger update of all expense amounts
  def update_amounts(expense_item)
    self.save
  end
  

  def calculate_vat_amount
    self.vat_amount = self.amount * self.vat/100.0
  end
  
  def calculate_tax_amount
    self.tax_amount = self.amount * self.tax/100.0
  end
  
  def calculate_total_amount
    self.total_amount = self.amount + self.vat_amount - self.tax_amount
  end
  
  def update_is_credit
    if self.is_credit? then
      self.is_credit = true
    else
      self.is_credit = false
    end
  end
  
  def factor
    factor = 1.0
    
    if (self.doc_type =="Πιστωτικό Τιμολόγιο Επιστροφής" or self.doc_type == "Πιστωτικό Τιμολόγιο Έκπτωσης")
      factor = -1.0
    end
    
    factor
  end
  
  
  def is_credit?
    breturn = (self.payment_type == "Πίστωση")
    
    return breturn
  end
  
  def is_not_credit?
    breturn = (self.payment_type != "Πίστωση")
    
    return breturn
  end
  
  def create_or_update_payment
    if self.payment == nil then
      payment = Payment.new
      payment.expense_id = self.id
    else
      payment = self.payment
    end
    
    payment.amount = self.total_amount
    payment.created_on = self.created_on
    payment.supplier = self.supplier
    payment.project = self.project
    payment.category = self.category

    payment.save
  end

  scope :is_credit, -> { where(is_credit: true) }
  scope :is_not_credit, -> { where(is_credit: false) }
  scope :belongs_to_category, -> (category_name) { where("category = ?",  "#{category_name}")}   
end