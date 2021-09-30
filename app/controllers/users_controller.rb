class UsersController < ApplicationController
  def index
    render json: {test: "terraform_specialist", user_count: User.count}
  end
end
