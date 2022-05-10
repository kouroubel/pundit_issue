class ExpensePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  # # def index?
  # #   @user.has_role? :admin or @user.has_role? :viewer
  # # end
  
  # # def show?
  # #   @user.has_role? :admin or @user.has_role? :viewer
  # # end
  
  # def edit?
  #   @user.has_role? :admin or @user.has_role? :user
  # end
  
  # def update?
  #   @user.has_role? :admin or @user.has_role? :user
  # end
  
  # def new?
  #   @user.has_role? :admin or @user.has_role? :user
  # end
  
  def create?
    true
  end
  
  def export?
    true
  end
  # def destroy?
  #   @user.has_role? :admin or @user.has_role? :user
  # end
  
end
