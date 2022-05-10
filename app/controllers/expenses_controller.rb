class ExpensesController < ApplicationController
  
  # before_action :set_project, only: [:index, :new, :create, :edit, :update]
  before_action :set_expense, only: [:show, :edit, :update, :destroy]
  
  def index
    @expenses = Expense.all
  end
  
  def show
  end

  def new
    @expense = Expense.new
  end

  def edit
    authorize @expense
  end

  def create
    @expense = Expense.new(expense_params)
    authorize @expense
    if  @expense.save
      flash[:notice] = "Το έξοδο δημιουργήθηκε..."
      redirect_to expenses_path
    else
      render :new 
    end
  end

  def update
    authorize @expense
    if @expense.update(expense_params)
      flash[:notice] = "Η τροποποίηση δημιουργήθηκε..."
      redirect_to expenses_path
    else
      render :edit
    end
  end

  def destroy
    authorize @expense
    @expense.destroy
    flash[:notice] = "Το έξοδο διαγράφηκε..."
    redirect_to expenses_path
  end
  
  #exports sales index
  def export
    @expenses = Expense.find( params[:expense_ids] )
    
    debugger
    
    authorize @expenses

    respond_to do |format|
      format.html
      format.xlsx
    end
  end
  
  private
  
  def set_expense
    id = params[:id]
    @expense = Expense.find(id)
  end
  
  def expense_params
    params.require(:expense).permit(:amount, :created_on, :vat, :tax, :doc_type, :doc_number, :description, :category, :is_credit, :payment_type)
  end

  
end
